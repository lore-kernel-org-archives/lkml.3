Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab3HNKvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:51:15 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35793 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3HNKvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:51:12 -0400
Message-ID: <520B611D.8060500@linaro.org>
Date: Wed, 14 Aug 2013 12:51:09 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 0/6] ARM/ARM64 architected timer updates
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <520B490A.4090109@linaro.org> <520B4B2E.1040700@arm.com>
In-Reply-To: <520B4B2E.1040700@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 11:17 AM, Sudeep KarkadaNagesha wrote:
> On 14/08/13 10:08, Daniel Lezcano wrote:
>> On 08/13/2013 07:29 PM, Sudeep KarkadaNagesha wrote:
>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>
>>> This patch series adds support to configure the rate and enable the
>>> event stream for architected timer. The event streams can be used to
>>> impose a timeout on a WFE, to safeguard against any programming error
>>> in case an expected event is not generated or even to implement
>>> wfe-based timeouts for userspace locking implementations.
>>>
>>> Since the timer control register is reset to zero on warm boot, CPU
>>> PM notifier is added to re-initialize it.
>>
>> It does not apply to my tree.
>>
>> Against which tree is this patchset ? Who is supposed to take it ?
>>
> As I had mentioned in previous version, because of the conflict, I had
> to rebase it on 3.11-rc4


dlezcano@mai:~/Work/src/clockevents$ git show
commit c095ba7224d8edc71dcef0d655911399a8bd4a3f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Aug 4 13:46:46 2013 -0700

    Linux 3.11-rc4

diff --git a/Makefile b/Makefile
index 95a8e55..f93d4f7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 11
 SUBLEVEL = 0
-EXTRAVERSION = -rc3
+EXTRAVERSION = -rc4
 NAME = Linux for Workgroups

 # *DOCUMENTATION*


dlezcano@mai:~/Work/src/clockevents$ git am -s arch_timer

Applying: ARM/ARM64: arch_timer: add macros for bits in control register
Applying: drivers: clocksource: configure event stream for ARM arch timer
Applying: ARM: arch_timer: configure and enable event stream
Applying: ARM64: arch_timer: configure and enable event stream
Applying: drivers: clocksource: add CPU PM notifier for ARM architected
timer
error: patch failed: drivers/clocksource/arm_arch_timer.c:160
error: drivers/clocksource/arm_arch_timer.c: patch does not apply
Patch failed at 0005 drivers: clocksource: add CPU PM notifier for ARM
architected timer
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".


>>> Changes v2->v3:
>>> 1. Moved ARM and ARM64 changes into separate patches
>>> 2. Added native hwcaps definations(ARM/ARM64) and compat-specific
>>>    definitions(ARM64) to the users for the event stream feature. 
>>
>> Ok, we have the choice:
>>  1. split the patchset into arch/arm changes and drivers/clocksource
>>  2. I ack the patchset and Olof/Kevin take it
>>  3. Olof/Kevin ack the patchset and I take it in my tree.
>>
>> This is really becoming fuzzy.
>>
> I am not sure if we need to split it. It would get too messy because of
> dependencies. Once we have ACKs from all the corresponding maintainers,
> it can go through one of the tree.
> 
>> If you want a maintainer to take a patchset you have to send an email
>> --to him and --cc mailing list and others concerned by the patchset.
>>
> Ok understood.
> 
> Regards,
> Sudeep
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

