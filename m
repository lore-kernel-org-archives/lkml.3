Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab3ELRXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 13:23:47 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:46218 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754568Ab3ELRXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 13:23:46 -0400
Date: Sun, 12 May 2013 19:23:44 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [RFC 36/42] drivers/watchdog: don't check resource with devm_ioremap_resource
Message-ID: <20130512172344.GX14155@spo001.leaseweb.com>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de> <1368173847-5661-37-git-send-email-wsa@the-dreams.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368173847-5661-37-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Wim Van Sebroeck <wim@iguana.be>


> ---
>  drivers/watchdog/imx2_wdt.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> index ff90882..62946c2 100644
> --- a/drivers/watchdog/imx2_wdt.c
> +++ b/drivers/watchdog/imx2_wdt.c
> @@ -257,11 +257,6 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
>  	struct resource *res;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "can't get device resources\n");
> -		return -ENODEV;
> -	}
> -
>  	imx2_wdt.base = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(imx2_wdt.base))
>  		return PTR_ERR(imx2_wdt.base);

Kind regards,
Wim.

