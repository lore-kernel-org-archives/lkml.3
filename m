Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaGNPBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:01:35 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60491 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbaGNPBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:01:16 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C3F0BA.5020201@roeck-us.net>
Date: Mon, 14 Jul 2014 08:01:14 -0700
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
Subject: Re: [PATCH v4 2/7] arm64: Support restart through restart notifier
 call chain
References: <1405265431-4561-1-git-send-email-linux@roeck-us.net> <1405265431-4561-3-git-send-email-linux@roeck-us.net> <20140714145504.GD1112@arm.com>
In-Reply-To: <20140714145504.GD1112@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 07:55 AM, Catalin Marinas wrote:
> On Sun, Jul 13, 2014 at 04:30:26PM +0100, Guenter Roeck wrote:
>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> index 43b7c34..b2da6d5 100644
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -174,6 +174,8 @@ void machine_restart(char *cmd)
>>   	/* Now call the architecture specific reboot code. */
>>   	if (arm_pm_restart)
>>   		arm_pm_restart(reboot_mode, cmd);
>> +	else
>> +		kernel_restart_notify(cmd);
>
> There are couple of drivers specific to arm64, once they are converted
> we can get rid of arm_pm_restart entirely here.
>

I thought you wanted to keep exporting arm_pm_restart. That logically implies
that you want to have the ability to write new drivers which use it, which
in turn implies that converting existing drivers would not make much sense.

Am I missing something ?

Guenter

