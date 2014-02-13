Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaBMKXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:23:00 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:62626 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791AbaBMKW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:22:57 -0500
Message-ID: <1392286975.30853.44.camel@x220>
Subject: Re: [PATCH] Blackfin: bf537: use "CONFIG_SND_SOC_AD193X"
From: Paul Bolle <pebolle@tiscali.nl>
To: Steven Miao <realmz6@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Feb 2014 11:22:55 +0100
In-Reply-To: <1365153646.1830.58.camel@x61.thuisdomein>
References: <1365153646.1830.58.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 10:22:56.0569 (UTC) FILETIME=[8FE1D290:01CF28A5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Replaced previous maintainer and list with current maintainer and
list.]

On Fri, 2013-04-05 at 11:20 +0200, Paul Bolle wrote:
> Commit 57084ede395bb3c9da7905701d34a3b7d33c9356 ("blackfin: bf537:
> stamp: update board file for 193x") changed two references to
> CONFIG_SND_BF5XX_SOC_AD193X (and CONFIG_SND_BF5XX_SOC_AD193X_MODULE).
> One was changed to CONFIG_SND_SOC_AD193X_SPI, the other to
> CONFIG_SND_SOC_AD193X_I2C. The commit explanation doesn't elaborate on
> the reason for these changes nor on the reason to drop module support.
> 
> Anyhow, neither of these two new Kconfig macros is valid. It was
> probably intended to use CONFIG_SND_SOC_AD193X here. So let's use that.
> And let's also reenable module support by using the IS_ENABLED() macro.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

And this issue is also still present in v3.14-rc2. Jean and Guenter
replied, but preferred not to get involved with this messy "stamp" file.
Can someone please actually look at this patch? 

> 0) Untested. Please note that I fail to see the point of commit
> 57084ede395bb3c9da7905701d34a3b7d33c9356, which was added in v3.4, even
> if I assume it wanted to use CONFIG_SND_SOC_AD193X. Perhaps I'm missing
> something obvious. Anyhow, review is appreciated.
> 
> 1) Added Jean and Guenter because they seem to take in interest in
> Blackfin's stamp files.
> 
>  arch/blackfin/mach-bf537/boards/stamp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> index e6fdc2a..94a193e 100644
> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> @@ -975,7 +975,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
>  	},
>  #endif
>  
> -#ifdef CONFIG_SND_SOC_AD193X_SPI
> +#if IS_ENABLED(CONFIG_SND_SOC_AD193X)
>  	{
>  		.modalias = "ad193x",
>  		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
> @@ -2176,7 +2176,7 @@ static unsigned long adt7316_i2c_data[2] = {
>  #endif
>  
>  static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
> -#ifdef CONFIG_SND_SOC_AD193X_I2C
> +#if IS_ENABLED(CONFIG_SND_SOC_AD193X)
>  	{
>  		I2C_BOARD_INFO("ad1937", 0x04),
>  	},


Paul Bolle

