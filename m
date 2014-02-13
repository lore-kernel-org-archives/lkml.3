Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaBMKyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:54:38 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:53033 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbaBMKyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:54:37 -0500
Message-ID: <1392288875.30853.54.camel@x220>
Subject: Re: [PATCH] Blackfin: bf537: rename ad2s120x ->ad2s1200
From: Paul Bolle <pebolle@tiscali.nl>
To: Steven Miao <realmz6@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Michael Hennerich <michael.hennerich@analog.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Feb 2014 11:54:35 +0100
In-Reply-To: <1365073330.1830.34.camel@x61.thuisdomein>
References: <1365073330.1830.34.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 10:54:35.0806 (UTC) FILETIME=[FBEA63E0:01CF28A9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Replaced previous maintainer and list with current maintainer and
list.]

On Thu, 2013-04-04 at 13:02 +0200, Paul Bolle wrote:
> In v3.2 the Analog Devices ad2s1200/ad2s1205 driver was renamed from
> ad2s120x to ad2s1200. But it apparently forgot to rename the references
> to this driver in the BF537-STAMP code. Rename these now, and use the
> IS_ENABLED() macro, while we're at it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

This issue is also still present in v3.14-rc2. Can someone please have a
look at this patch?

> 0) Also untested. The ".modalias" change is educated guesswork.
> 
> 1) See commit 10e4a52b6e471cea2e87e71f8708a8c8c6b75266
> ("staging:iio:resolver rename ad2s120x ->ad2s1200") for the commit that
> started all this.
> 
>  arch/blackfin/mach-bf537/boards/stamp.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> index 9735345..e6fdc2a 100644
> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> @@ -654,13 +654,13 @@ static struct bfin5xx_spi_chip ad2s90_spi_chip_info = {
>  };
>  #endif
>  
> -#if defined(CONFIG_AD2S120X) || defined(CONFIG_AD2S120X_MODULE)
> -static unsigned short ad2s120x_platform_data[] = {
> +#if IS_ENABLED(CONFIG_AD2S1200)
> +static unsigned short ad2s1200_platform_data[] = {
>  	/* used as SAMPLE and RDVEL */
>  	GPIO_PF5, GPIO_PF6, 0
>  };
>  
> -static struct bfin5xx_spi_chip ad2s120x_spi_chip_info = {
> +static struct bfin5xx_spi_chip ad2s1200_spi_chip_info = {
>  	.enable_dma = 0,
>  };
>  #endif
> @@ -1018,13 +1018,13 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
>  	},
>  #endif
>  
> -#if defined(CONFIG_AD2S120X) || defined(CONFIG_AD2S120X_MODULE)
> +#if IS_ENABLED(CONFIG_AD2S1200)
>  	{
> -		.modalias = "ad2s120x",
> +		.modalias = "ad2s1200",
>  		.bus_num = 0,
>  		.chip_select = 4,            /* CS, change it for your board */
> -		.platform_data = ad2s120x_platform_data,
> -		.controller_data = &ad2s120x_spi_chip_info,
> +		.platform_data = ad2s1200_platform_data,
> +		.controller_data = &ad2s1200_spi_chip_info,
>  	},
>  #endif
>  

This should be the last Kconfig related issue that I reported last year,
but was never fixed. I'm haven't checked what else lurks in blackfin.
Let's first see how these issues get resolved.

Thanks,


Paul Bolle

