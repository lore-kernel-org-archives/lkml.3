Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaGBJA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:00:57 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:33598 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaGBJAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:00:54 -0400
MIME-Version: 1.0
In-Reply-To: <1403618196-7366-2-git-send-email-alvin.chen@intel.com>
References: <1403618196-7366-1-git-send-email-alvin.chen@intel.com>
	<1403618196-7366-2-git-send-email-alvin.chen@intel.com>
Date: Wed, 2 Jul 2014 11:00:53 +0200
Message-ID: <CAPDyKFq8cQHhadSAcaMG6XTKKaZ3XjX5PQyxsRteqhbcMaYZ0A@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: sdhci-pci: SDIO host controller support for Intel
 Quark X1000
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Chen, Alvin" <alvin.chen@intel.com>
Cc: Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2014 15:56, Chen, Alvin <alvin.chen@intel.com> wrote:
> From: Derek Browne <Derek.Browne@intel.com>
>
> This patch is to enable SDIO host controller for Intel Quark X1000.
>
> Signed-off-by: Derek Browne <Derek.Browne@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>

Thanks! Applied for next.

Kind regards
Uffe

> ---
> changelog v2:
> *Delete '#define PCI_DEVICE_ID_INTEL_QUARK_ILB 0x095E' from 'include/linux/pci_ids.h'.
> *Move '#define PCI_DEVICE_ID_INTEL_QRK_SD 0x08A7' from 'include/linux/pci_ids.h'
>  to 'driver/mmc/host/sdhci-pci.h'.
> *Update the subject and description.
>
>  drivers/mmc/host/sdhci-pci.c |   12 ++++++++++++
>  drivers/mmc/host/sdhci-pci.h |    1 +
>  2 files changed, 13 insertions(+)
>
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index 52c42fc..1aeeefc 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -103,6 +103,10 @@ static const struct sdhci_pci_fixes sdhci_cafe = {
>                           SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
>  };
>
> +static const struct sdhci_pci_fixes sdhci_intel_qrk = {
> +       .quirks         = SDHCI_QUIRK_NO_HISPD_BIT,
> +};
> +
>  static int mrst_hc_probe_slot(struct sdhci_pci_slot *slot)
>  {
>         slot->host->mmc->caps |= MMC_CAP_8_BIT_DATA;
> @@ -753,6 +757,14 @@ static const struct pci_device_id pci_ids[] = {
>
>         {
>                 .vendor         = PCI_VENDOR_ID_INTEL,
> +               .device         = PCI_DEVICE_ID_INTEL_QRK_SD,
> +               .subvendor      = PCI_ANY_ID,
> +               .subdevice      = PCI_ANY_ID,
> +               .driver_data    = (kernel_ulong_t)&sdhci_intel_qrk,
> +       },
> +
> +       {
> +               .vendor         = PCI_VENDOR_ID_INTEL,
>                 .device         = PCI_DEVICE_ID_INTEL_MRST_SD0,
>                 .subvendor      = PCI_ANY_ID,
>                 .subdevice      = PCI_ANY_ID,
> diff --git a/drivers/mmc/host/sdhci-pci.h b/drivers/mmc/host/sdhci-pci.h
> index 6d71871..c101477 100644
> --- a/drivers/mmc/host/sdhci-pci.h
> +++ b/drivers/mmc/host/sdhci-pci.h
> @@ -17,6 +17,7 @@
>  #define PCI_DEVICE_ID_INTEL_CLV_SDIO2  0x08fb
>  #define PCI_DEVICE_ID_INTEL_CLV_EMMC0  0x08e5
>  #define PCI_DEVICE_ID_INTEL_CLV_EMMC1  0x08e6
> +#define PCI_DEVICE_ID_INTEL_QRK_SD     0x08A7
>
>  /*
>   * PCI registers
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
