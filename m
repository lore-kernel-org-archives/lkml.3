Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaKEK6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:58:33 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:33275 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaKEK6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:58:31 -0500
MIME-Version: 1.0
In-Reply-To: <1415167768-5839-1-git-send-email-vincent.wan@amd.com>
References: <1415167768-5839-1-git-send-email-vincent.wan@amd.com>
Date: Wed, 5 Nov 2014 11:58:30 +0100
Message-ID: <CAPDyKFpfWZ6NBGEsGx7e9oeCWZtixAnFu0E-d2nBBX=ji73V=Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mmc:sdhci-pci: enable sdhci doesn't support hs200
 quirk for AMD sdhci
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
> AMD SD controller supports the SDR104 mode, but caps2 can not
> be promoted to support hs200 for eMMC.
>
> Signed-off-by: Vincent Wan <vincent.wan@amd.com>
> Signed-off-by: Wan Zongshun <mcuos.com@gmail.com>

Thanks! Applied for next.

Kind regards
Uffe


> ---
>  drivers/mmc/host/sdhci-pci.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index 5a77f18..c1ecd20 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -652,8 +652,10 @@ static int amd_probe(struct sdhci_pci_chip *chip)
>         smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD,
>                         PCI_DEVICE_ID_AMD_HUDSON2_SMBUS, NULL);
>
> -       if (smbus_dev && (smbus_dev->revision < 0x51))
> +       if (smbus_dev && (smbus_dev->revision < 0x51)) {
>                 chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
> +               chip->quirks2 |= SDHCI_QUIRK2_BROKEN_HS200;
> +       }
>
>         return 0;
>  }
> --
> 1.8.1.2
>
