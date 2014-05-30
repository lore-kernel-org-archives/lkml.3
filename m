Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaE3JfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:35:05 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:60718 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbaE3JfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:35:02 -0400
MIME-Version: 1.0
In-Reply-To: <1401284807-16686-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1401284807-16686-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Fri, 30 May 2014 11:35:01 +0200
Message-ID: <CAPDyKFraGdp2QUHzhjoe5mO6ZyuS08notgkxpRB5A_GpYtyXTw@mail.gmail.com>
Subject: Re: [PATCH v4 06/13] mmc: mmci: add ddrmode mask to variant data
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2014 15:46,  <srinivas.kandagatla@linaro.org> wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> This patch adds ddrmode mask to variant structure giving more flexibility
> to the driver to support more SOCs which have different datactrl register
> layout.
>
> Without this patch datactrl register is updated with wrong ddrmode mask on non
> ST SOCs, resulting in card detection failures.

The above statement seems not correct. We don't have any issues
currently, right. :-)

Kind regards
Ulf Hansson

>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mmc/host/mmci.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 23401b0..729105b 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -59,6 +59,7 @@ static unsigned int fmax = 515633;
>   *               is asserted (likewise for RX)
>   * @sdio: variant supports SDIO
>   * @st_clkdiv: true if using a ST-specific clock divider algorithm
> + * @datactrl_mask_ddrmode: ddr mode mask in datactrl register.
>   * @blksz_datactrl16: true if Block size is at b16..b30 position in datactrl register
>   * @blksz_datactrl4: true if Block size is at b4..b16 position in datactrl
>   *                  register
> @@ -74,6 +75,7 @@ struct variant_data {
>         unsigned int            datalength_bits;
>         unsigned int            fifosize;
>         unsigned int            fifohalfsize;
> +       unsigned int            datactrl_mask_ddrmode;
>         bool                    sdio;
>         bool                    st_clkdiv;
>         bool                    blksz_datactrl16;
> @@ -152,6 +154,7 @@ static struct variant_data variant_ux500v2 = {
>         .fifohalfsize           = 8 * 4,
>         .clkreg                 = MCI_CLK_ENABLE,
>         .clkreg_enable          = MCI_ST_UX500_HWFCEN,
> +       .datactrl_mask_ddrmode  = MCI_ST_DPSM_DDRMODE,
>         .datalength_bits        = 24,
>         .sdio                   = true,
>         .st_clkdiv              = true,
> @@ -779,7 +782,7 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
>                 }
>
>         if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50)
> -               datactrl |= MCI_ST_DPSM_DDRMODE;
> +               datactrl |= variant->datactrl_mask_ddrmode;
>
>         /*
>          * Attempt to use DMA operation mode, if this
> --
> 1.9.1
>
