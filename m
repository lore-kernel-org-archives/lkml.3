Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbaJ1Jt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:49:29 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:35255 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaJ1Jt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:49:26 -0400
MIME-Version: 1.0
In-Reply-To: <1414482801-3773-2-git-send-email-mike.looijmans@topic.nl>
References: <CAPDyKFpuiPqZ+5h-SS2-7XeVVh4J2v3SQr=RtjaTZw=0=bXABw@mail.gmail.com>
	<1414482801-3773-1-git-send-email-mike.looijmans@topic.nl>
	<1414482801-3773-2-git-send-email-mike.looijmans@topic.nl>
Date: Tue, 28 Oct 2014 10:49:25 +0100
Message-ID: <CAPDyKFrOCV4EWmVpGfNR9ggST0BJTh95de0aU_Y4TtgC0Er+Xw@mail.gmail.com>
Subject: Re: [PATCH] mmc/host/sdhci-of-arasan.c: Omit superfluous error messages
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>, Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 October 2014 08:53, Mike Looijmans <mike.looijmans@topic.nl> wrote:
> sdhci_add_host and sdhci_platfm_init already report failure,
> so don't emit error messages when a failure occurs. This prevents
> occurences of "deferred" messages when required power supplies
> are not ready for operation yet.
>
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>

Thanks! Applied for next.

Kind regards
Uffe

> ---
>  drivers/mmc/host/sdhci-of-arasan.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
> index 7ac6718..75bea2e 100644
> --- a/drivers/mmc/host/sdhci-of-arasan.c
> +++ b/drivers/mmc/host/sdhci-of-arasan.c
> @@ -161,7 +161,6 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
>         host = sdhci_pltfm_init(pdev, &sdhci_arasan_pdata, 0);
>         if (IS_ERR(host)) {
>                 ret = PTR_ERR(host);
> -               dev_err(&pdev->dev, "platform init failed (%d)\n", ret);
>                 goto clk_disable_all;
>         }
>
> @@ -171,10 +170,8 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
>         pltfm_host->clk = clk_xin;
>
>         ret = sdhci_add_host(host);
> -       if (ret) {
> -               dev_err(&pdev->dev, "platform register failed (%d)\n", ret);
> +       if (ret)
>                 goto err_pltfm_free;
> -       }
>
>         return 0;
>
> --
> 1.7.9.5
>
