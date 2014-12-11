Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841AbaLKG3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 01:29:33 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:43505 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaLKG3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 01:29:32 -0500
MIME-Version: 1.0
In-Reply-To: <1415787893-21857-1-git-send-email-gautam.vivek@samsung.com>
References: <1415787893-21857-1-git-send-email-gautam.vivek@samsung.com>
Date: Thu, 11 Dec 2014 11:59:31 +0530
Message-ID: <CAFp+6iGrv8rhGf7QkOi=2Ad+ZFPMpVn84hjNa9TiNWHFcWKLeg@mail.gmail.com>
Subject: Re: [PATCH] phy: phy-samsung-usb2: Don't use same name for driver
 name and global structure
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 3:54 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Using the same driver name for platform driver and a globally defined,
> structure used throughout the file, looks a bit unpleasing.
> So changing the driver name from "samsung_usb2_phy_driver" to
> "samsung_usb2_phy"
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Kamil Debski <k.debski@samsung.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> ---

Although just a trivial change, does it look valid ?

>  drivers/phy/phy-samsung-usb2.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
> index 908949d..2934fb7 100644
> --- a/drivers/phy/phy-samsung-usb2.c
> +++ b/drivers/phy/phy-samsung-usb2.c
> @@ -226,7 +226,7 @@ static int samsung_usb2_phy_probe(struct platform_device *pdev)
>         return 0;
>  }
>
> -static struct platform_driver samsung_usb2_phy_driver = {
> +static struct platform_driver samsung_usb2_phy = {
>         .probe  = samsung_usb2_phy_probe,
>         .driver = {
>                 .of_match_table = samsung_usb2_phy_of_match,
> @@ -234,7 +234,7 @@ static struct platform_driver samsung_usb2_phy_driver = {
>         }
>  };
>
> -module_platform_driver(samsung_usb2_phy_driver);
> +module_platform_driver(samsung_usb2_phy);
>  MODULE_DESCRIPTION("Samsung S5P/EXYNOS SoC USB PHY driver");
>  MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
>  MODULE_LICENSE("GPL v2");
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
