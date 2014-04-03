Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaDCJ14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:27:56 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47792 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaDCJ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:27:50 -0400
Message-ID: <533D2980.6000903@linaro.org>
Date: Thu, 03 Apr 2014 17:27:28 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Mark Brown <broonie@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: [PATCH] arm64: Fix duplicated Kconfig entries again
References: <1395738060-18489-1-git-send-email-hanjun.guo@linaro.org> <5334078A.9010408@arm.com> <53341ADF.2050904@linaro.org> <2765234.k5FCzWzCDz@vostro.rjw.lan> <533D1D5E.20208@linaro.org> <CAOh2x=nYWjB+Org6eNjQAT93ZX2DRHNYSJWgWTo8vS2AmdrAbA@mail.gmail.com> <20140403085120.GB17022@arm.com>
In-Reply-To: <20140403085120.GB17022@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-4-3 16:51, Catalin Marinas wrote:
> On Thu, Apr 03, 2014 at 09:41:57AM +0100, Viresh Kumar wrote:
>> On Thu, Apr 3, 2014 at 2:05 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>>> How about the following patch? if it is ok, I will resend it.
>>
>> http://www.spinics.net/lists/arm-kernel/msg319545.html
> 
> I can see commit 62d1a3ba5adc5653d43f6cd3a90758bb6ad5d5bd (arm64: Fix
> duplicated Kconfig entries again) already in mainline, so problem
> solved.
> 
> Thanks Josh ;)

Great, thanks Viresh to let me know this.
Actually I also sent a patch named "arm64: Fix duplicated Kconfig entries
again" about one week ago :)

https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg612363.html

And I think there is still a problem after commit 62d1a3ba - multi-entries
for source "kernel/power/Kconfig", so how about the following fix?

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e6e4d37..6085dca 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -317,14 +317,8 @@ config ARCH_SUSPEND_POSSIBLE
 config ARM64_CPU_SUSPEND
        def_bool PM_SLEEP

-endmenu
-
-menu "CPU Power Management"
-
 source "drivers/cpuidle/Kconfig"

-source "kernel/power/Kconfig"
-
 source "drivers/cpufreq/Kconfig"

 endmenu

If it makes sense, I will send out a patch for it.

Thanks
Hanjun
