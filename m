Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaHRMkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:40:11 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:52793 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaHRMkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:40:09 -0400
MIME-Version: 1.0
In-Reply-To: <1408107735-20775-1-git-send-email-peter.griffin@linaro.org>
References: <1408107735-20775-1-git-send-email-peter.griffin@linaro.org>
Date: Mon, 18 Aug 2014 14:40:07 +0200
Message-ID: <CAPDyKFrC-8UE5k3FG8SumB8yTg+G0hGY0dzEXuV0RfQKt=64qg@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: sdhci-pxav3: set_uhs_signaling is initialized
 twice differently
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        zhangfei.gao@marvell.com, Philip Rakity <prakity@marvell.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Patch Tracking <patches@linaro.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 August 2014 15:02, Peter Griffin <peter.griffin@linaro.org> wrote:
> .set_uhs_signaling field is currently initialised twice once to the
> arch specific callback pxav3_set_uhs_signaling, and also to the generic
> sdhci_set_uhs_signaling callback.
>
> This means that uhs is currently broken for this platform currently, as pxav3
> has some special constriants which means it can't use the generic callback.
>
> This happened in
> commit 96d7b78cfc2f ("mmc: sdhci: convert sdhci_set_uhs_signaling() into a library function")
> commit a702c8abb2a9 ("mmc: host: split up sdhci-pxa, create sdhci-pxav3.c")'
>
> Fix this and hopefully prevent it happening in the future by ensuring named
> initialisers always follow the declaration order in the structure definition.
>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

Thanks! Applied for next and added a stable tag for v3.16+

Kind regards
Uffe

> ---
>  drivers/mmc/host/sdhci-pxav3.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
> index 6f842fb..3434c79 100644
> --- a/drivers/mmc/host/sdhci-pxav3.c
> +++ b/drivers/mmc/host/sdhci-pxav3.c
> @@ -224,12 +224,11 @@ static void pxav3_set_uhs_signaling(struct sdhci_host *host, unsigned int uhs)
>
>  static const struct sdhci_ops pxav3_sdhci_ops = {
>         .set_clock = sdhci_set_clock,
> -       .set_uhs_signaling = pxav3_set_uhs_signaling,
>         .platform_send_init_74_clocks = pxav3_gen_init_74_clocks,
>         .get_max_clock = sdhci_pltfm_clk_get_max_clock,
>         .set_bus_width = sdhci_set_bus_width,
>         .reset = pxav3_reset,
> -       .set_uhs_signaling = sdhci_set_uhs_signaling,
> +       .set_uhs_signaling = pxav3_set_uhs_signaling,
>  };
>
>  static struct sdhci_pltfm_data sdhci_pxav3_pdata = {
> --
> 1.9.1
>
