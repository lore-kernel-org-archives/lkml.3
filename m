Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaGJNBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:01:07 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:55760 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaGJNBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:01:05 -0400
MIME-Version: 1.0
In-Reply-To: <1404817861-23359-3-git-send-email-mauricex.r.petallo@intel.com>
References: <1404817861-23359-1-git-send-email-mauricex.r.petallo@intel.com>
	<1404817861-23359-3-git-send-email-mauricex.r.petallo@intel.com>
Date: Thu, 10 Jul 2014 15:01:04 +0200
Message-ID: <CAPDyKFpph=PpUXY_jR6tZtpG=QovJdC5o+6aAx6fCyDcn70DHA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc: sdhci: add DDR50 1.8V mode support for BayTrail
 eMMC Controller
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Maurice Petallo <mauricex.r.petallo@intel.com>
Cc: Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 July 2014 13:11, Maurice Petallo <mauricex.r.petallo@intel.com> wrote:
> This is to enable DDR50 bus speed mode with 1.8V signaling capability
> for BayTrail ACPI and PCI mode eMMC Controller.
>
> Signed-off-by: Maurice Petallo <mauricex.r.petallo@intel.com>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>

Thanks! Applied for next.

Kind regards
Uffe


> ---
>  drivers/mmc/host/sdhci-acpi.c | 3 ++-
>  drivers/mmc/host/sdhci-pci.c  | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
> index 840788e..8c53370 100644
> --- a/drivers/mmc/host/sdhci-acpi.c
> +++ b/drivers/mmc/host/sdhci-acpi.c
> @@ -124,7 +124,8 @@ static const struct sdhci_acpi_chip sdhci_acpi_chip_int = {
>
>  static const struct sdhci_acpi_slot sdhci_acpi_slot_int_emmc = {
>         .chip    = &sdhci_acpi_chip_int,
> -       .caps    = MMC_CAP_8_BIT_DATA | MMC_CAP_NONREMOVABLE | MMC_CAP_HW_RESET,
> +       .caps    = MMC_CAP_8_BIT_DATA | MMC_CAP_NONREMOVABLE |
> +                  MMC_CAP_HW_RESET | MMC_CAP_1_8V_DDR,
>         .caps2   = MMC_CAP2_HC_ERASE_SZ,
>         .flags   = SDHCI_ACPI_RUNTIME_PM,
>         .quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index 7514cc7..89bd721 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -264,7 +264,7 @@ static void sdhci_pci_int_hw_reset(struct sdhci_host *host)
>  static int byt_emmc_probe_slot(struct sdhci_pci_slot *slot)
>  {
>         slot->host->mmc->caps |= MMC_CAP_8_BIT_DATA | MMC_CAP_NONREMOVABLE |
> -                                MMC_CAP_HW_RESET;
> +                                MMC_CAP_HW_RESET | MMC_CAP_1_8V_DDR;
>         slot->host->mmc->caps2 |= MMC_CAP2_HC_ERASE_SZ;
>         slot->hw_reset = sdhci_pci_int_hw_reset;
>         return 0;
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
