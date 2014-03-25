Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaCYLJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 07:09:25 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:65189 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaCYLJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 07:09:23 -0400
Message-ID: <533163D4.6030205@linaro.org>
Date: Tue, 25 Mar 2014 19:09:08 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] arm64: Fix duplicated Kconfig entries again
References: <1395738060-18489-1-git-send-email-hanjun.guo@linaro.org> <533153BF.3070308@arm.com>
In-Reply-To: <533153BF.3070308@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sudeep,

On 2014-3-25 18:00, Sudeep Holla wrote:
> Hi Hanjun,
> 
> On 25/03/14 09:00, Hanjun Guo wrote:
>> After commit 74397174989e5 (arm64: Fix duplicated Kconfig entries),
>> I still get a duplicate Power management options section in linux-next
>> git repo, may be due to some merge conflicts, anyway, fix that in this
>> patch.
>>
> I reported this and Mark Brown posted the patch[1].
> I assumed it is already pulled, but looks like that's not the case.
[...]
> [1] http://www.spinics.net/lists/arm-kernel/msg314472.html

Yes, I noticed this patch in arm maillist, and I can see that this
patch was already merged into linux-next, but I still got duplicate
Power management options in the Kconfig:
---------------------------------
menu "Power management options"

source "kernel/power/Kconfig"

config ARCH_SUSPEND_POSSIBLE
	def_bool y

config ARM64_CPU_SUSPEND
	def_bool PM_SLEEP

endmenu

menu "CPU Power Management"

source "drivers/cpuidle/Kconfig"

source "drivers/cpufreq/Kconfig"

endmenu

menu "Power management options"

source "kernel/power/Kconfig"

source "drivers/cpufreq/Kconfig"

endmenu
--------------------------------
here is the link:
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arm64/Kconfig

Thanks
Hanjun
> 

