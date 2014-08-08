Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbaHHPhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:37:47 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:36890 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaHHPhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:37:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: sdhci-pxav3: Remove unused variable in sdhci_pxav3_remove()
Date: Fri, 08 Aug 2014 17:38:19 +0200
Message-ID: <6429061.3nhKdDRquU@avalon>
User-Agent: KMail/4.11.5 (Linux/3.14.14-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1407511931-26712-1-git-send-email-geert+renesas@glider.be>
References: <1407511931-26712-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch, but you're a bit too late :-)

http://article.gmane.org/gmane.linux.kernel.mmc/28097

On Friday 08 August 2014 17:32:11 Geert Uytterhoeven wrote:
> Commit 8f69e585ca3ad324ea57e113bff06d366dfa010e ("mmc: sdhci-pxav3: Use
> devm_* managed helpers") removed the later user of pxa:
> 
> drivers/mmc/host/sdhci-pxav3.c: In function 'sdhci_pxav3_remove':
> drivers/mmc/host/sdhci-pxav3.c:400:20: warning: unused variable 'pxa'
> [-Wunused-variable] struct sdhci_pxa *pxa = pltfm_host->priv;
>                     ^
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/mmc/host/sdhci-pxav3.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
> index 527dfa3faeab..6f842fb8e6b8 100644
> --- a/drivers/mmc/host/sdhci-pxav3.c
> +++ b/drivers/mmc/host/sdhci-pxav3.c
> @@ -397,7 +397,6 @@ static int sdhci_pxav3_remove(struct platform_device
> *pdev) {
>  	struct sdhci_host *host = platform_get_drvdata(pdev);
>  	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> -	struct sdhci_pxa *pxa = pltfm_host->priv;
> 
>  	pm_runtime_get_sync(&pdev->dev);
>  	sdhci_remove_host(host, 1);

-- 
Regards,

Laurent Pinchart

