Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbaIWVUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:20:49 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53544 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbaIWVUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:20:47 -0400
Date: Tue, 23 Sep 2014 17:20:42 -0400
From: Matt Porter <mporter@linaro.org>
To: behanw@converseincode.com
Cc: bcm@fixthebug.org, chris@printf.net, gnurou@gmail.com,
        linus.walleij@linaro.org, ulf.hansson@linaro.org,
        bcm-kernel-feedback-list@broadcom.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        rjui@broadcom.com
Subject: Re: [PATCH] gpio, bcm-kona, LLVMLinux: Remove use of __initconst
Message-ID: <20140923212042.GF12270@beef>
References: <1411500616-12863-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411500616-12863-1-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 12:30:16PM -0700, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
> 
> The __initconst is in the wrong place, and when moved to the correct place
> it uncovers an error where the variable is used by non-init data structures.
> 
> Instead merely make them const and put the const in the right spot.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Reviewed-by: Mark Charlebois <charlebm@gmail.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/gpio/gpio-bcm-kona.c      | 2 +-
>  drivers/mmc/host/sdhci-bcm-kona.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
> index 3f6b33c..de0801e 100644
> --- a/drivers/gpio/gpio-bcm-kona.c
> +++ b/drivers/gpio/gpio-bcm-kona.c
> @@ -496,7 +496,7 @@ static struct irq_chip bcm_gpio_irq_chip = {
>  	.irq_release_resources = bcm_kona_gpio_irq_relres,
>  };
>  
> -static struct __initconst of_device_id bcm_kona_gpio_of_match[] = {
> +static struct of_device_id const bcm_kona_gpio_of_match[] = {
>  	{ .compatible = "brcm,kona-gpio" },
>  	{}
>  };
> diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
> index dd780c3..4bb06c8 100644
> --- a/drivers/mmc/host/sdhci-bcm-kona.c
> +++ b/drivers/mmc/host/sdhci-bcm-kona.c
> @@ -225,7 +225,7 @@ static struct sdhci_pltfm_data sdhci_pltfm_data_kona = {
>  		SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
>  };
>  
> -static struct __initconst of_device_id sdhci_bcm_kona_of_match[] = {
> +static struct of_device_id const sdhci_bcm_kona_of_match[] = {
>  	{ .compatible = "brcm,kona-sdhci"},
>  	{ .compatible = "bcm,kona-sdhci"}, /* deprecated name */
>  	{}

Acked-by: Matt Porter <mporter@linaro.org>

-Matt
