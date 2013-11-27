Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab3K0HEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 02:04:12 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50319 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3K0HEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 02:04:10 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52959966.7000509@roeck-us.net>
Date: Tue, 26 Nov 2013 23:04:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        Pawel Moll <Pawel.Moll@arm.com>, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, galak@kernel.crashing.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, grygorii.strashko@ti.com
Subject: Re: [PATCH v3 1/6] watchdog: davinci: change driver to use WDT core
References: <1385388285-10553-1-git-send-email-ivan.khoronzhuk@ti.com> <1385388285-10553-2-git-send-email-ivan.khoronzhuk@ti.com> <5295758C.2030907@ti.com>
In-Reply-To: <5295758C.2030907@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 08:31 PM, Sekhar Nori wrote:
> On Monday 25 November 2013 07:34 PM, Ivan Khoronzhuk wrote:
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
> So this still causes a regression because the clk_get()
> fails due to the changed device name. Please fold this
> patch in (tested on DM365, compiled on rest).
>
> Also, the change in device name (while needed) does not seem
> to be related to usage of wdt core. Can you may be split
> that change into a separate patch?
>

Given all the trouble with it, I think that would be a good idea.

Guenter

