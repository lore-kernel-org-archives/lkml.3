Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3KSQVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:21:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34221 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab3KSQVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:21:32 -0500
Message-ID: <528B8F1C.3090506@ti.com>
Date: Tue, 19 Nov 2013 18:17:32 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Wim Van Sebroeck <wim@iguana.be>, Sekhar Nori <nsekhar@ti.com>,
        <linux-watchdog@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6] watchdog: davinci: change driver to use WDT core
References: <1384795139-19466-1-git-send-email-ivan.khoronzhuk@ti.com> <1384795139-19466-2-git-send-email-ivan.khoronzhuk@ti.com> <528AF349.9070902@roeck-us.net>
In-Reply-To: <528AF349.9070902@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 07:12 AM, Guenter Roeck wrote:
> On 11/18/2013 09:18 AM, Ivan Khoronzhuk wrote:
>> To reduce code duplicate and increase code readability use WDT core
>> code to handle WDT interface.
>>
>> Remove io_lock as the WDT core uses mutex to lock each wdt device.
>> Remove wdt_state as the WDT core track state with its own variable.
>>
>> The watchdog_init_timeout() can read timeout value from timeout-sec
>> property if the passed value is out of bounds. The heartbeat is
>> initialized in next way. If heartbeat is not set thought module
>> parameter, try to read it's value from WDT node timeout-sec property.
>> If node has no one, use default value.
>>
>> The heartbeat is hold in wdd->timeout by WDT core, so use it in
>> order to set timeout period.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> ---
>>   drivers/watchdog/Kconfig       |    2 +
>>   drivers/watchdog/davinci_wdt.c |  152
>> ++++++++++------------------------------
>>   2 files changed, 39 insertions(+), 115 deletions(-)
>>
>> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>> index d1d53f3..d7db13d 100644
>> --- a/drivers/watchdog/Kconfig
>> +++ b/drivers/watchdog/Kconfig
>> @@ -271,6 +271,8 @@ config IOP_WATCHDOG
>>   config DAVINCI_WATCHDOG
>>       tristate "DaVinci watchdog"
>>       depends on ARCH_DAVINCI
>> +    select WATCHDOG_CORE
>> +    select WATCHDOG_NOWAYOUT
>
> Is this mandatory, ie is it correct that the watchdog can not be stopped
> once started ?
>
> Assuming it is,

Yes, it is. Davinci WDT can't be stopped and once it's expired - it can 
be rearmed only after hardware reset.

>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>

Thanks a lot for your review.

Regards,
-grygorii


