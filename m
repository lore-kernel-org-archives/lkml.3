Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbaBRQw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:52:59 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48893 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbaBRQwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:52:42 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [GIT PULL] qcom cleanups for v3.15
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <alpine.DEB.2.00.1402101722170.12284@galak-ubuntu.qualcomm.com>
Date: Tue, 18 Feb 2014 10:41:02 -0600
Cc: David Brown <davidb@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A697C7BB-A3E1-4927-82A8-E37CA3531A03@codeaurora.org>
References: <alpine.DEB.2.00.1402101722170.12284@galak-ubuntu.qualcomm.com>
To: arm@kernel.org
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 10, 2014, at 5:23 PM, Kumar Gala <galak@codeaurora.org> wrote:

> The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:
> 
>  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)
> 
> are available in the git repository at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-cleanup-for-3.15
> 
> for you to fetch changes up to cf1e8f0cd665e2a9966d2bee4e11ecc0938ff166:
> 
>  ARM: qcom: Rename various msm prefixed functions to qcom (2014-02-06 16:20:41 -0600)
> 
> ----------------------------------------------------------------
> General cleanups for MSM/QCOM for 3.15
> 
> Split of the multiplatform support for the Qualcomm SoCs into a mach-qcom
> while we leave mach-msm as legacy support.  Also, some smp and device tree
> related cleanups.
> 
> ----------------------------------------------------------------
> Kumar Gala (6):
>      ARM: dts: msm: split out msm8660 and msm8960 soc into dts include
>      ARM: msm: kill off hotplug.c
>      clocksource: qcom: Move clocksource code out of mach-msm
>      ARM: qcom: Split Qualcomm support into legacy and multiplatform
>      clocksource: qcom: split building of legacy vs multiplatform support
>      ARM: qcom: Rename various msm prefixed functions to qcom
> 
> Rohit Vaswani (1):
>      ARM: msm: Remove pen_release usage
> 
> MAINTAINERS                                        |  8 +++
> arch/arm/Kconfig                                   |  7 +-
> arch/arm/Kconfig.debug                             |  2 +-
> arch/arm/Makefile                                  |  1 +
> arch/arm/boot/dts/Makefile                         |  6 +-
> arch/arm/boot/dts/qcom-msm8660-surf.dts            | 59 +----------------
> arch/arm/boot/dts/qcom-msm8660.dtsi                | 63 ++++++++++++++++++
> arch/arm/boot/dts/qcom-msm8960-cdp.dts             | 66 +------------------
> arch/arm/boot/dts/qcom-msm8960.dtsi                | 70 ++++++++++++++++++++
> arch/arm/mach-msm/Kconfig                          | 54 ++--------------
> arch/arm/mach-msm/Makefile                         |  8 ---
> arch/arm/mach-msm/common.h                         |  1 -
> arch/arm/mach-msm/headsmp.S                        | 39 ------------
> arch/arm/mach-msm/hotplug.c                        | 74 ----------------------
> arch/arm/mach-qcom/Kconfig                         | 33 ++++++++++
> arch/arm/mach-qcom/Makefile                        |  5 ++
> .../arm/{mach-msm/board-dt.c => mach-qcom/board.c} | 15 ++---
> arch/arm/{mach-msm => mach-qcom}/platsmp.c         | 66 ++++++-------------
> arch/arm/{mach-msm => mach-qcom}/scm-boot.c        |  0
> arch/arm/{mach-msm => mach-qcom}/scm-boot.h        |  0
> arch/arm/{mach-msm => mach-qcom}/scm.c             |  0
> arch/arm/{mach-msm => mach-qcom}/scm.h             |  0
> drivers/clocksource/Kconfig                        |  3 +
> drivers/clocksource/Makefile                       |  1 +
> .../timer.c => drivers/clocksource/qcom-timer.c    | 29 ++++-----
> 25 files changed, 240 insertions(+), 370 deletions(-)
> create mode 100644 arch/arm/boot/dts/qcom-msm8660.dtsi
> create mode 100644 arch/arm/boot/dts/qcom-msm8960.dtsi
> delete mode 100644 arch/arm/mach-msm/headsmp.S
> delete mode 100644 arch/arm/mach-msm/hotplug.c
> create mode 100644 arch/arm/mach-qcom/Kconfig
> create mode 100644 arch/arm/mach-qcom/Makefile
> rename arch/arm/{mach-msm/board-dt.c => mach-qcom/board.c} (68%)
> rename arch/arm/{mach-msm => mach-qcom}/platsmp.c (65%)
> rename arch/arm/{mach-msm => mach-qcom}/scm-boot.c (100%)
> rename arch/arm/{mach-msm => mach-qcom}/scm-boot.h (100%)
> rename arch/arm/{mach-msm => mach-qcom}/scm.c (100%)
> rename arch/arm/{mach-msm => mach-qcom}/scm.h (100%)
> rename arch/arm/mach-msm/timer.c => drivers/clocksource/qcom-timer.c (98%)

ping

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

