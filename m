Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaIHGP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:15:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaIHGP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:15:56 -0400
Date: Mon, 8 Sep 2014 08:15:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Anand Moon <moon.linux@yahoo.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix add missing include guard
Message-ID: <20140908061552.GQ19379@twins.programming.kicks-ass.net>
References: <1410106356-3543-1-git-send-email-moon.linux@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410106356-3543-1-git-send-email-moon.linux@yahoo.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2014 at 09:42:36PM +0530, Anand Moon wrote:
> If a header file happens to be included twice, the compiler will process
> its contents twice. This is very likely to cause an error, e.g. when the
> compiler sees the same structure definition twice. Even if it does not,
> it will certainly waste time.



> --- a/kernel/locking/lockdep_states.h
> +++ b/kernel/locking/lockdep_states.h
> @@ -4,6 +4,12 @@
>   * please update XXX_LOCK_USAGE_STATES in include/linux/lockdep.h whenever
>   * you add one, or come up with a nice dynamic solution.
>   */
> +
> +#ifndef __LOCKDEPSTATE_H__
> +#define __LOCKDEPSTATE_H__
> +
>  LOCKDEP_STATE(HARDIRQ)
>  LOCKDEP_STATE(SOFTIRQ)
>  LOCKDEP_STATE(RECLAIM_FS)
> +
> +#endif /* __LOCKDEPSTATE_H__ */


That file is actually designed to be included multiple times; you
clearly didn't understand what you were doing.
