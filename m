Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaKEK6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:58:14 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:55049 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbaKEK6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:58:12 -0500
MIME-Version: 1.0
In-Reply-To: <1415167754-5801-1-git-send-email-vincent.wan@amd.com>
References: <1415167754-5801-1-git-send-email-vincent.wan@amd.com>
Date: Wed, 5 Nov 2014 11:58:11 +0100
Message-ID: <CAPDyKFpdqACk-g-3eAqLgiMJERnKuQH4baE3mxfYEwomc=zyFQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mmc:sdhci-pci: enable the clear transfer mode
 register quirk for AMD sdhci
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Vincent Wan <vincent.wan@amd.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arindam Nath <arindam.nath@amd.com>, Huang Rui <ray.huang@amd.com>,
        Wan Zongshun <mcuos.com@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 November 2014 07:09, Vincent Wan <vincent.wan@amd.com> wrote:
> This patch is to enable the quirk for AMD sdhci requiring transfer
> mode register need to be cleared for commands without data
>
> Signed-off-by: Vincent Wan <vincent.wan@amd.com>
> Signed-off-by: Wan Zongshun <mcuos.com@gmail.com>

Thanks! Applied for next.

Kind regards
Uffe


> ---
>  drivers/mmc/host/sdhci-pci.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index c25639b..5a77f18 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -645,6 +645,23 @@ static const struct sdhci_pci_fixes sdhci_rtsx = {
>         .probe_slot     = rtsx_probe_slot,
>  };
>
> +static int amd_probe(struct sdhci_pci_chip *chip)
> +{
> +       struct pci_dev  *smbus_dev;
> +
> +       smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD,
> +                       PCI_DEVICE_ID_AMD_HUDSON2_SMBUS, NULL);
> +
> +       if (smbus_dev && (smbus_dev->revision < 0x51))
> +               chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
> +
> +       return 0;
> +}
> +
> +static const struct sdhci_pci_fixes sdhci_amd = {
> +       .probe          = amd_probe,
> +};
> +
>  static const struct pci_device_id pci_ids[] = {
>         {
>                 .vendor         = PCI_VENDOR_ID_RICOH,
> @@ -1044,7 +1061,15 @@ static const struct pci_device_id pci_ids[] = {
>                 .subdevice      = PCI_ANY_ID,
>                 .driver_data    = (kernel_ulong_t)&sdhci_o2,
>         },
> -
> +       {
> +               .vendor         = PCI_VENDOR_ID_AMD,
> +               .device         = PCI_ANY_ID,
> +               .class          = PCI_CLASS_SYSTEM_SDHCI << 8,
> +               .class_mask     = 0xFFFF00,
> +               .subvendor      = PCI_ANY_ID,
> +               .subdevice      = PCI_ANY_ID,
> +               .driver_data    = (kernel_ulong_t)&sdhci_amd,
> +       },
>         {       /* Generic SD host controller */
>                 PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
>         },
> --
> 1.8.1.2
>
