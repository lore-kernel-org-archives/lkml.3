Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbaAFWTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:19:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47270 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbaAFWTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:19:12 -0500
Message-ID: <52CB2BDF.9040208@codeaurora.org>
Date: Mon, 06 Jan 2014 14:19:11 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>
CC: David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 0/9] CPU enable method based SMP/hotplug + MSM conversion
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping? Can anyone take a look at the generic ARM and DT binding patches
and provide acks/reviews? I'd like to send this through arm-soc via the
MSM tree if possible.

On 12/23/13 16:39, Stephen Boyd wrote:
> This is a rework of patches sent a months back by Rohit[1].
> The goal of these patches is to add support for SMP and (basic)
> hotplug on MSM based SoCs. To get there, we add support for a
> generic way to hook in SMP/hotplug support code based on DT. To
> show how it's used, we convert the MSM8660 SMP support code over
> to the new method. After that we add support for the rest of the
> upstream MSM SoCs (note these patches are piled high on top of
> Rohit's patches to add 8074 support to MSM[2] and my follow ups[3,4],
> but this should only matter to the MSM maintainers).
>
> This is one of the last items of code that still requires us to have
> a mach directory and a machine descriptor. We should be able to move
> the hotplug/smp code out of mach directories if this approach is
> accepted.
>
> Changes since v1:
>  * Added pointers from cpu nodes to saw and acc nodes
>  * Squashed nr_cpus removal into reorganization patch
>  * Reworked bindings/documentation
>  * Rebased onto v3.13-rc4
>
> [1] https://lkml.org/lkml/2013/8/1/770
> [2] https://lkml.org/lkml/2013/10/17/520
> [3] https://lkml.org/lkml/2013/10/18/406
> [4] http://lkml.org/lkml/2013/10/28/501
>  
>
> Rohit Vaswani (6):
>   devicetree: bindings: Document Krait/Scorpion cpus and enable-method
>   ARM: msm: Remove pen_release usage
>   ARM: msm: Re-organize platsmp to make it extensible
>   ARM: msm: Add SMP support for KPSSv1
>   ARM: msm: Add SMP support for KPSSv2
>   ARM: dts: msm: Add nodes necessary for SMP boot
>
> Stephen Boyd (3):
>   devicetree: bindings: Document qcom,kpss-acc
>   devicetree: bindings: Document qcom,saw2 node
>   ARM: Introduce CPU_METHOD_OF_DECLARE() for cpu hotplug/smp
>
>  Documentation/devicetree/bindings/arm/cpus.txt     |  25 +-
>  .../devicetree/bindings/arm/msm/qcom,kpss-acc.txt  |  30 ++
>  .../devicetree/bindings/arm/msm/qcom,saw2.txt      |  35 ++
>  arch/arm/boot/dts/qcom-msm8660-surf.dts            |  24 ++
>  arch/arm/boot/dts/qcom-msm8960-cdp.dts             |  52 +++
>  arch/arm/boot/dts/qcom-msm8974.dtsi                |  69 ++++
>  arch/arm/include/asm/smp.h                         |   9 +
>  arch/arm/kernel/devtree.c                          |  40 +++
>  arch/arm/mach-msm/Makefile                         |   2 +-
>  arch/arm/mach-msm/board-dt.c                       |  14 -
>  arch/arm/mach-msm/common.h                         |   1 -
>  arch/arm/mach-msm/headsmp.S                        |  39 ---
>  arch/arm/mach-msm/hotplug.c                        |  31 +-
>  arch/arm/mach-msm/platsmp.c                        | 371 ++++++++++++++++-----
>  arch/arm/mach-msm/scm-boot.h                       |   8 +-
>  include/asm-generic/vmlinux.lds.h                  |  10 +
>  16 files changed, 595 insertions(+), 165 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
>  create mode 100644 Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt
>  delete mode 100644 arch/arm/mach-msm/headsmp.S
>


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

