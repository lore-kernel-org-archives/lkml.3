Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaA2PBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:01:01 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54403 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaA2PA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:00:59 -0500
MIME-Version: 1.0
In-Reply-To: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 29 Jan 2014 10:00:27 -0500
X-Google-Sender-Auth: xGvtU8osJcwcNGzK7TbG3e4tzdo
Message-ID: <CAP=VYLpJT1T2RGuK73TXhSYn-K+ZrLx9FuhQe+hVXYGnfoOBcQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] efuse driver for Tegra
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 6:36 PM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> This driver allows userspace to read the raw efuse data. Its userspace
> interface is modelled after the sunxi_sid driver which provides similar
> functionality for some Allwinner SoCs. It has been tested on
> Tegra20 (ventana), Tegra30 (beaverboard) and Tegra114 (dalmore).
>
> Changes since v1:
>
> * Add documentation for sysfs interface
> * Cleanup messages
>
> Changes since v2:
>
> * Incorporate early fuse code
> * Remove module support
> * Make driver always build when Tegra platform is selected

Given the above, you should be able to remove #include <linux/module.h>
and MODULE_DEVICE_TABLE, etc.

Paul.
--

> * Add DT binding document
> * Address comments on v2
>
> TODO:
> * test on Tegra124 (venice2)
>
> Peter De Schrijver (6):
>   ARM: tegra: export apb dma readl/writel
>   ARM: tegra: Add chipid, revision and fuse init
>   misc: fuse: Add efuse driver for Tegra
>   ARM: tegra: Add efuse bindings
>   misc: enable fuse drivers
>   ARM: tegra: remove fuse files from mach-tegra
>
>  Documentation/ABI/testing/sysfs-driver-tegra-fuse  |    8 +
>  .../devicetree/bindings/fuse/fuse-tegra.txt        |   32 +++
>  arch/arm/boot/dts/tegra114.dtsi                    |    7 +
>  arch/arm/boot/dts/tegra124.dtsi                    |    7 +
>  arch/arm/boot/dts/tegra20.dtsi                     |    7 +
>  arch/arm/boot/dts/tegra30.dtsi                     |    7 +
>  arch/arm/mach-tegra/Makefile                       |    4 -
>  arch/arm/mach-tegra/apbio.c                        |   51 ++--
>  arch/arm/mach-tegra/cpuidle.c                      |    2 +-
>  arch/arm/mach-tegra/flowctrl.c                     |    2 +-
>  arch/arm/mach-tegra/fuse.c                         |  252 -----------------
>  arch/arm/mach-tegra/fuse.h                         |   79 ------
>  arch/arm/mach-tegra/hotplug.c                      |    2 +-
>  arch/arm/mach-tegra/platsmp.c                      |    2 +-
>  arch/arm/mach-tegra/pm.c                           |    2 +-
>  arch/arm/mach-tegra/pmc.c                          |    2 +-
>  arch/arm/mach-tegra/powergate.c                    |    2 +-
>  arch/arm/mach-tegra/reset-handler.S                |    2 +-
>  arch/arm/mach-tegra/reset.c                        |    2 +-
>  arch/arm/mach-tegra/sleep-tegra30.S                |    2 +-
>  arch/arm/mach-tegra/tegra.c                        |    2 +-
>  arch/arm/mach-tegra/tegra114_speedo.c              |  104 -------
>  arch/arm/mach-tegra/tegra20_speedo.c               |  109 --------
>  arch/arm/mach-tegra/tegra2_emc.c                   |    2 +-
>  arch/arm/mach-tegra/tegra30_speedo.c               |  292 -------------------
>  drivers/misc/Makefile                              |    1 +
>  drivers/misc/fuse/Makefile                         |    1 +
>  drivers/misc/fuse/tegra/Makefile                   |    7 +
>  drivers/misc/fuse/tegra/fuse-tegra.c               |  228 +++++++++++++++
>  drivers/misc/fuse/tegra/fuse-tegra20.c             |  136 +++++++++
>  drivers/misc/fuse/tegra/fuse-tegra30.c             |  178 ++++++++++++
>  drivers/misc/fuse/tegra/fuse.h                     |   82 ++++++
>  drivers/misc/fuse/tegra/tegra114_speedo.c          |  110 ++++++++
>  drivers/misc/fuse/tegra/tegra124_speedo.c          |  164 +++++++++++
>  drivers/misc/fuse/tegra/tegra20_speedo.c           |  110 ++++++++
>  drivers/misc/fuse/tegra/tegra30_speedo.c           |  294 ++++++++++++++++++++
>  include/linux/tegra-soc.h                          |   39 +++
>  37 files changed, 1461 insertions(+), 872 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-tegra-fuse
>  create mode 100644 Documentation/devicetree/bindings/fuse/fuse-tegra.txt
>  delete mode 100644 arch/arm/mach-tegra/fuse.c
>  delete mode 100644 arch/arm/mach-tegra/fuse.h
>  delete mode 100644 arch/arm/mach-tegra/tegra114_speedo.c
>  delete mode 100644 arch/arm/mach-tegra/tegra20_speedo.c
>  delete mode 100644 arch/arm/mach-tegra/tegra30_speedo.c
>  create mode 100644 drivers/misc/fuse/Makefile
>  create mode 100644 drivers/misc/fuse/tegra/Makefile
>  create mode 100644 drivers/misc/fuse/tegra/fuse-tegra.c
>  create mode 100644 drivers/misc/fuse/tegra/fuse-tegra20.c
>  create mode 100644 drivers/misc/fuse/tegra/fuse-tegra30.c
>  create mode 100644 drivers/misc/fuse/tegra/fuse.h
>  create mode 100644 drivers/misc/fuse/tegra/tegra114_speedo.c
>  create mode 100644 drivers/misc/fuse/tegra/tegra124_speedo.c
>  create mode 100644 drivers/misc/fuse/tegra/tegra20_speedo.c
>  create mode 100644 drivers/misc/fuse/tegra/tegra30_speedo.c
>
> --
> 1.7.7.rc0.72.g4b5ea.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
