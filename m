Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbbAPUYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:24:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbbAPUYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:24:06 -0500
Date: Fri, 16 Jan 2015 12:24:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: Re: Issue with 'lib/vsprintf.c: don't try to fix pointer
 wrap-around'
Message-Id: <20150116122404.e82eb86b5c46afdd0d00df1d@linux-foundation.org>
In-Reply-To: <20150116162357.GA10859@phnom.home.cmpxchg.org>
References: <20150116162357.GA10859@phnom.home.cmpxchg.org>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015 11:23:57 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Hi Rasmus,
> 
> I have trouble booting my test machine with this patch in -mm:
> 
> commit bb2e066c6943e62e9650bb129f416dacf138f8b1
> Author: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Date:   Wed Jan 14 01:00:44 2015 +0000
> 
>     lib/vsprintf.c: don't try to fix pointer wrap-around
>     
>     Actual kernel buffers can't wrap into the user address space.  If someone
>     manages to pass a buf/size combination that wraps, it is most likely due
>     to a bug in the caller.  Instead of trying to fix it by using a smaller
>     part of the buffer, bail out.
>     
>     Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>     Cc: Jiri Kosina <jkosina@suse.cz>
>     Cc: Randy Dunlap <rdunlap@infradead.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> After I get "Loading bzImage-new... ok" from the bootloader, the
> serial console remains quiet.
> 
> A WARN_ON_ONCE() inside vsnprintf() looks like it would deadlock
> instantly when triggering this overflow from printk(), no?

Dammit, I was starting at that printk, ended up deciding it was OK,
didn't think about deadlocks.  logbuf_lock and recursion_bug, for a
start...

I'll drop the patch.  I assume all this means that your machine is
trying to trigger that warning condition?  I wonder what the call
site is.

