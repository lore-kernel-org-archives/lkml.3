Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbaE3K2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:28:36 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:49201 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaE3K2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:28:34 -0400
MIME-Version: 1.0
In-Reply-To: <1401284862-16894-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1401284862-16894-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Fri, 30 May 2014 12:28:33 +0200
Message-ID: <CAPDyKFoURODuKS6NB4hN=iW=22S0x+ZiJWYz_UXW0Rc+0pW2Nw@mail.gmail.com>
Subject: Re: [PATCH v4 11/13] mmc: mmci: add f_max to variant structure
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

On 28 May 2014 15:47,  <srinivas.kandagatla@linaro.org> wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> Some of the controller have maximum supported frequency, This patch adds
> support in variant data structure to specify such restrictions. This
> gives more flexibility in calculating the f_max before passing it to
> mmc-core.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>  drivers/mmc/host/mmci.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index fd40f9a..202f2d5 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -67,6 +67,7 @@ static unsigned int fmax = 515633;
>   * @blksz_datactrl4: true if Block size is at b4..b16 position in datactrl
>   *                  register
>   * @pwrreg_powerup: power up value for MMCIPOWER register
> + * @f_max: maximum clk frequency supported by the controller.
>   * @signal_direction: input/out direction of bus signals can be indicated
>   * @pwrreg_clkgate: MMCIPOWER register must be used to gate the clock
>   * @busy_detect: true if busy detection on dat0 is supported
> @@ -87,6 +88,7 @@ struct variant_data {
>         bool                    blksz_datactrl16;
>         bool                    blksz_datactrl4;
>         u32                     pwrreg_powerup;
> +       u32                     f_max;
>         bool                    signal_direction;
>         bool                    pwrreg_clkgate;
>         bool                    busy_detect;
> @@ -98,6 +100,7 @@ static struct variant_data variant_arm = {
>         .fifohalfsize           = 8 * 4,
>         .datalength_bits        = 16,
>         .pwrreg_powerup         = MCI_PWR_UP,
> +       .f_max                  = 100000000,
>  };
>
>  static struct variant_data variant_arm_extended_fifo = {
> @@ -105,6 +108,7 @@ static struct variant_data variant_arm_extended_fifo = {
>         .fifohalfsize           = 64 * 4,
>         .datalength_bits        = 16,
>         .pwrreg_powerup         = MCI_PWR_UP,
> +       .f_max                  = 100000000,
>  };
>
>  static struct variant_data variant_arm_extended_fifo_hwfc = {
> @@ -113,6 +117,7 @@ static struct variant_data variant_arm_extended_fifo_hwfc = {
>         .clkreg_enable          = MCI_ARM_HWFCEN,
>         .datalength_bits        = 16,
>         .pwrreg_powerup         = MCI_PWR_UP,
> +       .f_max                  = 100000000,
>  };
>
>  static struct variant_data variant_u300 = {
> @@ -123,6 +128,7 @@ static struct variant_data variant_u300 = {
>         .datalength_bits        = 16,
>         .sdio                   = true,
>         .pwrreg_powerup         = MCI_PWR_ON,
> +       .f_max                  = 100000000,
>         .signal_direction       = true,
>         .pwrreg_clkgate         = true,
>         .pwrreg_nopower         = true,
> @@ -136,6 +142,7 @@ static struct variant_data variant_nomadik = {
>         .sdio                   = true,
>         .st_clkdiv              = true,
>         .pwrreg_powerup         = MCI_PWR_ON,
> +       .f_max                  = 100000000,
>         .signal_direction       = true,
>         .pwrreg_clkgate         = true,
>         .pwrreg_nopower         = true,
> @@ -152,6 +159,7 @@ static struct variant_data variant_ux500 = {
>         .sdio                   = true,
>         .st_clkdiv              = true,
>         .pwrreg_powerup         = MCI_PWR_ON,
> +       .f_max                  = 100000000,
>         .signal_direction       = true,
>         .pwrreg_clkgate         = true,
>         .busy_detect            = true,
> @@ -171,6 +179,7 @@ static struct variant_data variant_ux500v2 = {
>         .st_clkdiv              = true,
>         .blksz_datactrl16       = true,
>         .pwrreg_powerup         = MCI_PWR_ON,
> +       .f_max                  = 100000000,
>         .signal_direction       = true,
>         .pwrreg_clkgate         = true,
>         .busy_detect            = true,
> @@ -189,6 +198,7 @@ static struct variant_data variant_qcom = {
>         .blksz_datactrl4        = true,
>         .datalength_bits        = 24,
>         .pwrreg_powerup         = MCI_PWR_UP,
> +       .f_max                  = 208000000,
>  };
>
>  static int mmci_card_busy(struct mmc_host *mmc)
> @@ -1485,8 +1495,8 @@ static int mmci_probe(struct amba_device *dev,
>          * so we try to adjust the clock down to this,
>          * (if possible).
>          */
> -       if (host->mclk > 100000000) {
> -               ret = clk_set_rate(host->clk, 100000000);
> +       if (host->mclk > host->variant->f_max) {

You can use the local variant pointer directly, instead of host->variant.

> +               ret = clk_set_rate(host->clk, host->variant->f_max);
>                 if (ret < 0)
>                         goto clk_disable;
>                 host->mclk = clk_get_rate(host->clk);
> --
> 1.9.1
>

Looks good otherwise!

Kind regards
Ulf Hansson
