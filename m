Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3EPPhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:37:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47098 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751888Ab3EPPhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:37:16 -0400
Message-ID: <1368718635.2194.55.camel@joe-AO722>
Subject: Re: [PATCH 13/33] drivers/net/ethernet/renesas: don't check
 resource with devm_ioremap_resource
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 16 May 2013 08:37:15 -0700
In-Reply-To: <1368702961-4325-14-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
	 <1368702961-4325-14-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 13:15 +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
[]
> diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
[]
> @@ -2745,11 +2745,6 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
>  	if (mdp->cd->tsu) {
>  		struct resource *rtsu;
>  		rtsu = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -		if (!rtsu) {
> -			dev_err(&pdev->dev, "Not found TSU resource\n");
> -			ret = -ENODEV;
> -			goto out_release;
> -		}
>  		mdp->tsu_addr = devm_ioremap_resource(&pdev->dev, rtsu);
>  		if (IS_ERR(mdp->tsu_addr)) {
>  			ret = PTR_ERR(mdp->tsu_addr);

I'm not sure it matters, but at least one of these
conversions will now return -EINVAL instead of -ENODEV


