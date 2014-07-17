Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbaGQMNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:13:48 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:64748 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaGQMNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:13:42 -0400
MIME-Version: 1.0
In-Reply-To: <1405596587.916424959@apps.rackspace.com>
References: <1405596587.916424959@apps.rackspace.com>
Date: Thu, 17 Jul 2014 17:43:38 +0530
Message-ID: <CABu_nUQTCr+wGOEEoEJvWf=iFmtA7zu8Y_wvMqQ=GG0Ff+tOmg@mail.gmail.com>
Subject: Re: FW: Fwd: [PATCH v6 08/12] mmc: mmci: Add support to data commands
 via variant structure.
From: Prakash Burla <burlaprakash.linuxkernel@gmail.com>
To: srinivas.kandagatla@linaro.org
Cc: linux@arm.linux.org.uk, ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        chris@printf.net, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tested-by: Prakash Burla <prakash.burla@smartplayin.com
This driver is tested on IFC6410.

> From:  <srinivas.kandagatla@linaro.org>
> Date: Mon, Jun 2, 2014 at 2:39 PM
> Subject: [PATCH v6 08/12] mmc: mmci: Add support to data commands via
> variant structure.
> To: Russell King <linux@arm.linux.org.uk>, Ulf Hansson
> <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
> Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
> linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org, Srinivas
> Kandagatla <srinivas.kandagatla@linaro.org>
>
>
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> On some SOCs like Qcom there are explicit bits in the command register
> to specify if its a data transfer command or not. So this patch adds
> support to such bits in variant data, giving more flexibility to the
> driver.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mmc/host/mmci.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 4c95a9b..8534c29 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -59,6 +59,7 @@ static unsigned int fmax = 515633;
>   *           is asserted (likewise for RX)
>   * @fifohalfsize: number of bytes that can be written when MCI_TXFIFOHALFEMPTY
>   *               is asserted (likewise for RX)
> + * @data_cmd_enable: enable value for data commands.
>   * @sdio: variant supports SDIO
>   * @st_clkdiv: true if using a ST-specific clock divider algorithm
>   * @datactrl_mask_ddrmode: ddr mode mask in datactrl register.
> @@ -79,6 +80,7 @@ struct variant_data {
>         unsigned int            datalength_bits;
>         unsigned int            fifosize;
>         unsigned int            fifohalfsize;
> +       unsigned int            data_cmd_enable;
>         unsigned int            datactrl_mask_ddrmode;
>         bool                    sdio;
>         bool                    st_clkdiv;
> @@ -839,6 +841,9 @@ mmci_start_command(struct mmci_host *host, struct
> mmc_command *cmd, u32 c)
>         if (/*interrupt*/0)
>                 c |= MCI_CPSM_INTERRUPT;
>
> +       if (mmc_cmd_type(cmd) == MMC_CMD_ADTC)
> +               c |= host->variant->data_cmd_enable;
> +
>         host->cmd = cmd;
>
>         writel(cmd->arg, base + MMCIARGUMENT);
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
