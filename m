Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaFQAVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:21:06 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:59319 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbaFQAVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:21:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140616141803.7d1e2b8a@endymion.delvare>
References: <20140616141803.7d1e2b8a@endymion.delvare>
Date: Tue, 17 Jun 2014 08:21:02 +0800
Message-ID: <CAN1soZw-_YQO9gMEbs6ZGVE9V+pnVL1Qu3zyfu_ErekZtbcTuw@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: Add hardware dependencies for sdhci-pxav3 and sdhci-pxav2
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 8:18 PM, Jean Delvare <jdelvare@suse.de> wrote:
> I seem to understand that the sdhci-pxav3 and sdhci-pxav2 drivers are
> only needed on the MMP architecture. So add a hardware dependency on
> ARCH_MMP, so that other users don't get to build useless drivers.
>
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
> Changes since v1:
>  * Rebased on kernel 3.16-rc1
>
>  drivers/mmc/host/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- linux-3.16-rc1.orig/drivers/mmc/host/Kconfig        2014-06-16 14:03:26.195946537 +0200
> +++ linux-3.16-rc1/drivers/mmc/host/Kconfig     2014-06-16 14:04:02.128663037 +0200
> @@ -217,6 +217,7 @@ config MMC_SDHCI_PXAV3
>         tristate "Marvell MMP2 SD Host Controller support (PXAV3)"
>         depends on CLKDEV_LOOKUP
>         depends on MMC_SDHCI_PLTFM
> +       depends on ARCH_MMP || COMPILE_TEST
>         default CPU_MMP2
>         help
>           This selects the Marvell(R) PXAV3 SD Host Controller.
> @@ -229,6 +230,7 @@ config MMC_SDHCI_PXAV2
>         tristate "Marvell PXA9XX SD Host Controller support (PXAV2)"
>         depends on CLKDEV_LOOKUP
>         depends on MMC_SDHCI_PLTFM
> +       depends on ARCH_MMP || COMPILE_TEST
>         default CPU_PXA910
>         help
>           This selects the Marvell(R) PXAV2 SD Host Controller.
>
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
