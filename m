Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbaGNOjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:39:47 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59854 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbaGNOjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:39:40 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C3EBAA.9050907@roeck-us.net>
Date: Mon, 14 Jul 2014 07:39:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 7/7] arm/arm64: Unexport restart handlers
References: <1405265431-4561-1-git-send-email-linux@roeck-us.net> <1405265431-4561-8-git-send-email-linux@roeck-us.net> <20140714142232.GB1112@arm.com>
In-Reply-To: <20140714142232.GB1112@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 07:22 AM, Catalin Marinas wrote:
> On Sun, Jul 13, 2014 at 04:30:31PM +0100, Guenter Roeck wrote:
>> Implementing a restart handler in a module don't make sense
>> as there would be no guarantee that the module is loaded when
>> a restart is needed. Unexport arm_pm_restart to ensure that
>> no one gets the idea to do it anyway.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> v4: No change
>> v3: No change
>> v2: No change
>>
>>   arch/arm/kernel/process.c   | 1 -
>>   arch/arm64/kernel/process.c | 1 -
>>   2 files changed, 2 deletions(-)
>>
>> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
>> index 5d191e3..25c7f00 100644
>> --- a/arch/arm/kernel/process.c
>> +++ b/arch/arm/kernel/process.c
>> @@ -125,7 +125,6 @@ void (*pm_power_off)(void);
>>   EXPORT_SYMBOL(pm_power_off);
>>
>>   void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd) = null_restart;
>> -EXPORT_SYMBOL_GPL(arm_pm_restart);
>
> Unless I miss something, how is this different from registering a
> restart notifier from a module (blocking_notifier_chain_register is
> exported)?
>

A notifier can be unregistered safely, and more than one notifier call
is supported. If there is more than one driver setting arm_pm_restart,
the first one to unregister will clear the pointer. Using the notifier
is cleaner and not architecture dependent. One might argue that setting
module external function pointers from module code isn't exactly clean
coding.

Anyway, this patch is not relevant for the series. If you prefer to have
the function exported, and keep using it for arm drivers loaded as modules,
be my guest, and I'll be more than happy drop it. I'll take your comment
as a hint _not_ to convert existing code to use the notifier after the
series is accepted. Cool, as I hate wasting my time.

Guenter

