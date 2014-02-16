Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaBPPju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 10:39:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:49371 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaBPPjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 10:39:49 -0500
Date: Sun, 16 Feb 2014 16:39:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
In-Reply-To: <5300D752.5030403@samsung.com>
Message-ID: <alpine.DEB.2.02.1402161634590.21991@ionos.tec.linutronix.de>
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com> <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com> <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de> <52F1DDA8.90605@samsung.com> <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de>
 <52F2B504.5010403@linaro.org> <alpine.DEB.2.02.1402052306580.24986@ionos.tec.linutronix.de> <52F3C8A5.708@samsung.com> <alpine.DEB.2.02.1402062148440.21991@ionos.tec.linutronix.de> <5300D752.5030403@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Feb 2014, Alexey Perevalov wrote:
> As I understand main idea in hrtimer.c was do not decrement expires_next in
> case of DEFERRABLE timers type.
> Such small average delay could be explained: it's due higher resolution, and
> cpu is not in idle when we in hrtimer_interrupt,
> with timer_list decrementing process not so often.
> In this case it's hard to me to explain such small "time delta", it occurs
> almost every time we have larger delay.

Well, the point of deferrable timers is that they get executed, when
the cpu is not idle, i.e. running some other timers as well

I did not test my patch and I have no idea whether it really does what
it should do, but tracing should tell you rather fast.

So w/o instrumenting the kernel you can't tell why a timer is
expired. Just looking at random numbers does not help. You need to
create a proper test scenario which makes sure that the system goes
into an extended nohz idle and then check whether the timers are
deferred over that idle time.

Thanks,

	tglx

