Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab3KJQqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:46:14 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56533 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab3KJQqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:46:12 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org
Subject: Re: [PATCH v3 3/3] usb: s3c-hsotg: Use the new Exynos USB phy driver with the generic phy framework
Date: Sun, 10 Nov 2013 17:46:10 +0100
Message-ID: <3111070.aXvW5a8oaK@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1383668001-19141-4-git-send-email-k.debski@samsung.com>
References: <1383668001-19141-1-git-send-email-k.debski@samsung.com> <1383668001-19141-4-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamil,

This patch is changing a DT binding, but you haven't updated relevant
documentation. Please remember about it in next version.

On Tuesday 05 of November 2013 17:13:21 Kamil Debski wrote:
> Change the used phy driver to the new Exynos USB phy driver that uses the
> generic phy framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/usb/gadget/s3c-hsotg.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
> index bb31262..dc7f20c 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -31,6 +31,7 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> +#include <linux/phy/phy.h>
>  
>  #include <linux/usb/ch9.h>
>  #include <linux/usb/gadget.h>
> @@ -162,7 +163,7 @@ struct s3c_hsotg_ep {
>  struct s3c_hsotg {
>  	struct device		 *dev;
>  	struct usb_gadget_driver *driver;
> -	struct usb_phy		*phy;
> +	struct phy		 *phy;
>  	struct s3c_hsotg_plat	 *plat;
>  
>  	spinlock_t              lock;
> @@ -2905,9 +2906,10 @@ static void s3c_hsotg_phy_enable(struct s3c_hsotg *hsotg)
>  	dev_dbg(hsotg->dev, "pdev 0x%p\n", pdev);
>  
>  	if (hsotg->phy)
> -		usb_phy_init(hsotg->phy);
> +		phy_power_on(hsotg->phy);
>  	else if (hsotg->plat->phy_init)
>  		hsotg->plat->phy_init(pdev, hsotg->plat->phy_type);
> +

nit: Stray blank line.

Best regards,
Tomasz

