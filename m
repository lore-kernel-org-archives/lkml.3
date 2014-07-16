Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbaGPJxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:53:22 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:57188 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283AbaGPJxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:53:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Xiang Wang <wangxfdu@gmail.com>, Xiang Wang <wangx@marvell.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Marcin Wojtas <mw@semihalf.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Xie <cxie4@marvell.com>
Subject: Re: [PATCH] mmc: sdhci-pxav3: fix error handling of sdhci_add_host
Date: Wed, 16 Jul 2014 11:53:21 +0200
Message-ID: <5513748.05vsM1lCJN@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405497009-20338-1-git-send-email-wangxfdu@gmail.com>
References: <1405497009-20338-1-git-send-email-wangxfdu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xiang,

Thank you for the patch.

On Wednesday 16 July 2014 15:50:09 Xiang Wang wrote:
> From: Xiang Wang <wangx@marvell.com>
> 
> Commit 0dcaa2499b7d111bd70da5b0976c34210c850fb3 improved error
> handling of sdhci_add_host. However, "err_of_parse" and "err_cd_req"
> should be placed after "pm_runtime_disable(&pdev->dev)".
> 
> Signed-off-by: Xiang Wang <wangx@marvell.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

While we're touching the probe error path, how about converting the driver to 
the devm_* helpers ? I'll send a patch shortly.

> ---
>  drivers/mmc/host/sdhci-pxav3.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
> index 2fd73b3..0644655 100644
> --- a/drivers/mmc/host/sdhci-pxav3.c
> +++ b/drivers/mmc/host/sdhci-pxav3.c
> @@ -380,11 +380,11 @@ static int sdhci_pxav3_probe(struct platform_device
> *pdev)
> 
>  	return 0;
> 
> -err_of_parse:
> -err_cd_req:
>  err_add_host:
>  	pm_runtime_put_sync(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
> +err_of_parse:
> +err_cd_req:
>  	clk_disable_unprepare(clk);
>  	clk_put(clk);
>  err_clk_get:

-- 
Regards,

Laurent Pinchart

