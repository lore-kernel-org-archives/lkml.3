Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbbAMJCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:02:36 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:50821 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbbAMJCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:02:30 -0500
Message-ID: <1421139747.22660.76.camel@x220>
Subject: Re: [PATCH v5 3/7] gpio/xilinx: Add support for X86 Arch
From: Paul Bolle <pebolle@tiscali.nl>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 13 Jan 2015 10:02:27 +0100
In-Reply-To: <1418831474-24428-4-git-send-email-ricardo.ribalda@gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
	 <1418831474-24428-4-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2015 09:02:28.0020 (UTC) FILETIME=[A7D03740:01D02F0F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 16:51 +0100, Ricardo Ribalda Delgado wrote:
> Core can be accessed via PCIe on X86 platform.
> This patch also allows the driver to be used as module.
> 
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/gpio/Kconfig       | 4 ++--
>  drivers/gpio/gpio-xilinx.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

This patch became c586b3075d5b ("gpio/xilinx: Add support for X86 Arch")
in today's linux-next (next-20150113). I noticed because a script I use
to check linux-next spotted a problem in it.

> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 414d055..b17d226 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -366,8 +366,8 @@ config GPIO_XGENE
>  	  here to enable the GFC GPIO functionality.
>  
>  config GPIO_XILINX
> -	bool "Xilinx GPIO support"
> -	depends on PPC_OF || MICROBLAZE || ARCH_ZYNQ
> +	tristate "Xilinx GPIO support"
> +	depends on OF_GPIO && (PPC_OF || MICROBLAZE || ARCH_ZYNQ || ARCH_X86)

There's no Kconfig symbol "ARCH_X86". Did you actually mean "X86"?

>  	help
>  	  Say yes here to support the Xilinx FPGA GPIO device
>  
> diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
> index c7ed92b..554060a 100644
> --- a/drivers/gpio/gpio-xilinx.c
> +++ b/drivers/gpio/gpio-xilinx.c
> @@ -30,7 +30,7 @@
>  #define XGPIO_CHANNEL_OFFSET	0x8
>  
>  /* Read/Write access to the GPIO registers */
> -#ifdef CONFIG_ARCH_ZYNQ
> +#if defined(CONFIG_ARCH_ZYNQ) || defined(CONFIG_X86)

Yes, you probably did want just "X86".

>  # define xgpio_readreg(offset)		readl(offset)
>  # define xgpio_writereg(offset, val)	writel(val, offset)
>  #else


Paul Bolle

