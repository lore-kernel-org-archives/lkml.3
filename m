Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaJEASZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 20:18:25 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:42844 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaJEASV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 20:18:21 -0400
Message-ID: <54308E48.6020809@roeck-us.net>
Date: Sat, 04 Oct 2014 17:18:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/watchdog/Kconfig: Let XILINX_WATCHDOG and TEGRA_WATCHDOG
 depend on HAS_IOMEM
References: <542FC064.1030604@gmail.com>
In-Reply-To: <542FC064.1030604@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54308E4D.0019,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 16
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2014 02:39 AM, Chen Gang wrote:
> They need HAS_IOMEM, so let them depend on it, the related error (with
> allmodconfig under um):
>
>      MODPOST 1205 modules
>    ERROR: "syscall" [fs/hostfs/hostfs.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/watchdog/tegra_wdt.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/watchdog/of_xilinx_wdt.ko] undefined!
>
Headline is a bit excessive ("watchdog: ..." would have been sufficient,
the first error is irrelevant as you found out yourself, and you got an
extra empty line here. Otherwise looks good.

Can you resubmit with that fixed ?

On a side note, guess the conclusion was to not provide a dummy for
devm_ioremap_resource if HAS_IOMEM is not defined. Too bad.

Guenter

>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>   drivers/watchdog/Kconfig | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index a51ccf3..d0ddf90 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -132,6 +132,7 @@ config WM8350_WATCHDOG
>
>   config XILINX_WATCHDOG
>   	tristate "Xilinx Watchdog timer"
> +	depends on HAS_IOMEM
>   	select WATCHDOG_CORE
>   	help
>   	  Watchdog driver for the xps_timebase_wdt ip core.
> @@ -472,7 +473,7 @@ config SIRFSOC_WATCHDOG
>
>   config TEGRA_WATCHDOG
>   	tristate "Tegra watchdog"
> -	depends on ARCH_TEGRA || COMPILE_TEST
> +	depends on (ARCH_TEGRA || COMPILE_TEST) && HAS_IOMEM
>   	select WATCHDOG_CORE
>   	help
>   	  Say Y here to include support for the watchdog timer
>

