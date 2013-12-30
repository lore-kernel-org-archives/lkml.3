Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab3L3GEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 01:04:48 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:43968 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3L3GEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 01:04:45 -0500
MIME-Version: 1.0
In-Reply-To: <1386669911-17319-1-git-send-email-yuvaraj.cd@samsung.com>
References: <1386669911-17319-1-git-send-email-yuvaraj.cd@samsung.com>
Date: Mon, 30 Dec 2013 11:34:44 +0530
Message-ID: <CAKuRcO+pAfG51tXRA2CuvgDFRa4Pfc2pf-Q4GUs3TN57wE53bQ@mail.gmail.com>
Subject: Re: [PATCH V3 0/2] Exynos5250 SATA Support
From: Yuvaraj Kumar <yuvaraj.cd@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, sachin.kamat@linaro.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        sunil joshi <joshi@samsung.com>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments on this series?

On Tue, Dec 10, 2013 at 3:35 PM, Yuvaraj Kumar C D <yuvaraj.cd@gmail.com> wrote:
> This patch series enable the SATA support on Exynos5250 based boards.
> It incorporates the generic phy framework to deal with sata phy.
>
> This patch depends on the below patches
>         [1]. drivers: phy: add generic PHY framework
>                 by Kishon Vijay Abraham I<kishon@ti.com>
>         [2]. ata: ahci_platform: Manage SATA PHY
>                 by Roger Quadros <rogerq@ti.com>
>         [3].ARM: dts: Add pmu sysreg node to exynos5250 and
>                 exynos5420 dtsi files
>                 by Leela Krishna Amudala <l.krishna@samsung.com>
>         [4]. i2c: s3c2410 : Add polling mode support
>                 by Vasanth Ananthan <vasanth.a@samsung.com>
>
> Changes from V2:
>         1.Removed of_match_table
>         2.Moved to syscon interface for PMU handling.
>
> Changes from V1:
>         1. Dropped the patch
>         ahci: exynos: add ahci sata support on Exynos platform
>
>         2.Adapt to latest generic PHY framework available in
>         git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git next
>
>
> Yuvaraj Kumar C D (2):
>   Phy: Exynos: Add Exynos5250 sata phy driver
>   ARM: dts: Enable ahci sata and sata phy
>
>  .../devicetree/bindings/ata/exynos-sata-phy.txt    |   19 +-
>  .../devicetree/bindings/ata/exynos-sata.txt        |   17 +-
>  .../devicetree/bindings/ata/exynos_sataphy_i2c.txt |   12 ++
>  arch/arm/boot/dts/exynos5250-arndale.dts           |    9 +-
>  arch/arm/boot/dts/exynos5250-smdk5250.dts          |    8 +-
>  arch/arm/boot/dts/exynos5250.dtsi                  |   16 +-
>  drivers/phy/Kconfig                                |   11 +
>  drivers/phy/Makefile                               |    1 +
>  drivers/phy/exynos5250_phy_i2c.c                   |   44 ++++
>  drivers/phy/sata_phy_exynos5250.c                  |  219 ++++++++++++++++++++
>  drivers/phy/sata_phy_exynos5250.h                  |   35 ++++
>  11 files changed, 370 insertions(+), 21 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ata/exynos_sataphy_i2c.txt
>  create mode 100644 drivers/phy/exynos5250_phy_i2c.c
>  create mode 100644 drivers/phy/sata_phy_exynos5250.c
>  create mode 100644 drivers/phy/sata_phy_exynos5250.h
>
> --
> 1.7.9.5
>
