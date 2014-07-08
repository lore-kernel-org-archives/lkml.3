Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaGHBM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:12:29 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52973 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbaGHBMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 21:12:25 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BB4577.3020601@roeck-us.net>
Date: Mon, 07 Jul 2014 18:12:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] arm64: Support restart through restart notifier
 call chain
References: <1404689900-27421-1-git-send-email-linux@roeck-us.net>	<1404689900-27421-3-git-send-email-linux@roeck-us.net> <20140707141654.d7fb9f8839cdf58822cd43b9@linux-foundation.org>
In-Reply-To: <20140707141654.d7fb9f8839cdf58822cd43b9@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 02:16 PM, Andrew Morton wrote:
> On Sun,  6 Jul 2014 16:38:15 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>
>> The kernel core now supports a notifier call chain to restart
>> the system. Call it if arm_pm_restart is not set.
>>
>> ...
>>
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -174,6 +174,9 @@ void machine_restart(char *cmd)
>>   	/* Now call the architecture specific reboot code. */
>>   	if (arm_pm_restart)
>>   		arm_pm_restart(reboot_mode, cmd);
>> +	else
>> +		blocking_notifier_call_chain(&restart_notifier_list,
>> +					     reboot_mode, cmd);
>
> It would be a bit neater to have a helper function to perform the call,
> rather than directly accessing the notifier list.  Apart from anything
> else, this hides the fact that the core code (presently!) uses the
> blocking_ style notifiers.
>

Introduced kernel_restart_notify (proposals for better names welcome).
As a side effect, moved restart_notifier_list into kernel/reboot.c and
made it static.

Thanks,
Guenter

