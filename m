Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaHRMiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:38:10 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:60632 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaHRMiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:38:07 -0400
MIME-Version: 1.0
In-Reply-To: <1407860069-12706-1-git-send-email-peter.griffin@linaro.org>
References: <1407860069-12706-1-git-send-email-peter.griffin@linaro.org>
Date: Mon, 18 Aug 2014 14:38:06 +0200
Message-ID: <CAPDyKFr5ESzjEd3DUO7aMKN9K_Ytuw8GY-fgEyCM4sCGJAX3NQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] MMC cleanup of dev_pm_ops and .owner
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        jarkko.lavinen@nokia.com, balajitk <balajitk@ti.com>,
        Barry Song <baohua@kernel.org>, Viresh Kumar <viresh.linux@gmail.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, spear-devel@list.st.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Patch Tracking <patches@linaro.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2014 18:14, Peter Griffin <peter.griffin@linaro.org> wrote:
> This series cleans up a few platform drivers in how they are declaring there
> dev_pm_ops structs, and gets rid of a few now redundant #else conditions.
>
> Also it removes the .owner field of drivers which use module_platform_driver
> api to register themselves, as this field gets overwritten.
>
> Peter Griffin (5):
>   mmc: remove .owner field for drivers using module_platform_driver
>   mmc: dw_mmc-pci: Remove superflous #else condition on CONFIG_PM_SLEEP
>   mmc: dw_mmc-pltfm: Remove superflous #else condition on
>     CONFIG_PM_SLEEP
>   mmc: sdhci-pci: Use SET_RUNTIME_PM_OPS macro to set runtime pm
>     callbacks
>   mmc: sdhci-acpi.c: Use SET_RUNTIME_PM_OPS macro to set runtime pm
>     callbacks

Thanks! Applied for next!

Kind regards
Uffe

>
>  drivers/mmc/host/dw_mmc-pci.c      |  3 ---
>  drivers/mmc/host/dw_mmc-pltfm.c    |  3 ---
>  drivers/mmc/host/jz4740_mmc.c      |  1 -
>  drivers/mmc/host/moxart-mmc.c      |  1 -
>  drivers/mmc/host/mxcmmc.c          |  1 -
>  drivers/mmc/host/mxs-mmc.c         |  1 -
>  drivers/mmc/host/omap.c            |  1 -
>  drivers/mmc/host/omap_hsmmc.c      |  1 -
>  drivers/mmc/host/pxamci.c          |  1 -
>  drivers/mmc/host/rtsx_pci_sdmmc.c  |  1 -
>  drivers/mmc/host/rtsx_usb_sdmmc.c  |  1 -
>  drivers/mmc/host/s3cmci.c          |  1 -
>  drivers/mmc/host/sdhci-acpi.c      | 11 ++---------
>  drivers/mmc/host/sdhci-bcm-kona.c  |  1 -
>  drivers/mmc/host/sdhci-bcm2835.c   |  1 -
>  drivers/mmc/host/sdhci-cns3xxx.c   |  1 -
>  drivers/mmc/host/sdhci-dove.c      |  1 -
>  drivers/mmc/host/sdhci-esdhc-imx.c |  1 -
>  drivers/mmc/host/sdhci-msm.c       |  1 -
>  drivers/mmc/host/sdhci-of-arasan.c |  1 -
>  drivers/mmc/host/sdhci-of-esdhc.c  |  1 -
>  drivers/mmc/host/sdhci-of-hlwd.c   |  1 -
>  drivers/mmc/host/sdhci-pci.c       | 11 ++---------
>  drivers/mmc/host/sdhci-pxav2.c     |  1 -
>  drivers/mmc/host/sdhci-pxav3.c     |  1 -
>  drivers/mmc/host/sdhci-s3c.c       |  1 -
>  drivers/mmc/host/sdhci-sirf.c      |  1 -
>  drivers/mmc/host/sdhci-spear.c     |  1 -
>  drivers/mmc/host/sdhci-tegra.c     |  1 -
>  drivers/mmc/host/sh_mmcif.c        |  1 -
>  drivers/mmc/host/sh_mobile_sdhi.c  |  1 -
>  drivers/mmc/host/sunxi-mmc.c       |  1 -
>  32 files changed, 4 insertions(+), 52 deletions(-)
>
> --
> 1.9.1
>
