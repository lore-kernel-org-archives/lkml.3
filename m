Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaJACci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 22:32:38 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:43296 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaJACcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 22:32:36 -0400
Message-ID: <542B67C1.9080303@gmail.com>
Date: Tue, 30 Sep 2014 22:32:33 -0400
From: Daniel Micay <danielmicay@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Evans <jasone@canonware.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v3] mm: add mremap flag for preserving the old mapping
References: <1412052900-1722-1-git-send-email-danielmicay@gmail.com> <CALCETrX6D7X7zm3qCn8kaBtYHCQvdR06LAAwzBA=1GteHAaLKA@mail.gmail.com> <542A79AF.8060602@gmail.com> <CALCETrVHgvhAN3neoOpJEk94uM7QKm2izZpp+=1UA6qieaQiTQ@mail.gmail.com>
In-Reply-To: <CALCETrVHgvhAN3neoOpJEk94uM7QKm2izZpp+=1UA6qieaQiTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/14 01:49 PM, Andy Lutomirski wrote:
> 
> I think it might pay to add an explicit vm_op to authorize
> duplication, especially for non-cow mappings.  IOW this kind of
> extension seems quite magical for anything that doesn't have the
> normal COW semantics, including for plain old read-only mappings.

This sounds like the best way forwards.

Setting up the op for private, anonymous mappings and having it check
vm_flags & VM_WRITE dynamically seems like it would be enough for the
intended use case in general purpose allocators. It can be extended to
other mapping types later if there's a compelling use case.
