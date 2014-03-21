Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaCUTmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:42:18 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50071 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaCUTmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:42:14 -0400
MIME-Version: 1.0
In-Reply-To: <1393410552-21497-1-git-send-email-marc.ceeeee@gmail.com>
References: <1393410552-21497-1-git-send-email-marc.ceeeee@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 21 Mar 2014 12:41:30 -0700
Message-ID: <CAGVrzcamYKmOenrcWvCXCioPXLKAhhQ1hPg1DaNpfr5cV7YiAQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/9] ARM: brcmstb: Add Broadcom STB SoC support
To: Marc Carino <marc.ceeeee@gmail.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-26 2:29 GMT-08:00 Marc Carino <marc.ceeeee@gmail.com>:
> This patchset contains the board support package for the
> Broadcom BCM7445 ARM-based SoC [1]. These changes contain a
> minimal set of code needed for a BCM7445-based board to boot
> the Linux kernel.
>
> These changes heavily leverage the OF/devicetree framework. The
> machine is also built into the multi-platform ARMv7 image.

It has been almost a month since this last submission was posted...

Dmitry, David, can you review the drivers/power/ bits and ACK/NACK those?

Thanks!

>
> v7:
> - rebase to v3.14-rc4
> - detect and apply ARM erratum 798181 to Brahma15 CPUs
> - split-up bcm7445.dts into a common dtsi and board-specific dts
>
> v6 (https://lkml.org/lkml/2014/2/3/493):
> - rebased to v3.14-rc1
> - utilize common APIs for handling CPU power-down
> - drop deprecated __cpuinit attributes
>
> v5 (https://lkml.org/lkml/2014/1/21/640):
> - rebased to v3.13 tag
> - make UART DT node a child of 'rdb' node
> - fix ordering of debug UART entries
>
> v4 (https://lkml.org/lkml/2014/1/17/455):
> - make a reboot driver and put it in the drivers folder
> - rework DT bindings to leverage 'syscon'
> - rework BSP code to use 'syscon' for all register mappings
> - misc. tweaks per suggestions from v3
>
> v3 (https://lkml.org/lkml/2014/1/14/696):
> - rebased to v3.13-rc8
> - switched to using 'multi_v7_defconfig'
> - eliminated dependence on compile-time peripheral register access
> - moved DT node iomap out from 'init_early'
> - misc. minor cleanups from mailing-list discussion for v2
>
> v2 (https://lkml.org/lkml/2013/11/26/570):
> - rebased to v3.13-rc1
> - moved implementation to 'mach-bcm' folder
> - added CPU init for B16RM
>
> v1:
> - initial submission
>
> [1] http://www.broadcom.com/products/Cable/Cable-Set-Top-Box-Solutions/BCM7445
>
> Gregory Fong (1):
>   ARM: Enable erratum 798181 for Broadcom Brahma-B15
>
> Marc Carino (8):
>   ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs
>   power: reset: Add reboot driver for brcmstb
>   ARM: brcmstb: add debug UART for earlyprintk support
>   ARM: do CPU-specific init for Broadcom Brahma15 cores
>   ARM: brcmstb: add CPU binding for Broadcom Brahma15
>   ARM: brcmstb: add misc. DT bindings for brcmstb
>   ARM: brcmstb: gic: add compatible string for Broadcom Brahma15
>   ARM: brcmstb: dts: add a reference DTS for Broadcom 7445
>
>  .../devicetree/bindings/arm/brcm-brcmstb.txt       |   95 ++++++
>  Documentation/devicetree/bindings/arm/cpus.txt     |    1 +
>  Documentation/devicetree/bindings/arm/gic.txt      |    1 +
>  arch/arm/Kconfig.debug                             |   15 +-
>  arch/arm/boot/dts/bcm7445-bcm97445svmb.dts         |   14 +
>  arch/arm/boot/dts/bcm7445.dtsi                     |  107 +++++++
>  arch/arm/configs/multi_v7_defconfig                |    1 +
>  arch/arm/kernel/smp_tlb.c                          |   20 +-
>  arch/arm/mach-bcm/Kconfig                          |   15 +
>  arch/arm/mach-bcm/Makefile                         |    4 +
>  arch/arm/mach-bcm/brcmstb.c                        |  104 +++++++
>  arch/arm/mach-bcm/brcmstb.h                        |   38 +++
>  arch/arm/mach-bcm/headsmp-brcmstb.S                |   33 ++
>  arch/arm/mach-bcm/hotplug-brcmstb.c                |  311 ++++++++++++++++++++
>  arch/arm/mm/proc-v7.S                              |   11 +
>  drivers/power/reset/Kconfig                        |   10 +
>  drivers/power/reset/Makefile                       |    1 +
>  drivers/power/reset/brcmstb-reboot.c               |  120 ++++++++
>  18 files changed, 892 insertions(+), 9 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
>  create mode 100644 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
>  create mode 100644 arch/arm/boot/dts/bcm7445.dtsi
>  create mode 100644 arch/arm/mach-bcm/brcmstb.c
>  create mode 100644 arch/arm/mach-bcm/brcmstb.h
>  create mode 100644 arch/arm/mach-bcm/headsmp-brcmstb.S
>  create mode 100644 arch/arm/mach-bcm/hotplug-brcmstb.c
>  create mode 100644 drivers/power/reset/brcmstb-reboot.c
>



-- 
Florian
