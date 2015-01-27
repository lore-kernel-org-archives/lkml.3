Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbbA0OG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:06:59 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:52807 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbbA0OG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:06:57 -0500
MIME-Version: 1.0
In-Reply-To: <20150126112328.318da5e7@endymion.delvare>
References: <20150126112328.318da5e7@endymion.delvare>
Date: Tue, 27 Jan 2015 15:06:56 +0100
Message-ID: <CAPDyKFo363x7NGEctNwHkpn-6HkAu15qu-ZFtt73mJcWZrce4g@mail.gmail.com>
Subject: Re: [PATCH] mmc: Add hardware dependencies for sdhci-pxav3 and sdhci-pxav2
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 January 2015 at 11:23, Jean Delvare <jdelvare@suse.de> wrote:
> I seem to understand that the sdhci-pxav3 and sdhci-pxav2 drivers are
> only needed on the MMP architecture. So add a hardware dependency on
> ARCH_MMP, so that other users don't get to build useless drivers.

I would rather see the default option to be N.
Thus those configurations that needs this driver will have to select it.

Kind regards
Uffe

>
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
> This patch was already sent on:
>  * 2014-04-23
>  * 2014-06-16
>
>  drivers/mmc/host/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- linux-3.19-rc6.orig/drivers/mmc/host/Kconfig        2015-01-26 10:30:56.472182636 +0100
> +++ linux-3.19-rc6/drivers/mmc/host/Kconfig     2015-01-26 11:13:33.669863314 +0100
> @@ -228,6 +228,7 @@ config MMC_SDHCI_PXAV3
>         tristate "Marvell MMP2 SD Host Controller support (PXAV3)"
>         depends on CLKDEV_LOOKUP
>         depends on MMC_SDHCI_PLTFM
> +       depends on ARCH_MMP || COMPILE_TEST
>         default CPU_MMP2
>         help
>           This selects the Marvell(R) PXAV3 SD Host Controller.
> @@ -240,6 +241,7 @@ config MMC_SDHCI_PXAV2
>         tristate "Marvell PXA9XX SD Host Controller support (PXAV2)"
>         depends on CLKDEV_LOOKUP
>         depends on MMC_SDHCI_PLTFM
> +       depends on ARCH_MMP || COMPILE_TEST
>         default CPU_PXA910
>         help
>           This selects the Marvell(R) PXAV2 SD Host Controller.
>
>
> --
> Jean Delvare
> SUSE L3 Support
