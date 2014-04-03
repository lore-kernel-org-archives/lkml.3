Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162589AbaDCIgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:36:05 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:40820 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162555AbaDCIfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:35:54 -0400
Message-ID: <533D1D5E.20208@linaro.org>
Date: Thu, 03 Apr 2014 16:35:42 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] arm64: Fix duplicated Kconfig entries again
References: <1395738060-18489-1-git-send-email-hanjun.guo@linaro.org> <5334078A.9010408@arm.com> <53341ADF.2050904@linaro.org> <2765234.k5FCzWzCDz@vostro.rjw.lan>
In-Reply-To: <2765234.k5FCzWzCDz@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Sorry the late reply.

On 2014-3-27 23:18, Rafael J. Wysocki wrote:
[...]
>>> Just had a look at the linux-next tree and looks like the original commit:
>>> "cpufreq: enable ARM drivers on arm64" is pulled by both Catalin and Rafael
>>> which has resulted in the fixup patch[1] not removing the duplicate entry
>>> cleanly.
>>>
>>> If not too late it better to ask either Rafael or Catalin to drop both patches
>>> from their tree, instead of creating 4 patches in total to enable cpufreq :)
>>
>> Rafael is on vacation now.
>>
>> Catalin, could you please handle this?
> 
> Well, not really, I'm at a conference now.

Oops...

> 
> Anyway, I'd rather not drop anything, but if you send me a revert, I can apply it.

Mark Brown sent another patch to fix this problem, and that patch already merged
into mainline, but the problem is still there, so I think a single revert will
not help.

How about the following patch? if it is ok, I will resend it.

After commit 74397174989e5 (arm64: Fix duplicated Kconfig entries),
I still get a duplicate Power management options section in linux-next
git repo, may be due to some merge conflicts, anyway, fix that in this
patch.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
Based on linux-next repo, weird, did I miss something?
---
 arch/arm64/Kconfig |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index d9f23ad..6085dca 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -317,24 +317,12 @@ config ARCH_SUSPEND_POSSIBLE
 config ARM64_CPU_SUSPEND
 	def_bool PM_SLEEP

-endmenu
-
-menu "CPU Power Management"
-
 source "drivers/cpuidle/Kconfig"

 source "drivers/cpufreq/Kconfig"

 endmenu

-menu "Power management options"
-
-source "kernel/power/Kconfig"
-
-source "drivers/cpufreq/Kconfig"
-
-endmenu
-
 source "net/Kconfig"

 source "drivers/Kconfig"

