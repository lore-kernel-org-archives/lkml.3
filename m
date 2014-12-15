Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105AbaLOOSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:18:40 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:34633 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaLOOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:18:39 -0500
Message-ID: <548EED97.60604@roeck-us.net>
Date: Mon, 15 Dec 2014 06:17:59 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
CC: kernel@stlinux.com, a.zummo@towertech.it, rtc-linux@googlegroups.com,
        wim@iguana.be, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 7/8] rtc: st: add new driver for ST's LPC RTC
References: <1418642738-17407-1-git-send-email-lee.jones@linaro.org> <1418642738-17407-8-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1418642738-17407-8-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.548EEDBE.0166,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 15
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

On 12/15/2014 03:25 AM, Lee Jones wrote:
> ST's Low Power Controller (LPC) controls two devices; watchdog and RTC.
> Only one of the devices can be used at any one time.  This is enforced
> by the correlating MFD driver.  This portion of the driver-set controls
> the Real Time Clock.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/rtc/Kconfig      |  13 ++
>   drivers/rtc/Makefile     |   1 +
>   drivers/rtc/rtc-st-lpc.c | 330 +++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 344 insertions(+)
>   create mode 100644 drivers/rtc/rtc-st-lpc.c
>
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index a168e96..aa4bd90 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -1355,6 +1355,18 @@ config RTC_DRV_SIRFSOC
>   	  Say "yes" here to support the real time clock on SiRF SOC chips.
>   	  This driver can also be built as a module called rtc-sirfsoc.
>
> +config RTC_DRV_ST_LPC
> +	tristate "STMicroelectronics LPC RTC"
> +	depends on ARCH_STI
> +	depends on OF
> +	select MFD_ST_LPC
> +	help
> +	  Say Y here to include STMicroelectronics Low Power Controller
> +	  (LPC) based RTC support.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called rtc-st-lpc.
> +
>   config RTC_DRV_MOXART
>   	tristate "MOXA ART RTC"
>   	depends on ARCH_MOXART || COMPILE_TEST
> @@ -1390,4 +1402,5 @@ config RTC_DRV_HID_SENSOR_TIME
>   	  rtc-hid-sensor-time.
>
>
> +

Hi Lee,

Yet another empty line ?

Guenter

