Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3EMH6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:58:41 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:45170 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab3EMH6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:58:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_ETnhT-YQgyPKJJ5meTF_mibYipShRO2GPGMhpdGOuyw@mail.gmail.com>
References: <CAPgLHd_ETnhT-YQgyPKJJ5meTF_mibYipShRO2GPGMhpdGOuyw@mail.gmail.com>
Date: Mon, 13 May 2013 13:28:39 +0530
Message-ID: <CAKohponMh0-L-LAYE7Rf3frULQ3WEwJCi+Hfe9qtE+zEWtncrQ@mail.gmail.com>
Subject: Re: [PATCH] mtd: fsmc_nand: fix error return code in fsmc_nand_probe()
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

On 13 May 2013 12:25, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return -ENODEV in the dma channel request error handling
> case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mtd/nand/fsmc_nand.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
> index 911e243..6988fc8 100644
> --- a/drivers/mtd/nand/fsmc_nand.c
> +++ b/drivers/mtd/nand/fsmc_nand.c
> @@ -1032,6 +1032,7 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
>         case USE_DMA_ACCESS:
>                 dma_cap_zero(mask);
>                 dma_cap_set(DMA_MEMCPY, mask);
> +               ret = -ENODEV;
>                 host->read_dma_chan = dma_request_channel(mask, filter,
>                                 pdata->read_dma_priv);
>                 if (!host->read_dma_chan) {
>

Better do it for error cases only.. like:

>                 if (!host->read_dma_chan) {
                           ret = -ENODEV;
