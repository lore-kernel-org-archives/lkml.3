Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaJCM7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:59:13 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:43336 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaJCM7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:59:08 -0400
MIME-Version: 1.0
In-Reply-To: <1411685122-21867-1-git-send-email-behanw@converseincode.com>
References: <5774775.2EcFmuR4sV@wuerfel>
	<1411685122-21867-1-git-send-email-behanw@converseincode.com>
Date: Fri, 3 Oct 2014 14:59:07 +0200
Message-ID: <CAPDyKFruar4iax_goZUmCbyoAM9BwNFLzyss1Fc+pZVkse+a7A@mail.gmail.com>
Subject: Re: [PATCH v3] mmc, sdhci, bcm-kona, LLVMLinux: Remove use of __initconst
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Behan Webster <behanw@converseincode.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Chris Ball <chris@printf.net>,
        Matt Porter <mporter@linaro.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2014 00:45, Behan Webster <behanw@converseincode.com> wrote:
> The __initconst is in the wrong place, and when moved to the correct place
> it uncovers an error where the variable is used by non-init data structures.
>
> Instead merely make them const and put the const in the right spot.
>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Reviewed-by: Mark Charlebois <charlebm@gmail.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Matt Porter <mporter@linaro.org>

Thanks! Applied for next.

Kind regards
Uffe

> ---
>  drivers/mmc/host/sdhci-bcm-kona.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
> index dd780c3..d085dfe 100644
> --- a/drivers/mmc/host/sdhci-bcm-kona.c
> +++ b/drivers/mmc/host/sdhci-bcm-kona.c
> @@ -225,7 +225,7 @@ static struct sdhci_pltfm_data sdhci_pltfm_data_kona = {
>                 SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
>  };
>
> -static struct __initconst of_device_id sdhci_bcm_kona_of_match[] = {
> +static const struct of_device_id sdhci_bcm_kona_of_match[] = {
>         { .compatible = "brcm,kona-sdhci"},
>         { .compatible = "bcm,kona-sdhci"}, /* deprecated name */
>         {}
> --
> 1.9.1
>
