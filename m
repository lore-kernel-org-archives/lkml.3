Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbaELPE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:04:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59224 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751839AbaELPEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:04:54 -0400
Date: Mon, 12 May 2014 17:04:51 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCHv2 00/11] improve PWM lookup support without device tree
Message-ID: <20140512150451.GD29318@piout.net>
References: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Thierry,

Do you know when you will have some time to review that patch series ?

On 14/04/2014 at 23:59:42 +0200, Alexandre Belloni wrote :
> Hi,
> 
> A patch set as suggested by Thierry to make lookup with the lookup table
> instead of device tree behave more like when using device tree.
> 
> The first patch adds a period and a polarity member to the lookup table and use
> those to set period and polarity.
> 
> Patch 2, 4 and 5 are making use of those new members from the board files.
> Patch 3 removes useless code since setting the polarity is now handled by the
> PWM core.
> 
> I couldn't decide on a good name for the extended PWM_LOOKUP macro and I believe
> we won't have to add members to that structure soon so:
> Patch 6 modifies the PWM_LOOKUP macro to also initialize period and polarity
> and
> Patch 7-9 are making use of the new PWM_LOOKUP macro in the board files
> 
> Patch 10 and 11 are making the leds-pwm and pwm_bl drivers get the period from
> the PWM before using pwm_period_ns if it is not already set.
> 
> Patch 10 will obviously conflict with the series of Russell reworking the
> leds-pwm probing. I can rebase if necessary
> 
> The final goal would be to get rid of .pwm_period_ns in leds-pwm and pwm_bl
> after moving all the remaining users (still around 25) to pwm_lookup.
> 
> Changes in v2:
>  - correctly unlock the pwm_lookup_lock mutex before returning.
>  - don't change PWM_LOOKUP atomically
>  - remove tpu_pwm_platform_data and the associated header file
>  - make the leds-pwm and pwm_bl drivers get the period from the PWM
> 
> Alexandre Belloni (11):
>   pwm: add period and polarity to struct pwm_lookup
>   ARM: shmobile: Armadillo 800 EVA: initialize all struct pwm_lookup
>     members
>   pwm: renesas-tpu: remove useless struct tpu_pwm_platform_data
>   ARM: OMAP3: Beagle: initialize all the struct pwm_lookup members
>   ARM: pxa: hx4700: initialize all the struct pwm_lookup members
>   pwm: modify PWM_LOOKUP to initialize all struct pwm_lookup members
>   ARM: OMAP3: Beagle: use PWM_LOOKUP to initialize struct pwm_lookup
>   ARM: shmobile: Armadillo 800 EVA: use PWM_LOOKUP to initialize struct
>     pwm_lookup
>   ARM: pxa: hx4700: use PWM_LOOKUP to initialize struct pwm_lookup
>   leds: leds-pwm: retrieve configured pwm period
>   backlight: pwm_bl: retrieve configured pwm period
> 
>  Documentation/pwm.txt                          |  3 ++-
>  arch/arm/mach-omap2/board-omap3beagle.c        |  3 ++-
>  arch/arm/mach-pxa/hx4700.c                     |  3 ++-
>  arch/arm/mach-shmobile/board-armadillo800eva.c | 14 +++-----------
>  drivers/leds/leds-pwm.c                        |  5 ++++-
>  drivers/pwm/core.c                             |  8 +++++++-
>  drivers/pwm/pwm-renesas-tpu.c                  | 19 +++----------------
>  drivers/video/backlight/pwm_bl.c               |  8 +++++---
>  include/linux/platform_data/pwm-renesas-tpu.h  | 16 ----------------
>  include/linux/pwm.h                            |  6 +++++-
>  10 files changed, 33 insertions(+), 52 deletions(-)
>  delete mode 100644 include/linux/platform_data/pwm-renesas-tpu.h
> 
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-leds" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
