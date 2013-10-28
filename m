Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab3J1NxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:53:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43634 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab3J1NxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:53:06 -0400
Date: Mon, 28 Oct 2013 14:53:03 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH 4/5] usb: ehci-s5p: Change to use phy provided by the
 generic phy framework
In-reply-to: <CAFp+6iExOPunF=ND7_17PZXA217K_4im4ZJvR=mW2Ym_gnA0GQ@mail.gmail.com>
To: "'Vivek Gautam'" <gautamvivek1987@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-arm@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'kishon'" <kishon@ti.com>, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>, mat.krawczuk@gmail.com
Message-id: <025f01ced3e5$0660ecf0$1322c6d0$%debski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7bit
Thread-index: Ac7SL5EZvzozi34CS36WUBZRHNwj0gBtF2bA
X-AuditID: cbfec7f5-b7ef66d00000795a-e7-526e6c4026a7
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xa7oOOXlBBstb9S3mHznHatF25SC7
	xdvvW9gtLjztYbM42/SG3WLazv+sFpd3zWGzmHF+H5PFomWtzBZrj9xltzjbf5vN4vCbdlaL
	9TNeszjweuycdZfdo2/LKkaP4ze2M3l83iQXwBLFZZOSmpNZllqkb5fAldE6ZQJTwQ3digc/
	3rM1MC5T6GLk4JAQMJE4McOqi5ETyBSTuHBvPVsXIxeHkMBSRokNy6YxQzgNTBI7li1jBGlg
	E9CUWHXPA6RBREBPYlrzPEaQGmaBQ8wSvy9NYYRoOMYosedfCwtIFadAsETD81dsILawQKLE
	kZmrmUFsFgFVif6ufewgNq+Ag8TD3q9sELagxI/J98B6mQW0JNbvPM4EYctLbF7zlhnianWJ
	R391IY4wkrh1DGIMs4CIxN2G56wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGppckFxUnqukV5x
	Ym5xaV66XnJ+7iZGSHx93cG49JjVIUYBDkYlHt4Na3ODhFgTy4orcw8xSnAwK4nwTo3LCxLi
	TUmsrEotyo8vKs1JLT7EyMTBKdXAeGZ9WM73sv2l7+S/pdo/+f406ue1yWZv83cadK2dapn7
	Vn2nWe3PGNdHUwzCV1W4e6kunXQj/9u9lssdgjaOnfwmx/7dn7Re+l9ypP3KlTWnz/84dLQp
	+OJDOU/x6+abdx+Vn8npEt6/6EtFw9O15afSL7zZ82t1wqn/dvk98no3byya+GdqZ6ASS3FG
	oqEWc1FxIgDtyYwwjQIAAA==
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
 <1382710529-12082-5-git-send-email-k.debski@samsung.com>
 <CAFp+6iExOPunF=ND7_17PZXA217K_4im4ZJvR=mW2Ym_gnA0GQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

> From: Vivek Gautam [mailto:gautamvivek1987@gmail.com]
> Sent: Saturday, October 26, 2013 11:41 AM
> 
> Hi Kamil,
> 
> 
> On Fri, Oct 25, 2013 at 7:45 PM, Kamil Debski <k.debski@samsung.com>
> wrote:
> > Change the phy provider used from the old usb phy specific to a new
> > one using the generic phy framework.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/usb/host/ehci-s5p.c |   21 +++++++++++----------
> >  1 file changed, 11 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-
> s5p.c
> > index 7cc26e6..76606ff 100644
> > --- a/drivers/usb/host/ehci-s5p.c
> > +++ b/drivers/usb/host/ehci-s5p.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/of_gpio.h>
> > +#include <linux/phy/phy.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/platform_data/usb-ehci-s5p.h>
> >  #include <linux/usb/phy.h>
> > @@ -45,7 +46,7 @@ static struct hc_driver __read_mostly
> > s5p_ehci_hc_driver;
> >
> >  struct s5p_ehci_hcd {
> >         struct clk *clk;
> > -       struct usb_phy *phy;
> > +       struct phy *phy;
> >         struct usb_otg *otg;
> >         struct s5p_ehci_platdata *pdata;  }; @@ -77,10 +78,11 @@
> > static int s5p_ehci_probe(struct platform_device *pdev)  {
> >         struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
> >         struct s5p_ehci_hcd *s5p_ehci;
> > +       struct phy *phy;
> 
> just a nit here:
> Lets keep the pointer to 'phy' and 'phy_name' together ?
> and move this above phy_name ?

Thanks for pointing this out.
 
> >         struct usb_hcd *hcd;
> >         struct ehci_hcd *ehci;
> >         struct resource *res;
> > -       struct usb_phy *phy;
> > +       const char *phy_name;
> >         int irq;
> >         int err;
> >
> > @@ -103,14 +105,14 @@ static int s5p_ehci_probe(struct
> platform_device *pdev)
> >                 return -ENOMEM;
> >         }
> >         s5p_ehci = to_s5p_ehci(hcd);
> > -
> > +       phy_name = of_get_property(pdev->dev.of_node, "phy-names",
> NULL);
> > +       phy =  devm_phy_get(&pdev->dev, phy_name);
> 
> Below check for exynos5440 was supposed to skip any request phy.
> So shouldn't we place above two assignments to the original place where
> devm_usb_get_phy() was called ?
> May be i am not getting you intention of changing the place.

Hm... You are right - if we want to leave this check and skip phy request
for
5450 then I should leave the order as it was. And if we want to use the new
phy driver for 5450 then the check to skip phy requesting should be simply
removed.

> 
> >         if (of_device_is_compatible(pdev->dev.of_node,
> >                                         "samsung,exynos5440-ehci")) {
> >                 s5p_ehci->pdata = &empty_platdata;
> >                 goto skip_phy;
> >         }
> >
> > -       phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> >         if (IS_ERR(phy)) {
> >                 /* Fallback to pdata */
> >                 if (!pdata) {
> > @@ -122,7 +124,6 @@ static int s5p_ehci_probe(struct platform_device
> *pdev)
> >                 }
> >         } else {
> >                 s5p_ehci->phy = phy;
> > -               s5p_ehci->otg = phy->otg;
> >         }
> >
> >  skip_phy:
> > @@ -166,7 +167,7 @@ skip_phy:
> >                 s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
> 
> Lets remove this line and similar calls to 'set_host()' in the driver,
> since we don't have s5p_ehci->otg anymore after the same is removed
> above.
> Anyways this was helping the old phy-samsung-usb2 driver, and not
> needed now.

Ok, I will.

> 
> >
> >         if (s5p_ehci->phy)
> > -               usb_phy_init(s5p_ehci->phy);
> > +               phy_power_on(s5p_ehci->phy);
> >         else if (s5p_ehci->pdata->phy_init)
> >                 s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
> >
> > @@ -188,7 +189,7 @@ skip_phy:
> >
> >  fail_add_hcd:
> >         if (s5p_ehci->phy)
> > -               usb_phy_shutdown(s5p_ehci->phy);
> > +               phy_power_off(s5p_ehci->phy);
> >         else if (s5p_ehci->pdata->phy_exit)
> >                 s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
> >  fail_io:
> > @@ -209,7 +210,7 @@ static int s5p_ehci_remove(struct platform_device
> *pdev)
> >                 s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
> 
> ditto
> 
> >
> >         if (s5p_ehci->phy)
> > -               usb_phy_shutdown(s5p_ehci->phy);
> > +               phy_power_off(s5p_ehci->phy);
> >         else if (s5p_ehci->pdata->phy_exit)
> >                 s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
> >
> > @@ -244,7 +245,7 @@ static int s5p_ehci_suspend(struct device *dev)
> >                 s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
> ditto
> 
> >
> >         if (s5p_ehci->phy)
> > -               usb_phy_shutdown(s5p_ehci->phy);
> > +               phy_power_off(s5p_ehci->phy);
> >         else if (s5p_ehci->pdata->phy_exit)
> >                 s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
> >
> > @@ -265,7 +266,7 @@ static int s5p_ehci_resume(struct device *dev)
> >                 s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
> ditto
> 
> >
> >         if (s5p_ehci->phy)
> > -               usb_phy_init(s5p_ehci->phy);
> > +               phy_power_on(s5p_ehci->phy);
> >         else if (s5p_ehci->pdata->phy_init)
> >                 s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
> >
> [..] Rest looks good. :-)
> 

Thank you!

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


