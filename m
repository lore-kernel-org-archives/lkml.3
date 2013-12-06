Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162478Ab3LFNTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:19:16 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39724 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161941Ab3LFNTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:19:09 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-35-52a1cecabe6f
From: Kamil Debski <k.debski@samsung.com>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, kishon@ti.com,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org
References: <1386246579-25141-5-git-send-email-k.debski@samsung.com>
 <Pine.LNX.4.44L0.1312051342300.869-100000@iolanthe.rowland.org>
In-reply-to: <Pine.LNX.4.44L0.1312051342300.869-100000@iolanthe.rowland.org>
Subject: RE: [PATCH v4 4/9] usb: ehci-s5p: Change to use phy provided by the
 generic phy framework
Date: Fri, 06 Dec 2013 14:19:05 +0100
Message-id: <00cf01cef285$bdca5890$395f09b0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7x7CJHLdqYGdDTQGahtz+O6P1i5wAlrmxg
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t/xq7qnzi0MMtj41MRiye4brBbzj5xj
	teh/s5DVou3KQXaLywsvsVpceNrDZnG26Q2Qu2sOm8WM8/uYLBYta2W2WHvkLrvF2f7bbBYT
	m6axW5zf0slkcfhNO6vFhN8X2CzWz3jNYtFx9iC7g5DH5b5eJo+ds+6ye9y5tofNY/bdH4we
	fVtWMXocv7GdyePzJrkA9igum5TUnMyy1CJ9uwSujNmfT7EXPJGpWLpkKWsD41SxLkZODgkB
	E4n+nUdZIGwxiQv31rN1MXJxCAksZZR4OW0SC4TTwCQxo301cxcjBwebgKbEqnseIA0iAjoS
	b3ZdYAepYRZ4wyyx5Vw7O0RDG6PEjpkNYGM5BXwknux+wwhiCwukSOxpe88OMohFQFWi/3wq
	SJhXwEFi85RFTBC2oMSPyffAWpkFtCTW7zzOBGHLS2xe8xbsBgkBdYlHf3UhbjCSOHPyEyNE
	iYjE3YbnrBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZI
	vH7Zwbj4mNUhRgEORiUe3oQ1C4KEWBPLiitzDzFKcDArifAu2bcwSIg3JbGyKrUoP76oNCe1
	+BAjEwenVAPj2km2awOv+PAurRO+IRVrWbNN67xu04ozkl7bCktcLX8d3nvb+PkmphNyGSZ3
	I6Y1LJk/VV9lhSUD9zduw23bayY94ng18f/p+tBl7M8WqIcqlrMHmV05wXXK49ydZ1t+PVgY
	7FF4c5ehXWY35w35ObciV52qqH+pdf/1D7bZkty3S/6t+T7NR4mlOCPRUIu5qDgRAN5fqFu1	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thank you for the review. Please find my replies inline.

> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Thursday, December 05, 2013 7:53 PM
> 
> On Thu, 5 Dec 2013, Kamil Debski wrote:
> 
> > Change the phy provider used from the old usb phy specific to a new
> > one using the generic phy framework.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> > --- a/drivers/usb/host/ehci-exynos.c
> > +++ b/drivers/usb/host/ehci-exynos.c
> 
> > @@ -42,10 +42,10 @@
> >  static const char hcd_name[] = "ehci-exynos";  static struct
> > hc_driver __read_mostly exynos_ehci_hc_driver;
> >
> > +#define PHY_NUMBER 3
> >  struct exynos_ehci_hcd {
> >  	struct clk *clk;
> > -	struct usb_phy *phy;
> > -	struct usb_otg *otg;
> 
> Are you sure you want to remove that line?

Yes, I am. The new generic phy interface does not have the otg field in it.
 
> > +	struct phy *phy[PHY_NUMBER];
> >  };
> >
> >  #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd
> > *)(hcd_to_ehci(hcd)->priv)
> 
> > @@ -102,13 +132,24 @@ static int exynos_ehci_probe(struct
> platform_device *pdev)
> >  					"samsung,exynos5440-ehci"))
> >  		goto skip_phy;
> >
> > -	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> > -	if (IS_ERR(phy)) {
> > -		usb_put_hcd(hcd);
> > -		dev_warn(&pdev->dev, "no platform data or transceiver
> defined\n");
> > -		return -EPROBE_DEFER;
> > -	} else {
> > -		exynos_ehci->phy = phy;
> > +	for_each_available_child_of_node(pdev->dev.of_node, child) {
> > +		err = of_property_read_u32(child, "reg", &phy_number);
> > +		if (err) {
> > +			dev_err(&pdev->dev, "Failed to parse device
tree\n");
> > +			return err;
> > +		}
> > +		if (phy_number >= PHY_NUMBER) {
> > +			dev_err(&pdev->dev, "Failed to parse device tree -
> number out of range\n");
> > +			return -EINVAL;
> 
> Do you need to call of_node_put(child) before each of these return
> statements?

You are right, thank you for spotting this.

> 
> > +		}
> > +		phy = devm_of_phy_get(&pdev->dev, child, 0);
> > +		of_node_put(child);
> > +		if (IS_ERR(phy)) {
> > +			dev_err(&pdev->dev, "Failed to get phy number %d",
> > +								phy_number);
> > +			return PTR_ERR(phy);
> > +		}
> > +		exynos_ehci->phy[phy_number] = phy;
> >  		exynos_ehci->otg = phy->otg;
> 
> Did you intend to remove this line?  Above, you removed the
> exynos_ehci->otg field.  I can't see how this patch would ever compile
> without an error.

Yes, I had this in a separate fix patch which I forgot to squash. Sorry for
this.

> >  	}
> >
> > @@ -149,11 +190,11 @@ skip_phy:
> >  		goto fail_io;
> >  	}
> >
> > -	if (exynos_ehci->otg)
> > -		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
> > -
> > -	if (exynos_ehci->phy)
> > -		usb_phy_init(exynos_ehci->phy);
> > +	err = exynos_phys_on(exynos_ehci->phy);
> > +	if (err) {
> > +		dev_err(&pdev->dev, "Failed to enabled phys\n");
> > +		goto fail_phys_on;
> 
> Why add a new statement label?  Just goto fail_io.

To me it seemed better to add a new label. I will drop it and use
goto fail_io, as you suggested.

> 
> > +	}
> >
> >  	ehci = hcd_to_ehci(hcd);
> >  	ehci->caps = hcd->regs;
> > @@ -172,8 +213,8 @@ skip_phy:
> >  	return 0;
> >
> >  fail_add_hcd:
> > -	if (exynos_ehci->phy)
> > -		usb_phy_shutdown(exynos_ehci->phy);
> > +	exynos_phys_off(exynos_ehci->phy);
> > +fail_phys_on:
> >  fail_io:
> >  	clk_disable_unprepare(exynos_ehci->clk);
> >  fail_clk:
> 
> Alan Stern

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

