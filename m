Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034Ab3ENEAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 00:00:17 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:53315 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3ENEAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 00:00:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_DjX-Bfdf9p6k2t_fy+SjgQanuJjX_WxA1tqewwRe1HA@mail.gmail.com>
References: <CAPgLHd_DjX-Bfdf9p6k2t_fy+SjgQanuJjX_WxA1tqewwRe1HA@mail.gmail.com>
Date: Tue, 14 May 2013 09:30:14 +0530
Message-ID: <CAKohponqCJ_FvAM-FKEnKP6E8hVr-pGOm1AKZWrrF7n=aOoYww@mail.gmail.com>
Subject: Re: [PATCH v2] mtd: fsmc_nand: fix error return code in fsmc_nand_probe()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: dwmw2@infradead.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        artem.bityutskiy@linux.intel.com, linus.walleij@linaro.org,
        vipin.kumar@st.com, yongjun_wei@trendmicro.com.cn,
        linux-mtd@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 May 2013 08:00, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return -ENODEV in the dma channel request error handling
> case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
> v1 -> v2: set ret for error cases only
> ---
>  drivers/mtd/nand/fsmc_nand.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
> index 0e5a1d9..95e1768 100644
> --- a/drivers/mtd/nand/fsmc_nand.c
> +++ b/drivers/mtd/nand/fsmc_nand.c
> @@ -1035,12 +1035,14 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
>                 host->read_dma_chan = dma_request_channel(mask, filter,
>                                 pdata->read_dma_priv);
>                 if (!host->read_dma_chan) {
> +                       ret = -ENODEV;
>                         dev_err(&pdev->dev, "Unable to get read dma channel\n");
>                         goto err_req_read_chnl;
>                 }
>                 host->write_dma_chan = dma_request_channel(mask, filter,
>                                 pdata->write_dma_priv);
>                 if (!host->write_dma_chan) {
> +                       ret = -ENODEV;
>                         dev_err(&pdev->dev, "Unable to get write dma channel\n");
>                         goto err_req_write_chnl;
>                 }
>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
