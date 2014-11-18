Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaKRANw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:13:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56466 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751907AbaKRANv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:13:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@linaro.org>
Subject: Re: linux-next: build warning after merge of the pm tree
Date: Tue, 18 Nov 2014 01:34:54 +0100
Message-ID: <22131093.MONpcKKQM4@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416267909.7024.3.camel@x220>
References: <20141117134414.7f4d8d21@canb.auug.org.au> <1721522.tICxlGjU6i@vostro.rjw.lan> <1416267909.7024.3.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 18, 2014 12:45:09 AM Paul Bolle wrote:
> On Tue, 2014-11-18 at 00:14 +0100, Rafael J. Wysocki wrote:
> > I'll drop the commit for now, but this looks strange.
> > 
> > Had you cleaned up the kernel configuration after dropping the PM_RUNTIME select
> > from ARCH_EXYNOS?
> 
> I retested this again:
> 
> [linux * (next-20141117)]$ git status
> HEAD detached at next-20141117
> nothing to commit (use -u to show untracked files)
> [linux * (next-20141117)]$ make clean
> [linux * (next-20141117)]$ cp arch/arm/configs/omap2plus_defconfig .config
> [linux * (next-20141117)]$ vim arch/arm/mach-exynos/Kconfig:24:
> [linux * (next-20141117)]$ git diff
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index e4a00bafffc1..02ff8534238b 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -21,7 +21,6 @@ menuconfig ARCH_EXYNOS
>         select HAVE_S3C_RTC if RTC_CLASS
>         select PINCTRL
>         select PINCTRL_EXYNOS
> -       select PM_GENERIC_DOMAINS if PM_RUNTIME
>         select S5P_DEV_MFC
>         select SRAM
>         select MFD_SYSCON
> [linux * (next-20141117)]$ yes "" | make  ARCH=arm oldconfig >/dev/null
> kernel/power/Kconfig:145:error: recursive dependency detected!
> kernel/power/Kconfig:145:	symbol PM depends on PM_RUNTIME
> kernel/power/Kconfig:132:	symbol PM_RUNTIME is selected by PM_GENERIC_DOMAINS
> kernel/power/Kconfig:272:	symbol PM_GENERIC_DOMAINS is selected by PM
> 
> Can you reproduce the above?

I can't personally.

Anyway, I'm going to drop the commit as I said.

Rafael

