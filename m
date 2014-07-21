Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbaGUMvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:51:09 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57904 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbaGUMvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:51:06 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53CD0CB6.1050803@roeck-us.net>
Date: Mon, 21 Jul 2014 05:51:02 -0700
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
Subject: Re: [PATCH v5 0/7] kernel: Add support for restart handler call chain
References: <1405668856-13738-1-git-send-email-linux@roeck-us.net> <20140721123056.GF12817@arm.com>
In-Reply-To: <20140721123056.GF12817@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 07/21/2014 05:30 AM, Catalin Marinas wrote:
> On Fri, Jul 18, 2014 at 08:34:09AM +0100, Guenter Roeck wrote:
>> Patch 1 of this series implements the restart handler function. Patches 2 and 3
>> implement calling the restart handler chain from arm and arm64 restart code.
>>
>> Patch 4 modifies the restart-poweroff driver to no longer call arm_pm_restart
>> directly but machine_restart. This is done to avoid calling arm_pm_restart
>> from more than one place. The change makes the driver architecture independent,
>> so it would be possible to drop the arm dependency from its Kconfig entry.
>>
>> Patch 5 and 6 convert existing restart handlers in the watchdog subsystem
>> to use the restart handler. Patch 7 unexports arm_pm_restart to ensure
>> that no one gets the idea to implement a restart handler as module.
>
> For the current patches:
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>
> Do you plan to convert more of the power/drivers/reset/ code?
>

Once this series has been accepted, I at least wanted to give it a try.

> BTW, is it worth doing something similar for pm_power_off (there is
> generic code calling it directly, so slightly more complicated than
> pm_restart)?

I have not thought about it yet.

A quick glance suggests it is much more widely used than the reset handler.
It looks like the original idea, like with machine_restart, was to have
one function per architecture, but it seems that is widely abused.

Looks pretty messy to me. Maybe after this one is done, if there is interest
and, more importantly, the need to do something about it.

Thanks,
Guenter

