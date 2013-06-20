Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3FTI4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:56:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53415 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028Ab3FTI4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:56:18 -0400
Message-ID: <51C2C390.7090301@ti.com>
Date: Thu, 20 Jun 2013 14:25:44 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/7] ARM: davinci: dmxxx: gpio device creation
References: <1371202532-14628-1-git-send-email-avinashphilip@ti.com> <1371202532-14628-7-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1371202532-14628-7-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2013 3:05 PM, Philip Avinash wrote:
> Create davinci gpio device and remove gpio references in
> davinci_soc_info structure for dmxxx platforms. Also add Memory and IRQ
> resources for GPIO platform device.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> ---
> Changes since v1:
> 	- Add commit message
> 
>  arch/arm/mach-davinci/board-dm355-evm.c     |   27 ++++++++++++++++++++++++++
>  arch/arm/mach-davinci/board-dm355-leopard.c |    1 +
>  arch/arm/mach-davinci/board-dm365-evm.c     |   28 +++++++++++++++++++++++++++
>  arch/arm/mach-davinci/board-dm644x-evm.c    |   26 +++++++++++++++++++++++++
>  arch/arm/mach-davinci/board-dm646x-evm.c    |   27 ++++++++++++++++++++++++++
>  arch/arm/mach-davinci/board-neuros-osd2.c   |    1 +
>  arch/arm/mach-davinci/dm355.c               |    4 ----
>  arch/arm/mach-davinci/dm365.c               |    5 -----
>  arch/arm/mach-davinci/dm644x.c              |    4 ----
>  arch/arm/mach-davinci/dm646x.c              |    4 ----
>  arch/arm/mach-davinci/include/mach/common.h |    2 ++
>  11 files changed, 112 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
> index c2a0a67..05e6e86 100644
> --- a/arch/arm/mach-davinci/board-dm355-evm.c
> +++ b/arch/arm/mach-davinci/board-dm355-evm.c
> @@ -28,9 +28,11 @@
>  
>  #include <linux/platform_data/i2c-davinci.h>
>  #include <mach/serial.h>
> +#include <mach/common.h>
>  #include <linux/platform_data/mtd-davinci.h>
>  #include <linux/platform_data/mmc-davinci.h>
>  #include <linux/platform_data/usb-davinci.h>
> +#include <linux/platform_data/gpio-davinci.h>
>  
>  #include "davinci.h"
>  
> @@ -376,9 +378,34 @@ static struct spi_board_info dm355_evm_spi_info[] __initconst = {
>  	},
>  };
>  
> +static struct resource dm355_gpio_resources[] = {
> +	{ /* registers */
> +		.start	= DAVINCI_GPIO_BASE,
> +		.end	= DAVINCI_GPIO_BASE + SZ_4K - 1,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{ /* interrupt */
> +		.start	= IRQ_DM355_GPIOBNK0,
> +		.end	= IRQ_DM355_GPIOBNK6,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};

Don't add these resource in board files. Granted we are not going to add
more board files, but that does not mean we add soc specific data into
board files. You need to move this into the respective SoC files.

Thanks,
Sekhar
