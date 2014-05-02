Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaEBNWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:22:42 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55463 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaEBNWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:22:41 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53639C1C.8050701@roeck-us.net>
Date: Fri, 02 May 2014 06:22:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/5] watchdog: Add API to trigger reboots
References: <1398958893-30049-1-git-send-email-linux@roeck-us.net> <1398958893-30049-2-git-send-email-linux@roeck-us.net> <20140502100105.GC17370@arm.com>
In-Reply-To: <20140502100105.GC17370@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 03:01 AM, Will Deacon wrote:
> Hi Guenter,
>
> This looks pretty sensible to me (and the arm/arm64 bits look fine too), but
> I have one question below...
>
> On Thu, May 01, 2014 at 04:41:29PM +0100, Guenter Roeck wrote:
>> Some hardware implements reboot through its watchdog hardware,
>> for example by triggering a watchdog timeout. Platform specific
>> code starts to spread into watchdog drivers, typically by setting
>> pointers to a callback functions which is then called from the
>> platform reset handler.
>>
>> To simplify code and provide a unified API to trigger reboots by
>> watchdog drivers, provide a single API to trigger such reboots
>> through the watchdog subsystem.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   drivers/watchdog/watchdog_core.c |   17 +++++++++++++++++
>>   include/linux/watchdog.h         |   11 +++++++++++
>>   2 files changed, 28 insertions(+)
>>
>> diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
>> index cec9b55..4ec6e2f 100644
>> --- a/drivers/watchdog/watchdog_core.c
>> +++ b/drivers/watchdog/watchdog_core.c
>> @@ -43,6 +43,17 @@
>>   static DEFINE_IDA(watchdog_ida);
>>   static struct class *watchdog_class;
>>
>> +static struct watchdog_device *wdd_reboot_dev;
>> +
>> +void watchdog_do_reboot(enum reboot_mode mode, const char *cmd)
>> +{
>> +	if (wdd_reboot_dev) {
>> +		if (wdd_reboot_dev->ops->reboot)
>> +			wdd_reboot_dev->ops->reboot(wdd_reboot_dev, mode, cmd);
>> +	}
>> +}
>
> What reboot_mode values would you expect a watchdog to support other than
> REBOOT_HARD? Also, is the cmd even useful here?
>

Answer is "I don't know" in both cases. I thought about dropping the parameters,
but then I thought it does not hurt to have them around either. I am open to
suggestions and to dropping the parameters if everyone agrees that they are
useless.

Guenter

