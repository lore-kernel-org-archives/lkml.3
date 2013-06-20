Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155Ab3FTJIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:08:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57841 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965105Ab3FTJIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:08:31 -0400
Message-ID: <51C2C66D.4030106@ti.com>
Date: Thu, 20 Jun 2013 14:37:57 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Philip Avinash <avinashphilip@ti.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux@arm.linux.org.uk>, <khilman@deeprootsystems.com>,
        <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 5/7] ARM: davinci: da8xx: gpio device creation
References: <1371202532-14628-1-git-send-email-avinashphilip@ti.com> <1371202532-14628-6-git-send-email-avinashphilip@ti.com> <51C2BFEF.1090205@ti.com>
In-Reply-To: <51C2BFEF.1090205@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/2013 2:10 PM, Sekhar Nori wrote:
> On 6/14/2013 3:05 PM, Philip Avinash wrote:
>> Create davinci gpio device and remove references in davinci_soc_info
>> structure. Also rearrange header file inclusion in group basis.
>>
>> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
>> ---
>>  arch/arm/mach-davinci/board-da830-evm.c     |   19 +++++++++++++++----
>>  arch/arm/mach-davinci/board-da850-evm.c     |   11 +++++++++++
>>  arch/arm/mach-davinci/board-omapl138-hawk.c |    2 ++
>>  arch/arm/mach-davinci/da830.c               |    4 ----
>>  arch/arm/mach-davinci/da850.c               |    4 ----
>>  5 files changed, 28 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
>> index 1332de8..4e8bcc1 100644
>> --- a/arch/arm/mach-davinci/board-da830-evm.c
>> +++ b/arch/arm/mach-davinci/board-da830-evm.c
>> @@ -22,17 +22,19 @@
>>  #include <linux/mtd/partitions.h>
>>  #include <linux/spi/spi.h>
>>  #include <linux/spi/flash.h>
>> +#include <linux/platform_data/mtd-davinci.h>
>> +#include <linux/platform_data/gpio-davinci.h>
>> +#include <linux/platform_data/usb-davinci.h>
>> +#include <linux/platform_data/mtd-davinci-aemif.h>
>> +#include <linux/platform_data/spi-davinci.h>
> 
> While doing this, its better to keep the header files you are adding in
> sorted order.
> 
>>  
>>  #include <asm/mach-types.h>
>>  #include <asm/mach/arch.h>
>>  
>>  #include <mach/cp_intc.h>
>>  #include <mach/mux.h>
>> -#include <linux/platform_data/mtd-davinci.h>
>> +#include <mach/common.h>
> 
> You dont need to include this file here.
> 
>>  #include <mach/da8xx.h>
>> -#include <linux/platform_data/usb-davinci.h>
>> -#include <linux/platform_data/mtd-davinci-aemif.h>
>> -#include <linux/platform_data/spi-davinci.h>
>>  
>>  #define DA830_EVM_PHY_ID		""
>>  /*
>> @@ -590,11 +592,20 @@ static struct spi_board_info da830evm_spi_info[] = {
>>  	},
>>  };
>>  
>> +static struct davinci_gpio_platform_data da830_gpio_platform_data = {
>> +	.ngpio = 128,
>> +	.intc_irq_num = DA830_N_CP_INTC_IRQ,
>> +};
>> +
>>  static __init void da830_evm_init(void)
>>  {
>>  	struct davinci_soc_info *soc_info = &davinci_soc_info;
>>  	int ret;
>>  
>> +	ret = da8xx_register_gpio(&da830_gpio_platform_data);
>> +	if (ret)
>> +		pr_warn("da830_evm_init: GPIO init failed: %d\n", ret);
>> +
>>  	ret = da830_register_edma(da830_edma_rsv);
>>  	if (ret)
>>  		pr_warning("da830_evm_init: edma registration failed: %d\n",
>> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
>> index 8a24b6c..d5dd010 100644
>> --- a/arch/arm/mach-davinci/board-da850-evm.c
>> +++ b/arch/arm/mach-davinci/board-da850-evm.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/mtd/partitions.h>
>>  #include <linux/mtd/physmap.h>
>>  #include <linux/platform_device.h>
>> +#include <linux/platform_data/gpio-davinci.h>
>>  #include <linux/platform_data/mtd-davinci.h>
>>  #include <linux/platform_data/mtd-davinci-aemif.h>
>>  #include <linux/platform_data/spi-davinci.h>
>> @@ -42,6 +43,7 @@
>>  #include <mach/da8xx.h>
>>  #include <mach/mux.h>
>>  #include <mach/sram.h>
>> +#include <mach/common.h>
> 
> No need of this file, as before.
> 
>>  
>>  #include <asm/mach-types.h>
>>  #include <asm/mach/arch.h>
>> @@ -1138,6 +1140,11 @@ static struct edma_rsv_info *da850_edma_rsv[2] = {
>>  	&da850_edma_cc1_rsv,
>>  };
>>  
>> +static struct davinci_gpio_platform_data da850_gpio_platform_data = {
>> +	.ngpio = 144,
>> +	.intc_irq_num = DA850_N_CP_INTC_IRQ,
>> +};

I did not notice this before, but this is a wrong place for this. This
should be in SoC file since it does not change with each board. And this
explains why you left hawk board broken - you would end up replicating
this there.

You need to fix patches 3-6 and repost again. I have some fixes what I
made while reviewing and committed to my v3.11/gpio branch. You can to
take that branch as starting point and complete the fixes.

Thanks,
Sekhar
