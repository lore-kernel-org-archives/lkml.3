Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaJHM1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:27:42 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:30807 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaJHM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:27:40 -0400
X-IronPort-AV: E=Sophos;i="5.04,677,1406617200"; 
   d="scan'208";a="47928690"
Message-ID: <54352DAC.3080001@broadcom.com>
Date: Wed, 8 Oct 2014 05:27:24 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, <devicetree@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>, <linux-kernel@vger.kernel.org>,
        Jonathan Richardson <jonathar@broadcom.com>,
        JD Zheng <jdzheng@broadcom.com>
Subject: Re: [PATCH 1/6] ARM: cygnus: Initial support for Broadcom Cygnus
 SoC
References: <1412746025-11998-2-git-send-email-sbranden@broadcom.com> <4255803.4lcNtQPo2T@wuerfel>
In-Reply-To: <4255803.4lcNtQPo2T@wuerfel>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review - comments inline.

On 14-10-08 12:54 AM, Arnd Bergmann wrote:
> On Tuesday 07 October 2014 22:27:00 Scott Branden wrote:
>> From: Jonathan Richardson <jonathar@broadcom.com>
>>
>> Adds initial support for the Cygnus SoC based on Broadcom’s iProc series.
>>
>> Reviewed-by: Ray Jui <rjui@broadcom.com>
>> Reviewed-by: Desmond Liu <desmondl@broadcom.com>
>> Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
>> Tested-by: Jonathan Richardson <jonathar@broadcom.com>
>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>   arch/arm/mach-bcm/Kconfig      |   31 ++++++++
>>   arch/arm/mach-bcm/Makefile     |    3 +
>>   arch/arm/mach-bcm/bcm_cygnus.c |  166 ++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 200 insertions(+)
>>   create mode 100644 arch/arm/mach-bcm/bcm_cygnus.c
>>
>> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
>> index fc93800..2dd3f78 100644
>> --- a/arch/arm/mach-bcm/Kconfig
>> +++ b/arch/arm/mach-bcm/Kconfig
>> @@ -5,6 +5,37 @@ menuconfig ARCH_BCM
>>
>>   if ARCH_BCM
>>
>> +config ARCH_BCM_IPROC
>> +	bool "Broadcom ARMv7 iProc boards" if ARCH_MULTI_V7
>> +	select ARM_GIC
>> +	select CACHE_L2X0
>> +	select HAVE_ARM_TWD if LOCAL_TIMERS
>> +	select HAVE_CLK
>> +	select CLKSRC_OF
>> +	select CLKSRC_MMIO
>> +	select GENERIC_CLOCKEVENTS
>> +	select ARM_GLOBAL_TIMER
>> +	select ARCH_REQUIRE_GPIOLIB
>> +	select ARM_AMBA
>> +	select PINCTRL
>> +	select DEBUG_UART_8250
>
> A lot of these are implied by ARCH_MULTI_V7, just drop them here.
>
> Some others like DEBUG_UART_8250 should remain user-selectable, if
> the platform works without them.
>
Will review.  It looks like DEBUG_UART_8250 actually has to move to 
Kconfig.debug as that is where everyone else selects it.
>> +	help
>> +	  This enables support for systems based on Broadcom IPROC architected SoCs.
>> +	  The IPROC complex contains one or more ARM CPUs along with common
>> +	  core periperals. Application specific SoCs are created by adding a
>> +	  uArchitecture containing peripherals outside of the IPROC complex.
>> +	  Currently supported SoCs are Cygnus.
>> +
>> +menu "iProc SoC based Machine types"
>> +	depends on ARCH_BCM_IPROC
>> +
>> +	config ARCH_BCM_CYGNUS
>> +		bool "Support Broadcom Cygnus board"
>> +		select USB_ARCH_HAS_EHCI if USB_SUPPORT
>> +		help
>> +		  Support for Broadcom Cygnus SoC.
>> +endmenu
>
> I don't think you need per-board config options. The main option
> above should be enough.
This is not a per-board config option.  This is actually a per-SoC 
uArchtecture selection.  More major uArchectures will be added to the 
IPROC.  Will Change comment to "Support Broadcom Cygnus SoC"
>
>> +
>> +#define CRMU_MAIL_BOX1      0x03024028
>> +#define CRMU_SOFT_RESET_CMD 0xFFFFFFFF
>
> Never hardcode physical register locations in source. This should come
> from DT, and get moved into a regular 'reset' device driver.
>
> You probably want to use drivers/power/reset/syscon-reboot.c
>
OK, thanks for advice on where to put reset device driver.  Will 
investigate.
>> +/* CRU_RESET register */
>> +static void * __iomem crmu_mail_box1_reg;
>> +
>> +#ifdef CONFIG_NEON
>> +
>> +#define CRU_BASE                  0x1800e000
>> +#define CRU_SIZE                  0x34
>> +#define CRU_CONTROL_OFFSET        0x0
>> +#define CRU_PWRDWN_EN_OFFSET      0x4
>> +#define CRU_PWRDWN_STATUS_OFFSET  0x8
>> +#define CRU_NEON0_HW_RESET  6
>> +#define CRU_CLAMP_ON_NEON0  20
>> +#define CRU_PWRONIN_NEON0   21
>> +#define CRU_PWRONOUT_NEON0  21
>> +#define CRU_PWROKIN_NEON0   22
>> +#define CRU_PWROKOUT_NEON0  22
>> +#define CRU_STATUS_DELAY_NS 500
>> +#define CRU_MAX_RETRY_COUNT 10
>> +#define CRU_RETRY_INTVL_US  1
>> +
>> +/* Power up the NEON/VFPv3 block. */
>> +static void bcm_cygnus_powerup_neon(void)
>> +{
>> +	void * __iomem cru_base = ioremap(CRU_BASE, CRU_SIZE);
>> +	u32 reg, i;
>
> Same thing here: this should really use the device node for CRU.
>
> Can you describe what the CRU is? Is this specific to NEON or is
> it some general-purpose power management unit?
>
It's a central resource unit with a lot of random registers to perform 
various operations.  To reduce confusion I'll probably move this out of 
the kernel init and into the bootloader.  This will simplify the kernel 
init.
>> +static void __init bcm_cygnus_init(void)
>> +{
>> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>> +
>> +	l2x0_of_init(0, ~0UL);
>
> The l2x0_of_init can be removed now, just move the arguments into the
> respective fields of the machine descriptor.
>
Yes, thanks for pointing this out.
>> +	crmu_mail_box1_reg = ioremap(CRMU_MAIL_BOX1, SZ_4);
>> +	WARN_ON(!crmu_mail_box1_reg);
>> +
>> +#ifdef CONFIG_NEON
>> +	bcm_cygnus_powerup_neon();
>> +#endif
>> +}
>
> In general, try to avoid #ifdef, use
>
> 	if (IS_ENABLED(CONFIG_NEON))
> 		bcm_cygnus_powerup_neon();
>
> instead.
>
>> +
>> +static const char const *bcm_cygnus_dt_compat[] = {
>> +	"brcm,cygnus",
>> +	NULL,
>> +};
>> +
>> +DT_MACHINE_START(BCM_CYGNUS_DT, "Broadcom Cygnus SoC")
>> +	.init_machine = bcm_cygnus_init,
>> +	.map_io = debug_ll_io_init,
>> +	.dt_compat = bcm_cygnus_dt_compat,
>> +	.restart   = bcm_cygnus_restart
>> +MACHINE_END
>
> The map_io pointer is unnecessary, and the restart pointer should get
> set by the reset driver. I hope we can find a way to avoid the
> bcm_cygnus_init callback as well.
bcm_cygnus_init callback can be removed by moving initialization to 
bootloader.
>
> 	Arnd
>

