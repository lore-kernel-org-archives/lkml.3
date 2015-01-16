Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbbAPKXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:23:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:33034 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbAPKXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:23:53 -0500
Date: Fri, 16 Jan 2015 11:23:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] clocksource: don't suspend/resume when unused
In-Reply-To: <1421399874-29119-3-git-send-email-alexandre.belloni@free-electrons.com>
Message-ID: <alpine.DEB.2.11.1501161122320.5526@nanos>
References: <1421399874-29119-1-git-send-email-alexandre.belloni@free-electrons.com> <1421399874-29119-3-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Alexandre Belloni wrote:

> There is no point in calling suspend/resume for unused
> clocksources.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  kernel/time/clocksource.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 920a4da58eb0..baea4e42ae90 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -493,7 +493,7 @@ void clocksource_suspend(void)
>  	struct clocksource *cs;
>  
>  	list_for_each_entry_reverse(cs, &clocksource_list, list)
> -		if (cs->suspend)
> +		if (cs->suspend && (cs->flags & CLOCK_SOURCE_USED))
>  			cs->suspend(cs);

This might be dangerous. If the clocksource has no enable/disable
callbacks, but suspend/resume, then you might leave it enabled across
suspend.

Thanks,

	tglx

