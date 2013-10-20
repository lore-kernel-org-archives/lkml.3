Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3JTWBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 18:01:09 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63145 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3JTWBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 18:01:08 -0400
Message-ID: <5264529C.1000601@samsung.com>
Date: Mon, 21 Oct 2013 07:01:00 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Kukjin Kim <kgene@kernel.org>
CC: "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        oselas@community.pengutronix.de, linux-kernel@vger.kernel.org,
        "'Ben Dooks'" <ben-linux@fluff.org>, augulis.darius@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: s3c64xx: mini6410: Correct card detect type for
 HSMMC1
References: <1380471121-9478-1-git-send-email-tomasz.figa@gmail.com> <1527511.ScaEHrLnaz@flatron> <1e2a01cecb91$f790c700$e6b25500$@org>
In-Reply-To: <1e2a01cecb91$f790c700$e6b25500$@org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/13 08:38, Kukjin Kim wrote:
> Tomasz Figa wrote:
>>
>> Hi Kukjin,
>>
> Hi,
>
>> On Sunday 29 of September 2013 18:12:01 Tomasz Figa wrote:
>>> According to board schematics, for HSMMC1 a GPIO line is used to detect
>>> card presence, while currently it is being configured for internal card
>>> detect line, which is multiplexed with card detect line of HSMMC0 and
>>> thus breaking it.
>>>
>>> This patch adds proper sdhci platform data setting card detect type to
>>> external GPIO and fixing operation of HSMMC0.
>>>
>>> Signed-off-by: Tomasz Figa<tomasz.figa@gmail.com>
>>> ---
>>>   arch/arm/mach-s3c64xx/mach-mini6410.c | 10 ++++++++++
>>>   1 file changed, 10 insertions(+)
>>
>> Would you mind taking this patch to your tree?
>>
> Applied, thanks.
> Kukjin
>
Uhm...just small concern...it's possible to support dt for mini6410 but 
basic. I need to hold this on...

>> Best regards,
>> Tomasz
>>
>>> diff --git a/arch/arm/mach-s3c64xx/mach-mini6410.c
>>> b/arch/arm/mach-s3c64xx/mach-mini6410.c index 58d46a3..97ae470 100644
>>> --- a/arch/arm/mach-s3c64xx/mach-mini6410.c
>>> +++ b/arch/arm/mach-s3c64xx/mach-mini6410.c
>>> @@ -36,7 +36,9 @@
>>>   #include<plat/devs.h>
>>>   #include<plat/fb.h>
>>>   #include<linux/platform_data/mtd-nand-s3c2410.h>
>>> +#include<linux/platform_data/mmc-sdhci-s3c.h>
>>>   #include<plat/regs-serial.h>
>>> +#include<plat/sdhci.h>
>>>   #include<linux/platform_data/touchscreen-s3c2410.h>
>>>
>>>   #include<video/platform_lcd.h>
>>> @@ -214,6 +216,13 @@ static struct platform_device mini6410_lcd_powerdev
>>> = { .dev.platform_data	=&mini6410_lcd_power_data,
>>>   };
>>>
>>> +static struct s3c_sdhci_platdata mini6410_hsmmc1_pdata = {
>>> +	.max_width		= 4,
>>> +	.cd_type		= S3C_SDHCI_CD_GPIO,
>>> +	.ext_cd_gpio		= S3C64XX_GPN(10),
>>> +	.ext_cd_gpio_invert	= true,
>>> +};
>>> +
>>>   static struct platform_device *mini6410_devices[] __initdata = {
>>>   	&mini6410_device_eth,
>>>   	&s3c_device_hsmmc0,
>>> @@ -321,6 +330,7 @@ static void __init mini6410_machine_init(void)
>>>
>>>   	s3c_nand_set_platdata(&mini6410_nand_info);
>>>   	s3c_fb_set_platdata(&mini6410_lcd_pdata[features.lcd_index]);
>>> +	s3c_sdhci1_set_platdata(&mini6410_hsmmc1_pdata);
>>>   	s3c24xx_ts_set_platdata(NULL);
>>>
>>>   	/* configure nCS1 width to 16 bits */
