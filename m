Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3KYO5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:57:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59728 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab3KYO5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:57:46 -0500
Message-ID: <5293652B.80402@ti.com>
Date: Mon, 25 Nov 2013 16:56:43 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <wim@iguana.be>, <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 1/6] watchdog: davinci: change driver to use WDT core
References: <1385388285-10553-1-git-send-email-ivan.khoronzhuk@ti.com> <1385388285-10553-2-git-send-email-ivan.khoronzhuk@ti.com> <52935BAD.9080908@ti.com>
In-Reply-To: <52935BAD.9080908@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 04:16 PM, Santosh Shilimkar wrote:
> Ivan,
>
> On Monday 25 November 2013 09:04 AM, Ivan Khoronzhuk wrote:
>> To reduce code duplicate and increase code readability use WDT core
>> code to handle WDT interface.
>>
>> Remove io_lock as the WDT core uses mutex to lock each wdt device.
>> Remove wdt_state as the WDT core tracks state with its own variable.
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
>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>
> Minor suggestion regarding the SOB line which applies to
> rest of the series as well. Typically your SOB line
> should be the last one like below.
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>
> No need to repost the series just for that. The last
> patch as I commented earlier, needs to be separate
> patch which will go via linux-keystone tree.
>
> Once the watchdog maintainer is happy with rest of the
> series and applies it, I will pick last patch.
>
> Regards,
> Santosh
>

Thanks, Santosh
I'll take note.

-- 
Regards,
Ivan Khoronzhuk
