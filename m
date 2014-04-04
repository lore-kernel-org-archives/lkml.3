Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaDDBtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 21:49:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60216 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaDDBtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 21:49:43 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <533E0FB3.6070305@roeck-us.net>
Date: Thu, 03 Apr 2014 18:49:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
CC: "wim@iguana.be" <wim@iguana.be>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/2] watchdog: imx2_wdt: convert to use regmap API.
References: <1396487059-15298-1-git-send-email-Li.Xiubo@freescale.com> <1396487059-15298-3-git-send-email-Li.Xiubo@freescale.com> <20140403163604.GA11832@roeck-us.net> <6563b26412a7457ba38e2dcf0bdcb643@BY2PR03MB505.namprd03.prod.outlook.com>
In-Reply-To: <6563b26412a7457ba38e2dcf0bdcb643@BY2PR03MB505.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 06:13 PM, Li.Xiubo@freescale.com wrote:
>>> +	base = devm_ioremap_resource(&pdev->dev, res);
>>> +	if (IS_ERR(base))
>>> +		return PTR_ERR(base);
>>> +
>>> +	imx2_wdt.regmap = devm_regmap_init_mmio_clk(&pdev->dev, NULL, base,
>>> +						    &imx2_wdt_regmap_config);
>>
>> This patch causes the following buiild failure:
>>
>> Building arm:imx_v4_v5_defconfig ... failed
>> --------------
>> Error log:
>> drivers/built-in.o: In function `imx2_wdt_probe':
>> clk-composite.c:(.init.text+0x82c4): undefined reference to
>> `devm_regmap_init_mmio_clk'
>> make: *** [vmlinux] Error 1
>> --------------
>>
>> This is on top of
>>
>> b33ce44 Merge branch 'for-3.15/drivers' of git://git.kernel.dk/linux-block
>>
>> Does it have build dependencies on code which is (or was) not yet available
>> in mainline ?
>>
>
> This is caused by not compiling the regmap core.
>
> Could you add the following patch to have a try ?
> ==========================
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 79d2589..3e55fa9 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -369,6 +369,7 @@ config MAX63XX_WATCHDOG
>   config IMX2_WDT
>          tristate "IMX2+ Watchdog"
>          depends on ARCH_MXC
> +       select REGMAP_MMIO
>          help
>            This is the driver for the hardware watchdog
>            on the Freescale IMX2 and later processors.
> --------------------------
>
> If it's okey, I'll sent the v5 series to fix this.
>
Yes, that fixes the problem.

Guenter


