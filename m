Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3I0SIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:08:51 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:46635 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3I0SIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:08:49 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, r.sricharan@ti.com, holler@ahsoftware.de
Subject: Re: [PATCH 1/2] gpio/omap: maintain GPIO and IRQ usage separately
References: <1380069414-2922-1-git-send-email-javier.martinez@collabora.co.uk>
Date: Fri, 27 Sep 2013 11:08:43 -0700
In-Reply-To: <1380069414-2922-1-git-send-email-javier.martinez@collabora.co.uk>
	(Javier Martinez Canillas's message of "Wed, 25 Sep 2013 02:36:52
	+0200")
Message-ID: <87r4cajfx0.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier Martinez Canillas <javier.martinez@collabora.co.uk> writes:

> The GPIO OMAP controller pins can be used as IRQ and GPIO
> independently so is necessary to keep track GPIO pins and
> IRQ lines usage separately to make sure that the bank will
> always be enabled while being used.
>
> Also move gpio_is_input() definition in preparation for the
> next patch that setups the controller's irq_chip driver when
> a caller requests an interrupt line.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

I'm fine with this appproach.  For both patches:

Reviewed-by: Kevin Hilman <khilman@linaro.org>

Also, I gave it a spin across a handful of OMAP boards using v3.12-rc2 +
these 2 patches.

Boot tested successfully with DT boot:

omap3530/beagle
omap3730/beagle-xm
omap3530/overo (Tobi w/GPIO IRQ networking)
omap3730/overo STORM (w/GPIO IRQ for networking)
am335x/beaglebone
am335x/beaglebone black
omap4430/panda
omap4460/panda-es
omap5912/OSK (omap1)

I also verified non-DT boot on the OMAP3 platforms that still support
legacy boot.

So feel free to also add

Tested-by: Kevin Hilman <khilman@linaro.org>

Thanks for your persistence in getting a fix for this upstream.

Kevin
