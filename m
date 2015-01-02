Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbbABVUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:20:25 -0500
Received: from gloria.sntech.de ([95.129.55.99]:60291 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbbABVUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:20:24 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Mike Turquette <mturquette@linaro.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: rockchip: rk3288: Make s2r reliable by switching PLLs to slow mode
Date: Fri, 02 Jan 2015 22:20:12 +0100
Message-ID: <2520772.QQVueoUhik@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1419276708-28294-1-git-send-email-dianders@chromium.org>
References: <1419276708-28294-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 22. Dezember 2014, 11:31:48 schrieb Doug Anderson:
> We've been seeing some crashes at resume time on rk3288-based systems.
> On some machines they simply never wake up from suspend.  Symptoms
> include:
> 
> - System clearly got to sleep OK.  Power consumption is low, the PWM
>   for the PWM regulator has stopped, and the "global_pwroff" output
>   shows that the system is down.
> 
> - When system tries to wake up power consumption goes up.
> 
> - No kernel resume code (which was left in PMU SRAM) ran.  We added
>   some basic logging to this code (write to a location in SRAM right
>   at resume time) and didn't see the logging run.
> 
> It appears that we can fix the problem by slowing down APLL before we
> suspend.  On the system I tested things seemed reliable if I disabled
> 1.8GHz and 1.7GHz.  The Mask ROM itself tries to slow things down
> (which is why PLLs are in slow mode by the time we get to the kernel),
> but apparently it is crashing before it even gets there.
> 
> We'll be super paranoid and not just go down to 1.6GHz but we'll match
> what the Mask ROM seems to be doing and go into slow mode.  We'll also
> be safe and put all PLLs (not just APLL) into slow mode (well, except
> DPLL which is needed for SDRAM).  We'll even put NPLL into slow mode
> which the Mask ROM didn't do (not that it's used for much important
> stuff at early resume time).
> 
> Note that the old Rockchip reference code did something just like
> this, though they jammed it into pm.c instead of putting it in the
> syscore ops of the clock driver.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

applied to my clk branch for 3.20

As I already talked about with Doug on IRC (last year), I see this as a sort-
of stop-gap solution till we know the suspend requirements of the older/other 
Rockchip SoCs that do suspend slightly different and can generalize the whole 
clk suspend handling at this point.


Heiko
