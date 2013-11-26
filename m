Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3KZMeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:34:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35693 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab3KZMel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:34:41 -0500
Message-ID: <52949463.3060609@ti.com>
Date: Tue, 26 Nov 2013 14:30:27 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <wim@iguana.be>, <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>
Subject: Re: [PATCH v3 1/6] watchdog: davinci: change driver to use WDT core
References: <1385388285-10553-1-git-send-email-ivan.khoronzhuk@ti.com> <1385388285-10553-2-git-send-email-ivan.khoronzhuk@ti.com> <52948184.50604@ti.com> <52948FA8.7000609@roeck-us.net>
In-Reply-To: <52948FA8.7000609@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 02:10 PM, Guenter Roeck wrote:
> On 11/26/2013 03:09 AM, Grygorii Strashko wrote:
>> On 11/25/2013 04:04 PM, Ivan Khoronzhuk wrote:
>>> To reduce code duplicate and increase code readability use WDT core
>>> code to handle WDT interface.
>>>
>>> Remove io_lock as the WDT core uses mutex to lock each wdt device.
>>> Remove wdt_state as the WDT core tracks state with its own variable.
>>>
>>> The watchdog_init_timeout() can read timeout value from timeout-sec
>>> property if the passed value is out of bounds. The heartbeat is
>>> initialized in next way. If heartbeat is not set thought module
>>> parameter, try to read it's value from WDT node timeout-sec property.
>>> If node has no one, use default value.
>>>
>>> The heartbeat is hold in wdd->timeout by WDT core, so use it in
>>> order to set timeout period.
>>>
>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>>> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>>> ---
>>>   arch/arm/mach-davinci/da8xx-dt.c      |    2 +-
>>>   arch/arm/mach-davinci/devices-da8xx.c |    4 +-
>>>   arch/arm/mach-davinci/devices.c       |    2 +-
>>>   drivers/watchdog/Kconfig              |    2 +
>>>   drivers/watchdog/davinci_wdt.c        |  151
>>> ++++++++-------------------------
>>>   5 files changed, 43 insertions(+), 118 deletions(-)
>>
>> Pls note, that this patch contains both changes in platform and driver
>> code to fix regression reported by Sekhar Nori on v2 of this series
>> and caused by driver name changing.
>>
>> Is it ok?
>>
>> It can be splitted, but then both patches will introduce regression by
>> itself and thing will work only if both of them will be applied together.
>>
> Splitting it would break bisect, even if applied together, so I don't
> think this would be a good idea.

Thanks

Regards,
-grygorii
