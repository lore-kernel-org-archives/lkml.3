Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaJTT4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:56:52 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:60659 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaJTT4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:56:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Branden <sbranden@broadcom.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: Re: [PATCH v5 1/6] ARM: cygnus: Initial support for Broadcom Cygnus SoC
Date: Mon, 20 Oct 2014 21:55:57 +0200
Message-ID: <4779079.vI0gT0iWvg@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413341936-17606-2-git-send-email-sbranden@broadcom.com>
References: <1413341936-17606-2-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:K1XfhD7DcUXmvEwo5FIc8/5htFoqWuOPP+x/i+hEtrD
 I8sYp/yFIsILpaE9mWw3aCpEl+pZE5O2teF5XLUifr9zqbWWro
 QfQJTa3pePCpAB5QOGOAGa2YaP1wEEBpzNwIoJGzA/W8SH2Vtt
 qg69OZKvyjhTAqIF7i6SincGWXEDNH1/iA9QidaKQq/AZgTEg3
 t1sSvBgTuwbExxs+8wySeAny3w0DW+mKqlsz901Dv0s5I/JZWI
 ZIKu9nlUzXN/RXHv2H/EuAGelLlSq+iz2SKQD+Wta6KLh4HqUE
 Bn9c0QjSmcg7wXB4mhEBQsDxeF0Qgw/uz4qAUag5yK2H+9nzr0
 yto0WtBEgITSykx/RNkc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 October 2014 19:58:51 Scott Branden wrote:
>  if ARCH_BCM
>  
> +menu "iProc SoC based Machine types"
> +       config ARCH_BCM_IPROC
> +               bool
> +               select ARM_GIC
> +               select CACHE_L2X0
> +               select HAVE_ARM_SCU if SMP
> +               select HAVE_ARM_TWD if SMP
> +               select ARM_GLOBAL_TIMER
> +
> +               select CLKSRC_MMIO
> +               select ARCH_REQUIRE_GPIOLIB
> +               select ARM_AMBA
> +               select PINCTRL
> +               help
> +                 This enables support for systems based on Broadcom IPROC architected SoCs.
> +                 The IPROC complex contains one or more ARM CPUs along with common
> +                 core periperals. Application specific SoCs are created by adding a
> +                 uArchitecture containing peripherals outside of the IPROC complex.
> +                 Currently supported SoCs are Cygnus.
> +
> +       config ARCH_BCM_CYGNUS
> +               bool "Broadcom Cygnus Support" if ARCH_MULTI_V7

You still have a three-level menu structure. Please fix.

> +static const char const *bcm_cygnus_dt_compat[] = {
> +       "brcm,cygnus",
> +       NULL,
> +};
> +
> +DT_MACHINE_START(BCM_CYGNUS_DT, "Broadcom Cygnus SoC")
> +       .l2c_aux_val    = 0,
> +       .l2c_aux_mask   = ~0,
> +       .dt_compat = bcm_cygnus_dt_compat,
> +MACHINE_END
> 
This looks good.

	Arnd
