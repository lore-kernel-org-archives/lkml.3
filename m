Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628Ab3JORxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:53:17 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63234 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013Ab3JORxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:53:15 -0400
Message-ID: <525D8106.9020304@zankel.net>
Date: Tue, 15 Oct 2013 10:53:10 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>
Subject: Re: CONFIG_SLUB/USE_SPLIT_PTLOCKS compatibility
References: <CAMo8BfKqWPbDCMwCoH6BO6uXyYwr0Z1=AaMJDRLQt66FLb7LAg@mail.gmail.com> <20131014071205.GA23735@shutemov.name> <CAMo8Bf+9+_S0HeOUWjd3AXgsuM-XWYZx8b6aL=2+AFt0EK9DKg@mail.gmail.com>
In-Reply-To: <CAMo8Bf+9+_S0HeOUWjd3AXgsuM-XWYZx8b6aL=2+AFt0EK9DKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 04:49 AM, Max Filippov wrote:
> Buddy allocator was used here prior to commit 6656920 [XTENSA] Add
> support for cache-aliasing I can only guess that the change was made
> to make allocated page tables have the same colour, but am not sure
> why this is needed. Chris? 
Max, I think you are right that in an earlier attempt to support cache
aliasing, we tried to allocate pages with the correct 'color', and
cached pages locally (if I remember correctly). The approach we use now
doesn't require that so the suggested patches are fine. (Note that cache
aliasing support hasn't been committed to mainline yet)

Thanks,
-Chris

