Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbbAZNuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:50:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:60492 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbAZNuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:50:09 -0500
Date: Mon, 26 Jan 2015 14:50:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/32] lib/vsprintf: implement bitmap printing through
 '%*pb[l]'
Message-ID: <20150126135005.GG23123@twins.programming.kicks-ass.net>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
 <1422108218-25398-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422108218-25398-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 09:03:08AM -0500, Tejun Heo wrote:

> There have been a couple different attempts at making this easier.
> 
> 1. Way back, PeterZ tried printk '%pb' extension with the precision
>    for bit width - '%.*pb'.  This was intuitive and made sense but
>    unfortunately triggered a compile warning about using precision
>    for a pointer.
> 
>    http://lkml.kernel.org/g/1336577562.2527.58.camel@twins

> So, this patch is another attempt at teaching printk and friends how
> to print bitmaps.  It's almost identical to what PeterZ tried with
> precision but it uses the field width for the number of bits instead
> of precision.  The format used is '%*pb[l]', with the optional
> trailing 'l' specifying list format instead of hex masks.

> This is a valid format string and doesn't trigger compiler warnings;
> however, it does make it impossible to specify output field width when
> printing bitmaps.

> I think this is an acceptable trade-off given how
> much easier it makes printing bitmaps and that we don't have any
> in-kernel user which is using the field width specification.

Yeah, I suppose this is indeed the best we can do; and loosing the width
thing (which is a rarely used feature for in kernel things) seems
acceptable indeed. We did mention the option back then, but didn't
pursue it.

I like the extra 'l' fmt option.

> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
