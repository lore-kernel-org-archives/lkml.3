Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaJUKT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:19:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:58430 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaJUKT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:19:58 -0400
Date: Tue, 21 Oct 2014 12:19:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 1/2] time: Fix NTP adjustment mult overflow.
In-Reply-To: <1412838271-11175-1-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1410211210000.5308@nanos>
References: <1412838271-11175-1-git-send-email-pang.xunlei@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2014, pang.xunlei wrote:

First of all: Please use proper line breaks in the changelog.

> The mult memember of struct clocksource should always be a large u32
> number when calculated through __clocksource_updatefreq_scale(). The
> value of (cs->mult+cs->maxadj) may have a chance to reach very near
> 0xFFFFFFFF.

And what's the actual problem with reaching a value near 0xFFFFFFFF?

> For instance, 555MHz oscillator: cs->mult is 0xE6A17102,
> cs->maxadj is 0x195E8EFD, cs->mult+cs->maxadj is 0xFFFFFFFF. Such
> oscillators would probably exist on some processors like MIPS which
> use CP0 compare/count CPU clock as the clock source.

Again, what's the problem?

> Clocksource might encounter large frequency adjustment due to the
> hardware unstability, environment temperature, software deviation,
> NTP algorithm accuracy, etc. When NTP slewes the clock, kernel goes
> through update_wall_time()->...->timekeeping_apply_adjustment():
> tk->tkr.mult += mult_adj; Unfortunately, tk->tkr.mult may overflow
> after this operation, though such cases are next to impossible to
> happen in practice.

So you adding this just for correctness reasons, not because you
observed the problem in practice?

Thanks,

	tglx
