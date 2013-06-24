Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab3FXWpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:45:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57686 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3FXWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:45:54 -0400
Message-ID: <51C8CC20.3010700@codeaurora.org>
Date: Mon, 24 Jun 2013 15:45:52 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        arm@kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv2 3/6] sched_clock: Make ARM's sched_clock generic for
 all architectures
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org> <1370155183-31421-4-git-send-email-sboyd@codeaurora.org> <201306211745.57528.arnd@arndb.de> <20130621170523.GA14575@codeaurora.org> <51C49072.1060700@linaro.org>
In-Reply-To: <51C49072.1060700@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/13 10:42, John Stultz wrote:
> On 06/21/2013 10:05 AM, Stephen Boyd wrote:
>> On 06/21, Arnd Bergmann wrote:
>>> This causes build failures when doing a simple merge with the arm-soc
>>> tree:
>>>
>>> ==> build/clps711x_defconfig/faillog <==
>>> /git/arm-soc/arch/arm/mach-clps711x/common.c:37:29: fatal error:
>>> asm/sched_clock.h: No such file or directory
>>>   #include <asm/sched_clock.h>
>>>                               ^
>>> ==> build/imx_v6_v7_defconfig/faillog <==
>>> /git/arm-soc/drivers/clocksource/vf_pit_timer.c:15:29: fatal error:
>>> asm/sched_clock.h: No such file or directory
>>>   #include <asm/sched_clock.h>
>>>
>>> How about adding back a temporary arch/arm/include/asm/sched_clock.h
>>> that only contains "#include <linux/sched_clock.h>" so we can change
>>> those two files after the merge and still get a bisectible history?
>>>
>> Sounds fine. John can you add this patch on top?
>
> Thanks. I've queued this and will send it on to Thomas here shortly.

Thanks John. Can you send this off to the tip tree? I think we'll need
to merge tip/timers into arm-soc so I can send the rest of my "kill ARM
local timer API" series through and this patch helps make that more
palatable.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

