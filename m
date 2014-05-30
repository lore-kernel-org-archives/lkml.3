Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbaE3INM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:13:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbaE3INI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:13:08 -0400
Message-ID: <53883D8E.10009@redhat.com>
Date: Fri, 30 May 2014 10:13:02 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org
CC: kishon@ti.com, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 3/3] phy: sun4i-usb: Use PTR_ERR_OR_ZERO
References: <1401345049-14779-1-git-send-email-sachin.kamat@linaro.org> <1401345049-14779-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1401345049-14779-3-git-send-email-sachin.kamat@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/29/2014 08:30 AM, Sachin Kamat wrote:
> PTR_ERR_OR_ZERO simplifies the code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/phy/phy-sun4i-usb.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
> index 115d8d5190d5..7a4ea552f621 100644
> --- a/drivers/phy/phy-sun4i-usb.c
> +++ b/drivers/phy/phy-sun4i-usb.c
> @@ -22,6 +22,7 @@
>   */
>  
>  #include <linux/clk.h>
> +#include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> @@ -306,10 +307,8 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
>  
>  	dev_set_drvdata(dev, data);
>  	phy_provider = devm_of_phy_provider_register(dev, sun4i_usb_phy_xlate);
> -	if (IS_ERR(phy_provider))
> -		return PTR_ERR(phy_provider);
>  
> -	return 0;
> +	return PTR_ERR_OR_ZERO(phy_provider);
>  }
>  
>  static const struct of_device_id sun4i_usb_phy_of_match[] = {
> 


Looks good:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans
