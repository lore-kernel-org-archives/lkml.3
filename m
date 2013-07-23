Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab3GWSNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:13:07 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:57369 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204Ab3GWSNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:13:04 -0400
MIME-Version: 1.0
In-Reply-To: <1374602524-3398-14-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de> <1374602524-3398-14-git-send-email-wsa@the-dreams.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 23 Jul 2013 12:12:42 -0600
Message-ID: <CAErSpo4jazaN8YahJGs+KD1-j6o8QHe2LmiQwBY9+UweBVkHxQ@mail.gmail.com>
Subject: Re: [PATCH 13/27] drivers/pci/host: don't check resource with devm_ioremap_resource
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Jingoo]

On Tue, Jul 23, 2013 at 12:01 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Jingoo, I can apply this, or if you have other pcie-designware.c
updates this cycle, you can fold it into those.  Just let me know what
you'd prefer.

Bjorn


>  drivers/pci/host/pcie-designware.c |   12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 26bdbda..f0ba6ef 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -817,28 +817,16 @@ static int add_pcie_port(struct pcie_port *pp, struct platform_device *pdev)
>         int ret;
>
>         elbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!elbi_base) {
> -               dev_err(&pdev->dev, "couldn't get elbi base resource\n");
> -               return -EINVAL;
> -       }
>         pp->elbi_base = devm_ioremap_resource(&pdev->dev, elbi_base);
>         if (IS_ERR(pp->elbi_base))
>                 return PTR_ERR(pp->elbi_base);
>
>         phy_base = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -       if (!phy_base) {
> -               dev_err(&pdev->dev, "couldn't get phy base resource\n");
> -               return -EINVAL;
> -       }
>         pp->phy_base = devm_ioremap_resource(&pdev->dev, phy_base);
>         if (IS_ERR(pp->phy_base))
>                 return PTR_ERR(pp->phy_base);
>
>         purple_base = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> -       if (!purple_base) {
> -               dev_err(&pdev->dev, "couldn't get purple base resource\n");
> -               return -EINVAL;
> -       }
>         pp->purple_base = devm_ioremap_resource(&pdev->dev, purple_base);
>         if (IS_ERR(pp->purple_base))
>                 return PTR_ERR(pp->purple_base);
> --
> 1.7.10.4
>
