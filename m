Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaH1SLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:11:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17605 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaH1SLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:11:10 -0400
X-AuditID: cbfee61a-f79e46d00000134f-d6-53ff70bbdd39
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>, Olof Johansson <olof@lixom.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: dwc3: exynos: remove usb_phy_generic support
Date: Thu, 28 Aug 2014 20:11:04 +0200
Message-id: <44042073.hjFrXas7t7@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CAFp+6iF10hSNzkVWwF2QkDLRkhKQ_STN8N8vH2eatM4qjjt7MQ@mail.gmail.com>
References: <2141307.zYQLjP6V6U@amdc1032>
 <CAFp+6iF10hSNzkVWwF2QkDLRkhKQ_STN8N8vH2eatM4qjjt7MQ@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jQd3dBf+DDa402VgcvF9v0XblILtF
	8+L1bBa9C66yWZxtesNucXnXHDaLGef3MVksWtbKbHHq+mc2iwm/L7A5cHnsn7uG3ePKiSZW
	j9l3fzB69G1Zxehx/MZ2Jo/Pm+QC2KK4bFJSczLLUov07RK4Mp7s72IuWGddsfppE2sD40+d
	LkZODgkBE4n3K+cxQdhiEhfurWfrYuTiEBKYzijx+kQ7I4TTwiTR2DKJDaSKTcBKYmL7KkYQ
	W0RAW2L73EmsIEXMAhuYJf4vvcEMkhAWcJPovn4FKMHBwSKgKrHnBAuIySugJbGhhwukQlTA
	U2LH9pVgIzkFgiUu3H7ODmILCRRIHNn3nAXE5hUQlPgx+R6YzSwgL7Fv/1RWCFtdYtK8RcwT
	GAVmISmbhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY+GZ1A7GlQ0WhxgF
	OBiVeHgd4v4FC7EmlhVX5h5ilOBgVhLhjcn5HyzEm5JYWZValB9fVJqTWnyIUZqDRUmc90Cr
	daCQQHpiSWp2ampBahFMlomDU6qBMX1Xy7MKuaYO+0tceyoqvNd/uGZqvPObwJv9PZkBdy1T
	9uy5eD2g4sjbC5aaFTc6leSyr1W68JSJrdyldtlIUiN4skehyaaKPzKM6WwzgjrEOd7sOS0r
	4btT3stgVe+GOeoXWcTXMp5Ymbrp6KuFP3j332B/ZB989IOJsEMgx8POfF+ppA3rlFiKMxIN
	tZiLihMBTnVYdIECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added Alan and Greg to cc: ]

Hi,

On Wednesday, August 27, 2014 11:42:25 PM Vivek Gautam wrote:
> Hi Baltlomiej,
> 
> 
> On Wed, Aug 27, 2014 at 1:22 PM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > dwc3 driver is using the new Exynos5 SoC series USB DRD PHY driver
> > (PHY_EXYNOS5_USBDRD which selects GENERIC_PHY) as can be seen by
> > looking at the following commits:
> >
> >   7a4cf0fde054 ("ARM: dts: Update DWC3 usb controller to use new
> >   phy driver for exynos5250")
> >
> >   f070267b5fc1 ("ARM: dts: Enable support for DWC3 controller for
> >   exynos5420")
> >
> > Thus remove unused usb_phy_generic support from dwc3 Exynos glue
> > layer.
> >
> > [ The code that is being removed is harmful in the context of
> >   multi_v7_defconfig and enabling "EHCI support for Samsung
> >   S5P/EXYNOS SoC Series" (USB_EHCI_EXYNOS) + "OHCI support for
> >   Samsung S5P/EXYNOS SoC Series" (USB_OHCI_EXYNOS) because "EHCI
> >   support for OMAP3 and later chips" (USB_EHCI_HCD_OMAP) selects
> >   "NOP USB Transceiver Driver" (NOP_USB_XCEIV).  NOP USB driver
> >   attaches itself to usb_phy_generic platform devices created by
> >   dwc3 Exynos glue layer and later causes Exynos EHCI driver to
> >   fail probe and Exynos OHCI driver to hang on probe (as observed
> >   on Exynos5250 Arndale board). ]
> 
> The issue with EHCI and OHCI on exynos platforms is that until now
> they also request
> usb-phy and only later if they don't find one, they go ahead and get a
> 'phy' generic.
> 
> Fortunately we missed this issue with exynos_defconfig, and as you rightly
> mentioned with multi_v7_defconfig, the NOP_USB_XCEIV gets enabled and
> EHCI and OHCI exynos get no-op usb-phy, which actually blocks EHCI/OHCI from
> initializing the real PHYs.
> 
> This issue is resolved with patches:
> [PATCH v2 1/2] usb: host: ehci-exynos: Remove unnecessary usb-phy support
> [PATCH v2 2/2] usb: host: ohci-exynos: Remove unnecessary usb-phy support
> wherein we are completely removing the usb-phy support from ehci/ohci-exynos.
> So with these patches we should not see the issue mentioned by you.

Indeed, your patches fix the issue.

Greg, could these two patches ([1] & [2]) get merged quickly, pretty please
(they were already acked by Alan)?  They are not a mere cleanups because
they fix the actual problem with using multi_v7_defconfig which in turn has
been blocking Olof's defconfig update patch [3] for quite some time now.
Moreover these patches are limited to Exynos host drivers so they should be
pretty safe when it comes to potential regressions.

[1] http://www.spinics.net/lists/linux-usb/msg112294.html
[2] http://www.spinics.net/lists/linux-usb/msg112293.html
[3] http://www.spinics.net/lists/arm-kernel/msg349654.html

> Now for the DWC3 part, the usb-phy part was added to use register two
> separate no-op-xceivers of USB2_PHY type and USB3_PHY type,
> so that platforms with no separate PHY can still be able to use dwc3.

Is such support actually useful for Exynos platforms (it resides in
dwc3-exynos.c)?  I think that all DWC3 Exynos users need corresponding
USB PHY support, no?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > Cc: Olof Johansson <olof@lixom.net>
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > Cc: Vivek Gautam <gautam.vivek@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > ---
> >  drivers/usb/dwc3/dwc3-exynos.c |   68 -----------------------------------------
> >  1 file changed, 1 insertion(+), 67 deletions(-)
> >
> > Index: b/drivers/usb/dwc3/dwc3-exynos.c
> > ===================================================================
> > --- a/drivers/usb/dwc3/dwc3-exynos.c    2014-08-25 14:57:04.991781925 +0200
> > +++ b/drivers/usb/dwc3/dwc3-exynos.c    2014-08-27 09:16:38.312617727 +0200
> > @@ -23,15 +23,12 @@
> >  #include <linux/platform_data/dwc3-exynos.h>
> >  #include <linux/dma-mapping.h>
> >  #include <linux/clk.h>
> > -#include <linux/usb/otg.h>
> > -#include <linux/usb/usb_phy_generic.h>
> > +#include <linux/pm_runtime.h>
> >  #include <linux/of.h>
> >  #include <linux/of_platform.h>
> >  #include <linux/regulator/consumer.h>
> >
> >  struct dwc3_exynos {
> > -       struct platform_device  *usb2_phy;
> > -       struct platform_device  *usb3_phy;
> >         struct device           *dev;
> >
> >         struct clk              *clk;
> > @@ -39,61 +36,6 @@ struct dwc3_exynos {
> >         struct regulator        *vdd10;
> >  };
> >
> > -static int dwc3_exynos_register_phys(struct dwc3_exynos *exynos)
> > -{
> > -       struct usb_phy_generic_platform_data pdata;
> > -       struct platform_device  *pdev;
> > -       int                     ret;
> > -
> > -       memset(&pdata, 0x00, sizeof(pdata));
> > -
> > -       pdev = platform_device_alloc("usb_phy_generic", PLATFORM_DEVID_AUTO);
> > -       if (!pdev)
> > -               return -ENOMEM;
> > -
> > -       exynos->usb2_phy = pdev;
> > -       pdata.type = USB_PHY_TYPE_USB2;
> > -       pdata.gpio_reset = -1;
> > -
> > -       ret = platform_device_add_data(exynos->usb2_phy, &pdata, sizeof(pdata));
> > -       if (ret)
> > -               goto err1;
> > -
> > -       pdev = platform_device_alloc("usb_phy_generic", PLATFORM_DEVID_AUTO);
> > -       if (!pdev) {
> > -               ret = -ENOMEM;
> > -               goto err1;
> > -       }
> > -
> > -       exynos->usb3_phy = pdev;
> > -       pdata.type = USB_PHY_TYPE_USB3;
> > -
> > -       ret = platform_device_add_data(exynos->usb3_phy, &pdata, sizeof(pdata));
> > -       if (ret)
> > -               goto err2;
> > -
> > -       ret = platform_device_add(exynos->usb2_phy);
> > -       if (ret)
> > -               goto err2;
> > -
> > -       ret = platform_device_add(exynos->usb3_phy);
> > -       if (ret)
> > -               goto err3;
> > -
> > -       return 0;
> > -
> > -err3:
> > -       platform_device_del(exynos->usb2_phy);
> > -
> > -err2:
> > -       platform_device_put(exynos->usb3_phy);
> > -
> > -err1:
> > -       platform_device_put(exynos->usb2_phy);
> > -
> > -       return ret;
> > -}
> > -
> >  static int dwc3_exynos_remove_child(struct device *dev, void *unused)
> >  {
> >         struct platform_device *pdev = to_platform_device(dev);
> > @@ -127,12 +69,6 @@ static int dwc3_exynos_probe(struct plat
> >
> >         platform_set_drvdata(pdev, exynos);
> >
> > -       ret = dwc3_exynos_register_phys(exynos);
> > -       if (ret) {
> > -               dev_err(dev, "couldn't register PHYs\n");
> > -               return ret;
> > -       }
> > -
> >         clk = devm_clk_get(dev, "usbdrd30");
> >         if (IS_ERR(clk)) {
> >                 dev_err(dev, "couldn't get clock\n");
> > @@ -194,8 +130,6 @@ static int dwc3_exynos_remove(struct pla
> >         struct dwc3_exynos      *exynos = platform_get_drvdata(pdev);
> >
> >         device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
> > -       platform_device_unregister(exynos->usb2_phy);
> > -       platform_device_unregister(exynos->usb3_phy);
> >
> >         clk_disable_unprepare(exynos->clk);
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

