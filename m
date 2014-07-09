Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaGIVPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:15:48 -0400
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:53523 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751778AbaGIVPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:15:46 -0400
MIME-Version: 1.0
In-Reply-To: <53BCBCEC.7010306@roeck-us.net>
References: <1404872153-3594-1-git-send-email-fkan@apm.com>
	<1404872153-3594-2-git-send-email-fkan@apm.com>
	<53BCBCEC.7010306@roeck-us.net>
Date: Wed, 9 Jul 2014 14:15:44 -0700
Message-ID: <CAL85gmB9wRXXrza3g0MBFWUi5w3_eCEhxdSd2FfmoB_SkGA8Ww@mail.gmail.com>
Subject: Re: [PATCH V8 1/6] power: reset: Add generic SYSCON register mapped reset
From: Feng Kan <fkan@apm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 8:54 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 07/08/2014 07:15 PM, Feng Kan wrote:
>>
>> Add a generic SYSCON register mapped reset mechanism.
>>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>> ---
>>   drivers/power/reset/Kconfig         |  6 +++
>>   drivers/power/reset/Makefile        |  1 +
>>   drivers/power/reset/syscon-reboot.c | 91
>> +++++++++++++++++++++++++++++++++++++
>>   3 files changed, 98 insertions(+)
>>   create mode 100644 drivers/power/reset/syscon-reboot.c
>>
>> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
>> index bdcf517..5877b38 100644
>> --- a/drivers/power/reset/Kconfig
>> +++ b/drivers/power/reset/Kconfig
>> @@ -80,3 +80,9 @@ config POWER_RESET_KEYSTONE
>>         help
>>           Reboot support for the KEYSTONE SoCs.
>>
>> +config POWER_RESET_SYSCON
>> +       bool "Generic SYSCON regmap reset driver"
>> +       depends on ARM || ARM64 || COMPILE_TEST
>
>
> As written, this driver is really not generic but very arm specific.
> I don't think COMPILE_TEST is a good idea either, since arm_pm_restart
> is only defined for the arm architecture. Did you try compiling allmodconfig
> or allyesconfig for, say, x86_64 with this patch applied ?
>
> I think this might benefit from using [1], which would make it really
> generic.
>
> Guenter
>
> [1] http://www.spinics.net/lists/kernel/msg1780939.html
This is great, I will base off this list. Did it make it to a branch anywhere?

>
