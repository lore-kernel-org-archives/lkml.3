Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab3GPOsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:48:03 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64580 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab3GPOsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:48:00 -0400
Message-ID: <51E55D1D.6080809@linaro.org>
Date: Tue, 16 Jul 2013 16:47:57 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCHv5 00/10] clocksource: sunxi: Timer fixes and cleanup
References: <1373560282-15184-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1373560282-15184-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 06:31 PM, Maxime Ripard wrote:

Applied to my tree for 3.12.

Thanks
  -- Daniel


> Hi everyone,
> 
> The first timer code we merged when adding support for the A13 some
> time back was mostly a clean up from the source drop we had, without
> any documentation.  This happened to work, but the code merged in
> turned out to be far from perfect, and had several flaws.
> 
> This patchset hopefully fixes these flaws, and cleanup most of the
> driver as well, to end up in an almost complete rewrite of it (even
> though it's not that long).
> 
> It also finally adds a clocksource driver using the second timer as
> our monotonic clock source.
> 
> These flaws have all been spotted when trying to add the A31 support,
> work that is still ongoing, but will hopefully benefit from this
> patchset as well.
> 
> Thanks,
> Maxime
> 
> Changes from v4:
>   - Removed the last clk_get_rate() user
>   - Got a few beers
> 
> Changes from v3:
>   - Reintroduce the rate variable to cache the parent clock rate
>   - Remove the interval programming at probe time that was
>     reintroduced in the v3 due to a poor rebase.
> 
> Changes from v2:
>   - Use the clocksource timer to get the amount of time we have to
>     wait for when disabling and enabling back a timer
>   - Added patch to add parenthesis around the macros arguments
>   - Renamed the AUTORELOAD register define to the more meaningful
>     RELOAD name
> 
> Changes from v1:
>   - Rebased on top of linux-next to benefit from the move to all
>     architectures of the sched_clock functions
>   - Moved the clock source to the second timer instead of the 64 bits
>     free-running counter like suggested by Thomas.
> 
> Maxime Ripard (10):
>   clocksource: sun4i: Use the BIT macros where possible
>   clocksource: sun4i: Wrap macros arguments in parenthesis
>   clocksource: sun4i: rename AUTORELOAD define to RELOAD
>   clocksource: sun4i: Add clocksource and sched clock drivers
>   clocksource: sun4i: Don't forget to enable the clock we use
>   clocksource: sun4i: Fix the next event code
>   clocksource: sun4i: Factor out some timer code
>   clocksource: sun4i: Remove TIMER_SCAL variable
>   clocksource: sun4i: Cleanup parent clock setup
>   clocksource: sun4i: Fix bug when switching from periodic to oneshot
>     modes
> 
>  drivers/clocksource/sun4i_timer.c | 110 +++++++++++++++++++++++++++-----------
>  1 file changed, 78 insertions(+), 32 deletions(-)
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

