Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaJAVH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:07:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaJAVH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:07:26 -0400
Date: Wed, 1 Oct 2014 14:07:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        mgorman@suse.de
Subject: Re: [PATCH 0/5] mm: poison critical mm/ structs
Message-Id: <20141001140725.fd7f1d0cf933fbc2aa9fc1b1@linux-foundation.org>
In-Reply-To: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com>
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 21:47:14 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> Currently we're seeing a few issues which are unexplainable by looking at the
> data we see and are most likely caused by a memory corruption caused
> elsewhere.
> 
> This is wasting time for folks who are trying to figure out an issue provided
> a stack trace that can't really point out the real issue.
> 
> This patch introduces poisoning on struct page, vm_area_struct, and mm_struct,
> and places checks in busy paths to catch corruption early.
> 
> This series was tested, and it detects corruption in vm_area_struct. Right now
> I'm working on figuring out the source of the corruption, (which is a long
> standing bug) using KASan, but the current code is useful as it is.

Is this still useful if/when kasan is in place?

It looks fairly cheap - I wonder if it should simply fall under
CONFIG_DEBUG_VM rather than the new CONFIG_DEBUG_VM_POISON.

