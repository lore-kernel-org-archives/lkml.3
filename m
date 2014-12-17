Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaLQShO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:37:14 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:19880 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaLQShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:37:12 -0500
X-IronPort-AV: E=Sophos;i="5.07,595,1413270000"; 
   d="scan'208";a="53161315"
Message-ID: <5491CD37.7090604@broadcom.com>
Date: Wed, 17 Dec 2014 10:36:39 -0800
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH v2] mmc: sdhci: add quirk for ACMD23 broken
References: <Scott Branden <sbranden@broadcom.com> <1417738572-10441-1-git-send-email-sbranden@broadcom.com>
In-Reply-To: <1417738572-10441-1-git-send-email-sbranden@broadcom.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

I have not received any feedback on this patch for the SDHCI controller. 
  Anything I can do to help get this accepted into the codebase?

Thanks,
  Scott

On 14-12-04 04:16 PM, Scott Branden wrote:
> Add quirk to handle broken auto-CMD23.
> Some controllers do not respond after the first auto-CMD23 is issued.
>
> This allows CMD23 to still work (mandatory for the faster UHS-I mode)
> rather than disabling CMD23 entirely via SDHCI_QUIRK2_HOST_NO_CMD23.
>
> Signed-off by: Corneliu Doban <cdoban@broadcom.com>
> Signed-off-by: Scott Branden <sbranden@broadcom.com>
> ---
>   drivers/mmc/host/sdhci.c  | 3 ++-
>   include/linux/mmc/sdhci.h | 2 ++
>   2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index ada1a3e..b37331f 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2985,7 +2985,8 @@ int sdhci_add_host(struct sdhci_host *host)
>   	/* Auto-CMD23 stuff only works in ADMA or PIO. */
>   	if ((host->version >= SDHCI_SPEC_300) &&
>   	    ((host->flags & SDHCI_USE_ADMA) ||
> -	     !(host->flags & SDHCI_USE_SDMA))) {
> +	     !(host->flags & SDHCI_USE_SDMA)) &&
> +	     !(host->quirks2 & SDHCI_QUIRK2_ACMD23_BROKEN)) {
>   		host->flags |= SDHCI_AUTO_CMD23;
>   		DBG("%s: Auto-CMD23 available\n", mmc_hostname(mmc));
>   	} else {
> diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
> index dba793e..d979cf9 100644
> --- a/include/linux/mmc/sdhci.h
> +++ b/include/linux/mmc/sdhci.h
> @@ -100,6 +100,8 @@ struct sdhci_host {
>   #define SDHCI_QUIRK2_BROKEN_DDR50			(1<<7)
>   /* Stop command (CMD12) can set Transfer Complete when not using MMC_RSP_BUSY */
>   #define SDHCI_QUIRK2_STOP_WITH_TC			(1<<8)
> +/* Controller broken with using ACMD23 */
> +#define SDHCI_QUIRK2_ACMD23_BROKEN			(1<<9)
>
>   	int irq;		/* Device IRQ */
>   	void __iomem *ioaddr;	/* Mapped address */
>


