Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3HSWgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:36:20 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3541 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab3HSWgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:36:18 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <52129DDD.3000401@broadcom.com>
Date: Mon, 19 Aug 2013 15:36:13 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Markus Mayer" <markus.mayer@linaro.org>
cc: "Chris Ball" <cjb@laptop.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        "Linaro Patches" <patches@linaro.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Matt Porter" <matt.porter@linaro.org>
Subject: Re: [PATCH] mmc: sdhci-bcm-kona: make linker-section warning go
 away
References: <1375915199-13694-1-git-send-email-markus.mayer@linaro.org>
In-Reply-To: <1375915199-13694-1-git-send-email-markus.mayer@linaro.org>
X-WSS-ID: 7E0C437831W85793436-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-08-07 03:39 PM, Markus Mayer wrote:
> This change makes the following build warning go away:
> [...]
>    LINK    vmlinux
>    LD      vmlinux.o
>    MODPOST vmlinux.o
> WARNING: modpost: Found 2 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Christian Daudt <csd@broadcom.com>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---
>   drivers/mmc/host/sdhci-bcm-kona.c |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
> index 87175f9..34fd652 100644
> --- a/drivers/mmc/host/sdhci-bcm-kona.c
> +++ b/drivers/mmc/host/sdhci-bcm-kona.c
> @@ -221,13 +221,13 @@ static struct sdhci_pltfm_data sdhci_pltfm_data_kona = {
>   		SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
>   };
>   
> -static const struct of_device_id sdhci_bcm_kona_of_match[] __initdata = {
> +static struct __initconst of_device_id sdhci_bcm_kona_of_match[] = {
>   	{ .compatible = "bcm,kona-sdhci"},
>   	{}
>   };
>   MODULE_DEVICE_TABLE(of, sdhci_bcm_kona_of_match);
>   
> -static int __init sdhci_bcm_kona_probe(struct platform_device *pdev)
> +static int sdhci_bcm_kona_probe(struct platform_device *pdev)
>   {
>   	struct sdhci_bcm_kona_dev *kona_dev = NULL;
>   	struct sdhci_pltfm_host *pltfm_priv;
> @@ -336,10 +336,10 @@ static struct platform_driver sdhci_bcm_kona_driver = {
>   		.name	= "sdhci-kona",
>   		.owner	= THIS_MODULE,
>   		.pm	= SDHCI_PLTFM_PMOPS,
> -		.of_match_table = of_match_ptr(sdhci_bcm_kona_of_match),
> +		.of_match_table = sdhci_bcm_kona_of_match,
>   	},
>   	.probe		= sdhci_bcm_kona_probe,
> -	.remove		= __exit_p(sdhci_bcm_kona_remove),
> +	.remove		= sdhci_bcm_kona_remove,
>   };
>   module_platform_driver(sdhci_bcm_kona_driver);
>   
Applied to bcm/for-3.12/soc

  thanks,
    csd


