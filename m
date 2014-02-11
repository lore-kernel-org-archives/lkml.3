Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaBKLk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:40:57 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:35135 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaBKLkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:40:55 -0500
Date: Tue, 11 Feb 2014 11:40:48 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] mfd: dbx500/abx500: root out hardcoded IRQ assignments
Message-ID: <20140211114048.GO32042@lee--X1>
References: <1392114599-481-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392114599-481-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The DBx500 and ABx500 should be getting their IRQs from the
> device tree and nowhere else. Get rid of all the static assignments
> everywhere, delete it from the driver, platform data and the
> board files in one swift strike.
> 
> Lots of cross-dependencies in the MFD drivers for PRCMU and
> AB8500 makes it necessary to strike everywhere at once to
> eradicate IRQs passed as resources and platform data to the left
> and right around the platform.
> 
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Sam/Lee: I'm looking for an ACK on this to take the result through
> ARM SoC.

Actually I have a better idea. Gather all of the Acks/head-nods you
need and I'll create an immutable branch for the pair of us to pull
from.

> I've been ambivalent on how to look up the IRQ resource for the
> AB8500 from the device tree (as it is hanging off the main GIC
> interrupt controller rather than the PRCMU) and eventually ended
> up with this solution. I experimented with modifying mfd-core.c
> to add resources from the device tree, but I didn't like the
> result, it seems MFD cells should get their resources exclusively
> from the parent instantiating the cell, so I ended up with this.

Well no one knows that h/w better than you do and the code looks fine
to be taking into account it _is_ the SoC and the relationship between
the AB8500 and DB8500.

> Maybe Broonie has ideas about this too?
> ---
>  arch/arm/mach-ux500/board-mop500-audio.c |   1 -
>  arch/arm/mach-ux500/cpu-db8500.c         |   4 -
>  arch/arm/mach-ux500/irqs-board-mop500.h  |  55 --------------
>  arch/arm/mach-ux500/irqs-db8500.h        | 125 -------------------------------
>  arch/arm/mach-ux500/irqs.h               |  49 ------------
>  drivers/mfd/ab8500-core.c                |  27 +++----
>  drivers/mfd/db8500-prcmu.c               |  34 ++++++---
>  include/linux/mfd/abx500/ab8500.h        |   2 -
>  include/linux/mfd/dbx500-prcmu.h         |   2 -
>  9 files changed, 36 insertions(+), 263 deletions(-)
>  delete mode 100644 arch/arm/mach-ux500/irqs-board-mop500.h
>  delete mode 100644 arch/arm/mach-ux500/irqs-db8500.h
>  delete mode 100644 arch/arm/mach-ux500/irqs.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
