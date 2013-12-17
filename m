Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab3LQNOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:14:03 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65252 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3LQNOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:14:00 -0500
Date: Tue, 17 Dec 2013 08:13:55 -0500
From: "'Matt Porter'" <mporter@linaro.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, kishon@ti.com,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        "'Felipe Balbi'" <balbi@ti.com>
Subject: Re: [PATCH v4 5/9] usb: s3c-hsotg: Use the new Exynos USB phy driver
 with the generic phy framework
Message-ID: <20131217131355.GC15814@beef>
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
 <1386246579-25141-6-git-send-email-k.debski@samsung.com>
 <20131216214012.GB15814@beef>
 <02bb01cefb0c$3ad4d890$b07e89b0$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02bb01cefb0c$3ad4d890$b07e89b0$%debski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 10:41:56AM +0100, Kamil Debski wrote:
> Hi Matt,
> 
> I am afraid it is not possible. This patch cannot go in without the 
> new  phy driver. It would break Exynos USB functionality. This
> is because it changes s3c-hsotg to use the new phy driver.

To clarify, I'm proposing that I would bring back the original patch
from my earlier postings on the bcm281xx series that preserves the old
style usb phy support as a fallback along with the pdata path.

> I am working on an updated patch series addressing all the comments.
> time permitting I want to post an alternative version - integrating
> as much as possible in a single file. This way it would be possible
> to have a hands-on comparison of the two approaches we were
> discussing with Kishon. 
> 
> I estimate that I post it this week.

Ok, thanks. In the meantime I'll update my original version of this
patch in case your work can't be taken in this window.

-Matt

> > -----Original Message-----
> > From: Matt Porter [mailto:mporter@linaro.org]
> > Sent: Monday, December 16, 2013 10:40 PM
> > To: Kamil Debski
> > Cc: linux-kernel@vger.kernel.org; linux-samsung-soc@vger.kernel.org;
> > linux-usb@vger.kernel.org; devicetree@vger.kernel.org;
> > kyungmin.park@samsung.com; kishon@ti.com; t.figa@samsung.com;
> > s.nawrocki@samsung.com; m.szyprowski@samsung.com;
> > gautam.vivek@samsung.com; mat.krawczuk@gmail.com;
> > yulgon.kim@samsung.com; p.paneri@samsung.com; av.tikhomirov@samsung.com;
> > jg1.han@samsung.com; galak@codeaurora.org; Felipe Balbi
> > Subject: Re: [PATCH v4 5/9] usb: s3c-hsotg: Use the new Exynos USB phy
> > driver with the generic phy framework
> > 
> > On Thu, Dec 05, 2013 at 01:29:35PM +0100, Kamil Debski wrote:
> > > Change the used phy driver to the new Exynos USB phy driver that uses
> > > the generic phy framework.
> > >
> > > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >  .../devicetree/bindings/usb/samsung-hsotg.txt      |    4 ++++
> > >  drivers/usb/gadget/s3c-hsotg.c                     |   11 ++++++----
> > -
> > >  2 files changed, 10 insertions(+), 5 deletions(-)
> > 
> > Kamil,
> > 
> > Can we separate this patch out of this series? My bcm281xx series is
> > ready to go except for this dependency. Felipe has noted that there's
> > only a week until he locks his tree down for 3.14 [1]. I'm willing to
> > update this versus the comment Kishon made on fixing the example if you
> > don't have time before then. Let me know.
> > 
> > [1] https://lkml.org/lkml/2013/12/16/555
> > 
> > Thanks,
> > Matt
> > 
> > > diff --git a/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
> > > b/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
> > > index b83d428..9340d06 100644
> > > --- a/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
> > > +++ b/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
> > > @@ -24,6 +24,8 @@ Required properties:
> > >      - first entry: must be "otg"
> > >  - vusb_d-supply: phandle to voltage regulator of digital section,
> > >  - vusb_a-supply: phandle to voltage regulator of analog section.
> > > +- phys: from general PHY binding: phandle to the PHY device
> > > +- phy-names: from general PHY binding: should be "usb2-phy"
> > >
> > >  Example
> > >  -----
> > > @@ -36,5 +38,7 @@ Example
> > >  		clock-names = "otg";
> > >  		vusb_d-supply = <&vusb_reg>;
> > >  		vusb_a-supply = <&vusbdac_reg>;
> > > +		phys = <&usb2phy 0>;
> > > +		phy-names = "device";
> > >  	};
> > >
> > > diff --git a/drivers/usb/gadget/s3c-hsotg.c
> > > b/drivers/usb/gadget/s3c-hsotg.c index eccb147..db096fd 100644
> > > --- a/drivers/usb/gadget/s3c-hsotg.c
> > > +++ b/drivers/usb/gadget/s3c-hsotg.c
> > > @@ -31,6 +31,7 @@
> > >  #include <linux/regulator/consumer.h>  #include <linux/of.h>
> > > #include <linux/of_platform.h>
> > > +#include <linux/phy/phy.h>
> > >
> > >  #include <linux/usb/ch9.h>
> > >  #include <linux/usb/gadget.h>
> > > @@ -162,7 +163,7 @@ struct s3c_hsotg_ep {  struct s3c_hsotg {
> > >  	struct device		 *dev;
> > >  	struct usb_gadget_driver *driver;
> > > -	struct usb_phy		*phy;
> > > +	struct phy		 *phy;
> > >  	struct s3c_hsotg_plat	 *plat;
> > >
> > >  	spinlock_t              lock;
> > > @@ -2905,7 +2906,7 @@ static void s3c_hsotg_phy_enable(struct
> > s3c_hsotg *hsotg)
> > >  	dev_dbg(hsotg->dev, "pdev 0x%p\n", pdev);
> > >
> > >  	if (hsotg->phy)
> > > -		usb_phy_init(hsotg->phy);
> > > +		phy_power_on(hsotg->phy);
> > >  	else if (hsotg->plat->phy_init)
> > >  		hsotg->plat->phy_init(pdev, hsotg->plat->phy_type);  } @@ -
> > 2922,7
> > > +2923,7 @@ static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
> > >  	struct platform_device *pdev = to_platform_device(hsotg->dev);
> > >
> > >  	if (hsotg->phy)
> > > -		usb_phy_shutdown(hsotg->phy);
> > > +		phy_power_off(hsotg->phy);
> > >  	else if (hsotg->plat->phy_exit)
> > >  		hsotg->plat->phy_exit(pdev, hsotg->plat->phy_type);  } @@ -
> > 3529,7
> > > +3530,7 @@ static void s3c_hsotg_delete_debug(struct s3c_hsotg *hsotg)
> > > static int s3c_hsotg_probe(struct platform_device *pdev)  {
> > >  	struct s3c_hsotg_plat *plat = dev_get_platdata(&pdev->dev);
> > > -	struct usb_phy *phy;
> > > +	struct phy *phy;
> > >  	struct device *dev = &pdev->dev;
> > >  	struct s3c_hsotg_ep *eps;
> > >  	struct s3c_hsotg *hsotg;
> > > @@ -3544,7 +3545,7 @@ static int s3c_hsotg_probe(struct
> > platform_device *pdev)
> > >  		return -ENOMEM;
> > >  	}
> > >
> > > -	phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > > +	phy = devm_phy_get(&pdev->dev, "usb2-phy");
> > >  	if (IS_ERR(phy)) {
> > >  		/* Fallback for pdata */
> > >  		plat = dev_get_platdata(&pdev->dev);
> > > --
> > > 1.7.9.5
> > >
> 
