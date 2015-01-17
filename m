Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbbAQCEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 21:04:07 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:47554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbAQCEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 21:04:05 -0500
Date: Fri, 16 Jan 2015 18:04:01 -0800
From: Darren Hart <dvhart@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        Darren Hart <darren@dvhart.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] futex: Fix argument handling in futex_lock_pi() calls
Message-ID: <20150117020401.GB6494@vmdeb7>
References: <54B96646.8010200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B96646.8010200@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 08:28:06PM +0100, Michael Kerrisk (man-pages) wrote:
> From: Michael Kerrisk <mtk.manpages@gmail.com>
> 
> This patch fixes two separate buglets in calls to futex_lock_pi():
> 
>   * Eliminate unused 'detect' argument
>   * Change unused 'timeout' argument of FUTEX_TRYLOCK_PI to NULL

One might argue these should be two separate fixes. Since both are trivial and functional
no-ops, I'm going to ignore it and consider it a "cleanup" :-) Thomas may
disagree.

> 
> The 'detect' argument of futex_lock_pi() seems never to have been
> used (when it was included with the initial PI mutex implementation
> in Linux 2.6.18, all checks against its value were disabled by
> ANDing against 0 (i.e., if (detect... && 0)), and with
> commit 778e9a9c3e7193ea9f434f382947155ffb59c755, any mention of
> this argument in futex_lock_pi() went way altogether. Its presence
> now serves only to confuse readers of the code, by giving the
> impression that the futex() FUTEX_LOCK_PI operation actually does
> use the 'val' argument. This patch removes the argument.
> 
> The futex_lock_pi() call that corresponds to FUTEX_TRYLOCK_PI includes
> 'timeout' as one of its arguments. This misleads the reader into thinking
> that the FUTEX_TRYLOCK_PI operation does employ timeouts for some sensible
> purpose; but it does not.  Indeed, it cannot, because the checks at the
> start of sys_futex() exclude FUTEX_TRYLOCK_PI from the set of operations
> that do copy_from_user() on the timeout argument. So, in the
> FUTEX_TRYLOCK_PI futex_lock_pi() call it would be simplest to change
> 'timeout' to 'NULL'. This patch does that.
> 
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

Good and correct changes each.

Reviewed-by: Darren Hart <dvhart@linux.intel.com>

Thanks Michael,

-- 
Darren Hart
Intel Open Source Technology Center
