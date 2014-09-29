Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaI2IxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:53:02 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42645 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbaI2Iw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:52:59 -0400
Message-ID: <54291E30.6040503@ti.com>
Date: Mon, 29 Sep 2014 11:54:08 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <mturquette@linaro.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: ti: dra7-atl-clock: Mark the device as pm_runtime_irq_safe
References: <1411978233-25139-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1411978233-25139-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 11:10 AM, Peter Ujfalusi wrote:
> It is safe to call the pm sync calls in interrupt context in this driver.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Thanks, applied to for-v3.18/ti-clk-drv.

-Tero

> ---
>   drivers/clk/ti/clk-dra7-atl.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
> index af29359677da..f18d149acd65 100644
> --- a/drivers/clk/ti/clk-dra7-atl.c
> +++ b/drivers/clk/ti/clk-dra7-atl.c
> @@ -228,6 +228,7 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
>   	cinfo->iobase = of_iomap(node, 0);
>   	cinfo->dev = &pdev->dev;
>   	pm_runtime_enable(cinfo->dev);
> +	pm_runtime_irq_safe(cinfo->dev);
>
>   	pm_runtime_get_sync(cinfo->dev);
>   	atl_write(cinfo, DRA7_ATL_PCLKMUX_REG(0), DRA7_ATL_PCLKMUX);
>

