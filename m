Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab3BVUOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:14:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:60315 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab3BVUOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:14:22 -0500
Date: Fri, 22 Feb 2013 21:14:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        x86@kernel.org
Subject: Re: [PATCH] x86, clocksource, fix !CONFIG_CLOCKSOURCE_WATCHDOG
 compile
In-Reply-To: <1361563736-28241-1-git-send-email-prarit@redhat.com>
Message-ID: <alpine.LFD.2.02.1302222111400.22263@ionos>
References: <1361563736-28241-1-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Prarit Bhargava wrote:

> If I explicitly disable the clocksource watchdog in the x86 Kconfig,
> the x86 kernel will not compile unless this is properly defined.

You shouldn't do that. :)
 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: x86@kernel.org
> ---
>  kernel/time/clocksource.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index c958338..e04821f 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -450,6 +450,7 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
>  static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
>  static inline void clocksource_resume_watchdog(void) { }
>  static inline int clocksource_watchdog_kthread(void *data) { return 0; }
> +void clocksource_mark_unstable(struct clocksource *cs) { }

Unless this is defined as

> +static inline void clocksource_mark_unstable(struct clocksource *cs) { }

Right?

	tglx
