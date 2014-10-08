Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbaJHN3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:29:38 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:53533 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbaJHN3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:29:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Branden <sbranden@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org, Christian Daudt <bcm@fixthebug.org>,
        Matt Porter <mporter@linaro.org>,
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
        Antti Palosaari <crope@iki.fi>, devicetree@vger.kernel.org,
        Ray Jui <rjui@broadcom.com>, linux-kernel@vger.kernel.org,
        Jonathan Richardson <jonathar@broadcom.com>,
        JD Zheng <jdzheng@broadcom.com>
Subject: Re: [PATCH 1/6] ARM: cygnus: Initial support for Broadcom Cygnus SoC
Date: Wed, 08 Oct 2014 15:28:19 +0200
Message-ID: <10762659.VISiZ3vSSN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54352DAC.3080001@broadcom.com>
References: <1412746025-11998-2-git-send-email-sbranden@broadcom.com> <4255803.4lcNtQPo2T@wuerfel> <54352DAC.3080001@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zhyqUOmPZk6V4vYdL7irYXwryE0E7a3xtlKdKYC9WL7
 JAuFW6Y/1LsYYbe0R7frOZnR9N+Px4/5q/I2wdjQ9ck87GqM/t
 QpVFWN6HO6kr46YBFm5wfp7v5Kkqa+trsHyeYHXnZo/ubdBcGp
 mo+nM/Wn7316Hk1ETq6IWz+k4dsMYc0HHZbLsTnTu1nYO+qvxX
 Jxa8qHlAD2SI/W14dBLgurtXNtX5q7RJPkduWQ1o6kzUXU+Jiw
 GuwEhMik72ZoFT6YWajKJehsIXldo4XvCb4fPG++A6GDtGC6xv
 Tqmu7/j1V0uEuYHLxSfkIo8BAgmeSbTV+rxPiA5Dbc1eMDXKcX
 9GZM1GoPaOnbKvql3kag=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2014 05:27:24 Scott Branden wrote:
> >> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
> >> index fc93800..2dd3f78 100644
> >> --- a/arch/arm/mach-bcm/Kconfig
> >> +++ b/arch/arm/mach-bcm/Kconfig
> >> @@ -5,6 +5,37 @@ menuconfig ARCH_BCM
> >>
> >>   if ARCH_BCM
> >>
> >> +config ARCH_BCM_IPROC
> >> +	bool "Broadcom ARMv7 iProc boards" if ARCH_MULTI_V7
> >> +	select ARM_GIC
> >> +	select CACHE_L2X0
> >> +	select HAVE_ARM_TWD if LOCAL_TIMERS
> >> +	select HAVE_CLK
> >> +	select CLKSRC_OF
> >> +	select CLKSRC_MMIO
> >> +	select GENERIC_CLOCKEVENTS
> >> +	select ARM_GLOBAL_TIMER
> >> +	select ARCH_REQUIRE_GPIOLIB
> >> +	select ARM_AMBA
> >> +	select PINCTRL
> >> +	select DEBUG_UART_8250
> >
> > A lot of these are implied by ARCH_MULTI_V7, just drop them here.
> >
> > Some others like DEBUG_UART_8250 should remain user-selectable, if
> > the platform works without them.
> >
> Will review.  It looks like DEBUG_UART_8250 actually has to move to 
> Kconfig.debug as that is where everyone else selects it.

Actually I think you also need to use DEBUG_LL_UART_8250 rather than
DEBUG_UART_8250.

> >> +	help
> >> +	  This enables support for systems based on Broadcom IPROC architected SoCs.
> >> +	  The IPROC complex contains one or more ARM CPUs along with common
> >> +	  core periperals. Application specific SoCs are created by adding a
> >> +	  uArchitecture containing peripherals outside of the IPROC complex.
> >> +	  Currently supported SoCs are Cygnus.
> >> +
> >> +menu "iProc SoC based Machine types"
> >> +	depends on ARCH_BCM_IPROC
> >> +
> >> +	config ARCH_BCM_CYGNUS
> >> +		bool "Support Broadcom Cygnus board"
> >> +		select USB_ARCH_HAS_EHCI if USB_SUPPORT
> >> +		help
> >> +		  Support for Broadcom Cygnus SoC.
> >> +endmenu
> >
> > I don't think you need per-board config options. The main option
> > above should be enough.
> This is not a per-board config option.  This is actually a per-SoC 
> uArchtecture selection.  More major uArchectures will be added to the 
> IPROC.  Will Change comment to "Support Broadcom Cygnus SoC"

Ok, sounds fine, but remove ARCH_BCM_IPROC then. There should be
no need for a three-level deep hierarchy (BCM -> IPROC -> CYGNUS)


> >> +/* CRU_RESET register */
> >> +static void * __iomem crmu_mail_box1_reg;
> >> +
> >> +#ifdef CONFIG_NEON
> >> +
> >> +#define CRU_BASE                  0x1800e000
> >> +#define CRU_SIZE                  0x34
> >> +#define CRU_CONTROL_OFFSET        0x0
> >> +#define CRU_PWRDWN_EN_OFFSET      0x4
> >> +#define CRU_PWRDWN_STATUS_OFFSET  0x8
> >> +#define CRU_NEON0_HW_RESET  6
> >> +#define CRU_CLAMP_ON_NEON0  20
> >> +#define CRU_PWRONIN_NEON0   21
> >> +#define CRU_PWRONOUT_NEON0  21
> >> +#define CRU_PWROKIN_NEON0   22
> >> +#define CRU_PWROKOUT_NEON0  22
> >> +#define CRU_STATUS_DELAY_NS 500
> >> +#define CRU_MAX_RETRY_COUNT 10
> >> +#define CRU_RETRY_INTVL_US  1
> >> +
> >> +/* Power up the NEON/VFPv3 block. */
> >> +static void bcm_cygnus_powerup_neon(void)
> >> +{
> >> +	void * __iomem cru_base = ioremap(CRU_BASE, CRU_SIZE);
> >> +	u32 reg, i;
> >
> > Same thing here: this should really use the device node for CRU.
> >
> > Can you describe what the CRU is? Is this specific to NEON or is
> > it some general-purpose power management unit?
> >
> It's a central resource unit with a lot of random registers to perform 
> various operations.  To reduce confusion I'll probably move this out of 
> the kernel init and into the bootloader.  This will simplify the kernel 
> init.

That would help too, yes.

> >> +
> >> +static const char const *bcm_cygnus_dt_compat[] = {
> >> +	"brcm,cygnus",
> >> +	NULL,
> >> +};
> >> +
> >> +DT_MACHINE_START(BCM_CYGNUS_DT, "Broadcom Cygnus SoC")
> >> +	.init_machine = bcm_cygnus_init,
> >> +	.map_io = debug_ll_io_init,
> >> +	.dt_compat = bcm_cygnus_dt_compat,
> >> +	.restart   = bcm_cygnus_restart
> >> +MACHINE_END
> >
> > The map_io pointer is unnecessary, and the restart pointer should get
> > set by the reset driver. I hope we can find a way to avoid the
> > bcm_cygnus_init callback as well.
> bcm_cygnus_init callback can be removed by moving initialization to 
> bootloader.

Ok, perfect!

	Arnd
