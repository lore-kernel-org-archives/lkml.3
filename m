Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaDCJis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:38:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45503 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaDCJii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:38:38 -0400
MIME-Version: 1.0
In-Reply-To: <533D2980.6000903@linaro.org>
References: <1395738060-18489-1-git-send-email-hanjun.guo@linaro.org>
	<5334078A.9010408@arm.com>
	<53341ADF.2050904@linaro.org>
	<2765234.k5FCzWzCDz@vostro.rjw.lan>
	<533D1D5E.20208@linaro.org>
	<CAOh2x=nYWjB+Org6eNjQAT93ZX2DRHNYSJWgWTo8vS2AmdrAbA@mail.gmail.com>
	<20140403085120.GB17022@arm.com>
	<533D2980.6000903@linaro.org>
Date: Thu, 3 Apr 2014 15:08:37 +0530
Message-ID: <CAKohpok5KCmR4UYG1ZkGL2TcXqqO7dPJnwGg49ahU-ceL1+wxA@mail.gmail.com>
Subject: Re: [PATCH] arm64: Fix duplicated Kconfig entries again
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Mark Brown <broonie@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 April 2014 14:57, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> Great, thanks Viresh to let me know this.
> Actually I also sent a patch named "arm64: Fix duplicated Kconfig entries
> again" about one week ago :)
>
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg612363.html
>
> And I think there is still a problem after commit 62d1a3ba - multi-entries
> for source "kernel/power/Kconfig", so how about the following fix?

I didn't notice that :)

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e6e4d37..6085dca 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -317,14 +317,8 @@ config ARCH_SUSPEND_POSSIBLE
>  config ARM64_CPU_SUSPEND
>         def_bool PM_SLEEP
>
> -endmenu
> -
> -menu "CPU Power Management"
> -
>  source "drivers/cpuidle/Kconfig"
>
> -source "kernel/power/Kconfig"
> -
>  source "drivers/cpufreq/Kconfig"
>
>  endmenu
>
> If it makes sense, I will send out a patch for it.

We actually need to menu options here,
menu "Power management options"
menu "CPU Power Management"

And so probably you just need to do this:
> -source "kernel/power/Kconfig"
> -

from CPU Power Management options..
