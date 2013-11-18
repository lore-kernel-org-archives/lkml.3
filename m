Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab3KRPF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:05:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52338 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab3KRPFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:05:21 -0500
Message-ID: <528A2C49.4040709@ti.com>
Date: Mon, 18 Nov 2013 17:03:37 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, <wim@iguana.be>,
        <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <galak@kernel.crashing.org>, <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: Fwd: [PATCH 6/8] watchdog: davinci: reuse driver for keystone
 arch
References: <1383680783-12114-7-git-send-email-ivan.khoronzhuk@ti.com> <527A28DE.4030906@ti.com> <5288298B.1010602@roeck-us.net>
In-Reply-To: <5288298B.1010602@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2013 04:27 AM, Guenter Roeck wrote:
> On 11/06/2013 03:32 AM, ivan.khoronzhuk wrote:
>> The keystone arch use the same IP watchdog, so add "ti,keystone-wdt"
>> compatible and correct identity.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> ---
>>   .../devicetree/bindings/watchdog/davinci-wdt.txt   |   11 +++++++++--
>>   drivers/watchdog/Kconfig                           |    4 ++--
>>   drivers/watchdog/davinci_wdt.c                     |    3 ++-
>>   3 files changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git
>> a/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
>> b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
>> index 1668b6e..fddced9 100644
>> --- a/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
>> +++ b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
>> @@ -1,13 +1,20 @@
>> -DaVinci Watchdog Timer (WDT) Controller
>> +Texas Instruments DaVinci/Keystone Watchdog Timer (WDT) Controller
>>
>>   Required properties:
>> -- compatible : Should be "ti,davinci-wdt"
>> +
>> +- compatible:        "ti,davinci-wdt"
>> +            "ti,keystone-wdt"
>> +
>>   - reg : Should contain WDT registers location and length
>>
> Please use consistent formatting. If you change it, at least change it
> to be consistent.
>

Thanks, I will

>>   Optional properties:
>>
>>   - timeout-sec:        Contains the watchdog timeout in seconds
>>
>> +Documentation:
>> +Davinci DM646x - http://www.ti.com/lit/ug/spruer5b/spruer5b.pdf
>> +Keystone - http://www.ti.com/lit/ug/sprugv5a/sprugv5a.pdf
>> +
>>   Examples:
>>
>>   wdt: wdt@2320000 {
>> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>> index 2c954b5..a4fe130 100644
>> --- a/drivers/watchdog/Kconfig
>> +++ b/drivers/watchdog/Kconfig
>> @@ -270,11 +270,11 @@ config IOP_WATCHDOG
>>
>>   config DAVINCI_WATCHDOG
>>       tristate "DaVinci watchdog"
>> -    depends on ARCH_DAVINCI
>> +    depends on ARCH_DAVINCI || ARCH_KEYSTONE
>>       select WATCHDOG_CORE
>>       help
>>         Say Y here if to include support for the watchdog timer
>> -      in the DaVinci DM644x/DM646x processors.
>> +      in the DaVinci DM644x/DM646x or Keystone processors.
>>         To compile this driver as a module, choose M here: the
>>         module will be called davinci_wdt.
>>
>> diff --git a/drivers/watchdog/davinci_wdt.c
>> b/drivers/watchdog/davinci_wdt.c
>> index a371b2d..e51fd2e 100644
>> --- a/drivers/watchdog/davinci_wdt.c
>> +++ b/drivers/watchdog/davinci_wdt.c
>> @@ -158,7 +158,7 @@ static unsigned int davinci_wdt_status(struct
>> watchdog_device *wdd)
>>
>>   static const struct watchdog_info davinci_wdt_info = {
>>       .options = WDIOF_KEEPALIVEPING,
>> -    .identity = "DaVinci Watchdog",
>> +    .identity = "DaVinci/Keystone Watchdog",
>>   };
>>
>>   static const struct watchdog_ops davinci_wdt_ops = {
>> @@ -229,6 +229,7 @@ static int davinci_wdt_remove(struct
>> platform_device *pdev)
>>
>>   static const struct of_device_id davinci_wdt_of_match[] = {
>>       { .compatible = "ti,davinci-wdt", },
>> +    { .compatible = "ti,keystone-wdt", },
>>       {},
>>   };
>>   MODULE_DEVICE_TABLE(of, davinci_wdt_of_match);
>>
>


-- 
Regards,
Ivan Khoronzhuk
