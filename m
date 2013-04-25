Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab3DYAyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 20:54:08 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38068 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211Ab3DYAyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 20:54:05 -0400
Date: Thu, 25 Apr 2013 09:54:02 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 0/9] TPU PWM support
Message-ID: <20130425005402.GA21277@verge.net.au>
References: <1366761969-16759-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20130424074044.GD847@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130424074044.GD847@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 04:40:44PM +0900, Simon Horman wrote:
> On Wed, Apr 24, 2013 at 02:06:00AM +0200, Laurent Pinchart wrote:
> > Hello,
> > 
> > This patch set adds support for the TPU PWM unit found in the sh73a0 and
> > r8a7740 SoCs. It deprecates and removes the leds-renesas-tpu driver in favor
> > of a combination of leds-pwm and pwm-rmob.
> > 
> > I've tested the code on Armadillo only as I don't have access to a kota2
> > board. This is why I've added backlight support to Armadillo as part of this
> > set.
> > 
> > As an added bonus patches 7/9 and 8/9 remove function GPIOs support from the
> > sh73a0 platform. Along with the other PFC-related patches recently posted on
> > the list, mach-shmobile is now free of function GPIOs. Any volunteer to
> > migrate arch/sh ? :-)
> > 
> > The patches are based on a merge of "[PATCH 00/37] Fully migrate r8a7740 to
> > pinctrl", "[PATCH 0/4] sh73a0: Expose the PFC-controller SDHI power gate as a
> > regulator" and "[PATCH] sh-pfc: r8a7740: Add bias (pull-up/down) pinconf
> > support".
> > 
> > Laurent Pinchart (9):
> >   sh-pfc: sh73a0: Add TPU pin groups and functions
> >   sh-pfc: r8a7740: Add TPU pin groups and functions
> >   pwm: Add Renesas Mobile TPU PWM driver
> >   ARM: mach-shmobile: clock-r8a7740: add TPU PWM support
> >   ARM: mach-shmobile: armadillo800eva: Add backlight support
> >   ARM: mach-shmobile: kota2: Use leds-pwm + pwm-rmob
> >   sh-pfc: sh73a0: Remove function GPIOs
> >   ARM: shmobile: sh73a0: Remove all GPIOs
> >   leds: Remove leds-renesas-tpu driver
> > 
> >  arch/arm/mach-shmobile/board-armadillo800eva.c |  51 ++-
> >  arch/arm/mach-shmobile/board-kota2.c           | 178 +++++---
> >  arch/arm/mach-shmobile/clock-r8a7740.c         |   4 +-
> >  arch/arm/mach-shmobile/clock-sh73a0.c          |   8 +-
> >  arch/arm/mach-shmobile/include/mach/sh73a0.h   | 373 +--------------
> >  drivers/leds/Kconfig                           |  12 -
> >  drivers/leds/Makefile                          |   1 -
> >  drivers/leds/leds-renesas-tpu.c                | 336 --------------
> >  drivers/pinctrl/sh-pfc/pfc-r8a7740.c           |  50 ++
> >  drivers/pinctrl/sh-pfc/pfc-sh73a0.c            | 608 +++++++++----------------
> >  drivers/pwm/Kconfig                            |   7 +
> >  drivers/pwm/Makefile                           |   1 +
> >  drivers/pwm/pwm-rmob.c                         | 462 +++++++++++++++++++
> >  include/linux/platform_data/leds-renesas-tpu.h |  14 -
> >  include/linux/platform_data/pwm-rmob.h         |  18 +
> >  15 files changed, 913 insertions(+), 1210 deletions(-)
> >  delete mode 100644 drivers/leds/leds-renesas-tpu.c
> >  create mode 100644 drivers/pwm/pwm-rmob.c
> >  delete mode 100644 include/linux/platform_data/leds-renesas-tpu.h
> >  create mode 100644 include/linux/platform_data/pwm-rmob.h
> 
> I have rebased the pinmux branch on renesas-boards3-for-v3.10 to
> supply dependencies. That tag includes the renesas-pinmux2-for-v3.10
> tag which the pinmux branch was previously based on.
> 
> I have applied this entire series on the resulting pinmux branch.
> 
> I plan to push this when I tag renesas-next-20130424 later today.
> If not I will tag and push renesas-next-20130425 tomorrow.   

As there has been subsequent discussion and a v2 of this series posted, and
I have dropped the "[PATCH 0/4] sh73a0: Expose the PFC-controller SDHI
power gate as a regulator" series for similar reasons; I have dropped these
patches for now.

