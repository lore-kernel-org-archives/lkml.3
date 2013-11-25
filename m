Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab3KYLKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:10:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42041 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab3KYLKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:10:15 -0500
Message-ID: <52932FD3.10508@ti.com>
Date: Mon, 25 Nov 2013 13:09:07 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, <wim@iguana.be>,
        <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <galak@kernel.crashing.org>,
        <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>
Subject: Re: Fwd: [PATCH 6/8] watchdog: davinci: reuse driver for keystone
 arch
References: <1383680783-12114-7-git-send-email-ivan.khoronzhuk@ti.com> <527A28DE.4030906@ti.com> <201311231902.02807.arnd@arndb.de>
In-Reply-To: <201311231902.02807.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2013 08:02 PM, Arnd Bergmann wrote:
> On Wednesday 06 November 2013, ivan.khoronzhuk wrote:
> 
>> @@ -1,13 +1,20 @@
>> -DaVinci Watchdog Timer (WDT) Controller
>> +Texas Instruments DaVinci/Keystone Watchdog Timer (WDT) Controller
>>   
>>   Required properties:
>> -- compatible : Should be "ti,davinci-wdt"
>> +
>> +- compatible:          "ti,davinci-wdt"
>> +                       "ti,keystone-wdt"
>> +
>>   - reg : Should contain WDT registers location and length
>>   
> 
> ...
> 
>> @@ -229,6 +229,7 @@ static int davinci_wdt_remove(struct platform_device *pdev)
>>   
>>   static const struct of_device_id davinci_wdt_of_match[] = {
>>          { .compatible = "ti,davinci-wdt", },
>> +       { .compatible = "ti,keystone-wdt", },
>>          {},
>>   };
>>   MODULE_DEVICE_TABLE(of, davinci_wdt_of_match);
> 
> You should clarify the compatible list here: It seems that the devices are fully
> compatible, so the driver should only need to check for "ti,davinci-wdt" as the
> compatible string, while the dtb files should list both "ti,davinci-wdt" and
> "ti,keystone-wdt" for keystone, but only the davinci string for davinci.
> 
> 	Arnd
> 

Ok, I will remove "ti,keystone-wdt" compatible from driver and for the keystone WDT node
describe compatible as:

compatible = "ti,keystone-wdt", "ti,davinci-wdt";

-- 
Regards,
Ivan Khoronzhuk
