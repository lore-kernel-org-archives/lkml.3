Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab3LDSnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:43:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49819 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab3LDSnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:43:14 -0500
Message-ID: <529F7797.4080100@ti.com>
Date: Wed, 4 Dec 2013 20:42:31 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Sekhar Nori <nsekhar@ti.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <grygorii.strashko@ti.com>
Subject: Re: [PATCH v4 1/5] watchdog: davinci: change driver to use WDT core
References: <1385556508-3935-1-git-send-email-ivan.khoronzhuk@ti.com> <1385556508-3935-2-git-send-email-ivan.khoronzhuk@ti.com> <529F6EBE.5050703@ti.com> <20131204182824.GA14499@roeck-us.net>
In-Reply-To: <20131204182824.GA14499@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 08:28 PM, Guenter Roeck wrote:
> On Wed, Dec 04, 2013 at 11:34:46PM +0530, Sekhar Nori wrote:
>> On 11/27/2013 6:18 PM, Ivan Khoronzhuk wrote:
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
>>> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>>> ---
>>>   drivers/watchdog/Kconfig       |    2 +
>>>   drivers/watchdog/davinci_wdt.c |  147 ++++++++++------------------------------
>>>   2 files changed, 37 insertions(+), 112 deletions(-)
>>>
>>> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>>> index 5be6e91..eb8c89d 100644
>>> --- a/drivers/watchdog/Kconfig
>>> +++ b/drivers/watchdog/Kconfig
>>> @@ -271,6 +271,8 @@ config IOP_WATCHDOG
>>>   config DAVINCI_WATCHDOG
>>>   	tristate "DaVinci watchdog"
>>>   	depends on ARCH_DAVINCI
>>> +	select WATCHDOG_CORE
>>> +	select WATCHDOG_NOWAYOUT
>>
>> Its not clear for change log why NOWAYOUT needs to be forced on all the
>> time for all users of DaVinci watchdog.

... you are right

>>
> Actually, thinking about it, it is not necessary and can be replaced with
> 
> 	watchdog_set_nowayout(wdd, 1);

Good idea, I'll replace watchdog_set_nowayout(wdd, WATCHDOG_NOWAYOUT) on it.
And delete "select WATCHDOG_NOWAYOUT"

> 
> In other words, there is no need to force NOWAYOUT on _other_ watchdogs which
> may be present in the system. Still, you are right, it would be nice to explain
> in the changelog (or maybe even better as comment in the code) why it is
> enforced.
> 
> Guenter
> 

Only question, should I repost only this patch or whole series?

-- 
Regards,
Ivan Khoronzhuk
