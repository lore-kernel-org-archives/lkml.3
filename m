Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaBRUKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:10:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaBRUK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:10:28 -0500
Date: Tue, 18 Feb 2014 12:11:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] usb: phy: bcm-kona-usb2: Use PTR_ERR_OR_ZERO
Message-ID: <20140218201153.GC21119@kroah.com>
References: <1392627565-1829-1-git-send-email-kishon@ti.com>
 <1392627565-1829-4-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392627565-1829-4-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 02:29:20PM +0530, Kishon Vijay Abraham I wrote:
> From: Sachin Kamat <sachin.kamat@linaro.org>
> 
> PTR_ERR_OR_ZERO simplifies the code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Matt Porter <mporter@linaro.org>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/phy-bcm-kona-usb2.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/phy/phy-bcm-kona-usb2.c b/drivers/phy/phy-bcm-kona-usb2.c
> index efc5c1a..e94f5a6 100644
> --- a/drivers/phy/phy-bcm-kona-usb2.c
> +++ b/drivers/phy/phy-bcm-kona-usb2.c
> @@ -128,10 +128,8 @@ static int bcm_kona_usb2_probe(struct platform_device *pdev)
>  
>  	phy_provider = devm_of_phy_provider_register(dev,
>  			of_phy_simple_xlate);
> -	if (IS_ERR(phy_provider))
> -		return PTR_ERR(phy_provider);
>  
> -	return 0;
> +	return PTR_ERR_OR_ZERO(phy_provider);
>  }

Another patch here that isn't a bugfix, sorry, it's not for 3.14-final.
