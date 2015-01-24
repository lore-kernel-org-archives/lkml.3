Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbbAXTVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 14:21:22 -0500
Received: from www.linutronix.de ([62.245.132.108]:41072 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbbAXTVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 14:21:20 -0500
Date: Sat, 24 Jan 2015 20:20:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Church <dchurch@andplus.com>
cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Subject: Re: [PATCH v2 2/2] posix-timers: Exposes DELAYTIMER_MAX constant
 used to govern overruns
In-Reply-To: <1422121737-3686-3-git-send-email-dchurch@andplus.com>
Message-ID: <alpine.DEB.2.11.1501242015260.5526@nanos>
References: <[PATCH 0/2] posix-timers: Prevents overrun counter overflow, adds DELAYTIMER_MAX> <1422121737-3686-1-git-send-email-dchurch@andplus.com> <1422121737-3686-3-git-send-email-dchurch@andplus.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2015, Daniel Church wrote:

> POSIX.1-2001 specification of timer_getoverrun() supports constant
> DELAYTIMER_MAX which prevents overflow and caps overrun count.  Exposes
> delaytimer_max value to userland via /proc/sys/kernel/delaytimer_max such

I know that you try to match the posix name, but when looking at the
prctl w/o knowing about DELAYTIMER_MAX, it's non intuitive.

Something like posixtimer_max_overruns or if you insist on the
delaytimer_max part, then let us prepend it with posixtimer_ at least.

New prctls require an update of Documentation/sysctl/kernel.txt.

Thanks,

	tglx


