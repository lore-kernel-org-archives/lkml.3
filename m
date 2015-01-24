Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbbAXQbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 11:31:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:40739 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbbAXQbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 11:31:48 -0500
Date: Sat, 24 Jan 2015 17:31:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Church <dchurch@andplus.com>
cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Subject: Re: [PATCH 1/2] posix-timers: Prevents overrun counter overflow
In-Reply-To: <1422036211-10934-2-git-send-email-dchurch@andplus.com>
Message-ID: <alpine.DEB.2.11.1501241729260.5526@nanos>
References: <1422036211-10934-1-git-send-email-dchurch@andplus.com> <1422036211-10934-2-git-send-email-dchurch@andplus.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Daniel Church wrote:
> +	overruns = (unsigned int) hrtimer_forward(timer,
> +					timer->base->get_time(),
> +					timr->it.real.interval);
> +	if (overruns >= delaytimer_max ||
> +		(timr->it_overrun >= 0 &&
> +		 timr->it_overrun >= delaytimer_max - overruns)) {
> +		timr->it_overrun = delaytimer_max;
> +	} else {
> +		timr->it_overrun += overruns;
> +	}

We certainly do not add the same logic 3 times via copy and
paste. Please make that a proper helper function.

Thanks,

	tglx
