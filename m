Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaESWjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:39:21 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:57747 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaESWjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:39:18 -0400
Date: Tue, 20 May 2014 07:39:13 +0900
From: Simon Horman <horms@verge.net.au>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Magnus Damm <magnus.damm@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv2 resend 00/11] improve PWM lookup support without device
 tree
Message-ID: <20140519223913.GE20590@verge.net.au>
References: <1400532162-29483-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400532162-29483-1-git-send-email-alexandre.belloni@free-electrons.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CCed Laurent Pinchart ]

The renesas and shmobile portions of this seem reasonable to me
and I have checked that there do not seem to be any conflicts
with changes I already have queued up for v3.16 (and v3.17).

I have CCed Laurent Pinchart as I believe he most recently
did work on the renesas and shmobile code in question.

On Mon, May 19, 2014 at 10:42:31PM +0200, Alexandre Belloni wrote:
> Hi,
> 
> Originally sent on Apr 14th, note that this series is blocking another 16
> patches series, I would like it to be taken in 3.16 if we can agree on this
> implementation.
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

The above two patches:
Acked-by: Simon Horman <horms+renesas@verge.net.au>

>   ARM: OMAP3: Beagle: initialize all the struct pwm_lookup members
>   ARM: pxa: hx4700: initialize all the struct pwm_lookup members
>   pwm: modify PWM_LOOKUP to initialize all struct pwm_lookup members
>   ARM: OMAP3: Beagle: use PWM_LOOKUP to initialize struct pwm_lookup
>   ARM: shmobile: Armadillo 800 EVA: use PWM_LOOKUP to initialize struct
>     pwm_lookup

The above patch:
Acked-by: Simon Horman <horms+renesas@verge.net.au>

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
