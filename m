Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbbAZLMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:12:09 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:27751 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbbAZLME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:12:04 -0500
Message-ID: <54C620F6.7010008@atmel.com>
Date: Mon, 26 Jan 2015 12:11:50 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <monstr@monstr.eu>
CC: <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: macb: Remove CONFIG_PM ifdef because of compilation
 warning
References: <7970145ad4d864eaf31d694d22f2fecbcf6825c9.1422002161.git.michal.simek@xilinx.com>
In-Reply-To: <7970145ad4d864eaf31d694d22f2fecbcf6825c9.1422002161.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 23/01/2015 09:36, Michal Simek a écrit :
> Fix compilation warning:
> drivers/net/ethernet/cadence/macb.c:2415:12: warning: 'macb_suspend'
> defined but not used [-Wunused-function]
>  static int macb_suspend(struct device *dev)
> drivers/net/ethernet/cadence/macb.c:2432:12: warning: 'macb_resume'
> defined but not used [-Wunused-function]
>  static int macb_resume(struct device *dev)
> 
> when CONFIG_PM=y, CONFIG_PM_SLEEP=n are used.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

okay:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> 
>  drivers/net/ethernet/cadence/macb.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index 3767271c7667..23ae32f118c2 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -2411,8 +2411,7 @@ static int __exit macb_remove(struct platform_device *pdev)
>  	return 0;
>  }
> 
> -#ifdef CONFIG_PM
> -static int macb_suspend(struct device *dev)
> +static int __maybe_unused macb_suspend(struct device *dev)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
>  	struct net_device *netdev = platform_get_drvdata(pdev);
> @@ -2429,7 +2428,7 @@ static int macb_suspend(struct device *dev)
>  	return 0;
>  }
> 
> -static int macb_resume(struct device *dev)
> +static int __maybe_unused macb_resume(struct device *dev)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
>  	struct net_device *netdev = platform_get_drvdata(pdev);
> @@ -2444,7 +2443,6 @@ static int macb_resume(struct device *dev)
> 
>  	return 0;
>  }
> -#endif
> 
>  static SIMPLE_DEV_PM_OPS(macb_pm_ops, macb_suspend, macb_resume);
> 
> --
> 1.8.2.3
> 


-- 
Nicolas Ferre
