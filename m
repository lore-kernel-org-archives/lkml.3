Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3I0HTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 03:19:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48763 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab3I0HTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 03:19:40 -0400
Date: Fri, 27 Sep 2013 09:19:37 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH 16/27] mmc: mxcmmc: Move away from using deprecated APIs
Message-ID: <20130927071937.GJ30088@pengutronix.de>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
 <1380207292-16968-17-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380207292-16968-17-git-send-email-ulf.hansson@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:19:23 up 33 days, 16:50, 51 users,  load average: 0.05, 0.06,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 04:54:41PM +0200, Ulf Hansson wrote:
> Suspend and resume of cards are being handled from the protocol layer
> and consequently the mmc_suspend|resume_host APIs are deprecated.
> 
> This means we can simplify the suspend|resume callbacks by removing the
> use of the deprecated APIs.
> 
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Anatolij Gustschin <agust@denx.de>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/mmc/host/mxcmmc.c |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
> index c174c6a..f7199c8 100644
> --- a/drivers/mmc/host/mxcmmc.c
> +++ b/drivers/mmc/host/mxcmmc.c
> @@ -1250,28 +1250,20 @@ static int mxcmci_suspend(struct device *dev)
>  {
>  	struct mmc_host *mmc = dev_get_drvdata(dev);
>  	struct mxcmci_host *host = mmc_priv(mmc);
> -	int ret = 0;
>  
> -	if (mmc)
> -		ret = mmc_suspend_host(mmc);
>  	clk_disable_unprepare(host->clk_per);
>  	clk_disable_unprepare(host->clk_ipg);
> -
> -	return ret;
> +	return 0;
>  }
>  
>  static int mxcmci_resume(struct device *dev)
>  {
>  	struct mmc_host *mmc = dev_get_drvdata(dev);
>  	struct mxcmci_host *host = mmc_priv(mmc);
> -	int ret = 0;
>  
>  	clk_prepare_enable(host->clk_per);
>  	clk_prepare_enable(host->clk_ipg);
> -	if (mmc)
> -		ret = mmc_resume_host(mmc);
> -
> -	return ret;
> +	return 0;
>  }
>  
>  static const struct dev_pm_ops mxcmci_pm_ops = {
> -- 
> 1.7.9.5
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
