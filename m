Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaBEP5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:57:16 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15056 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaBEP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:57:09 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-c5-52f25f52d319
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
        matt.porter@linaro.org, tjakobi@math.uni-bielefeld.de
References: <1391016574-25237-9-git-send-email-k.debski@samsung.com>
 <Pine.LNX.4.44L0.1401291530001.23560-100000@netrider.rowland.org>
In-reply-to: <Pine.LNX.4.44L0.1401291530001.23560-100000@netrider.rowland.org>
Subject: RE: [PATCH v6 8/8] usb: ehci-exynos: Change to use phy provided by the
 generic phy framework
Date: Wed, 05 Feb 2014 16:57:04 +0100
Message-id: <054301cf228a$eb58a480$c209ed80$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8dM56xZaXgN3DfSu+Eq23cmWVUzQFSPwIw
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t/xq7pB8Z+CDB7c1rRYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBYXnvawWZxtegPk7prDZjHj/D4mi0XLWpkt1h65y25xtv82m8XE
	pmnsFue3dDJZHH7Tzmox4fcFNov1M16zWLSt/sBq0XH2ILuDsMflvl4mj52z7rJ73Lm2h83j
	3zF2j9l3fzB69G1Zxehx/MZ2Jo/Pm+QCOKK4bFJSczLLUov07RK4MmZdeslScFO1YsHZqywN
	jEtkuxg5OSQETCQWNq5ihrDFJC7cW8/WxcjFISSwlFFi1d5T7BBOA5PEjU/rgBwODjYBTYlV
	9zxAGkQEdCTe7LoAVsMs0M0i8WrmIWaIhg5Gic3vrrGCVHEK+ElsOb2AEcQWFkiXuH/0BNg6
	FgFVibt3Z4LFeQUcJI4/mwplC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZpAjJATUJR791YU4
	wkji7c4l7BAlIhJ3G56zTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKppckFxUnpuYZ6xYm5xaV5
	6XrJ+bmbGCEx/GUH4+JjVocYBTgYlXh4O0Q/BgmxJpYVV+YeYpTgYFYS4W2N/RQkxJuSWFmV
	WpQfX1Sak1p8iJGJg1OqgTFQ8Oay1Q8vzXxQI2j1TjSfT/FZ081H6+tjG4/v9c/xNndcvGb5
	x3ZDNtfjt9bM33Nh1ZWgL/pFD9Qu+kex9Jtns2w8ambjpWe6p2lZ7+WH8eIeqwLf/Lt66/M3
	PbENuRPXh6jF5PhsfGz95tayRNmUO38cXRPSufkXBEt3qWmuyBLg2WCptViJpTgj0VCLuag4
	EQDKzkYxvwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thank you for your review.

> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Wednesday, January 29, 2014 9:43 PM
> 
> On Wed, 29 Jan 2014, Kamil Debski wrote:
> 
> > Change the phy provider used from the old one using the USB phy
> > framework to a new one using the Generic phy framework.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > ---
> >  .../devicetree/bindings/usb/exynos-usb.txt         |   13 +++
> >  drivers/usb/host/ehci-exynos.c                     |   97
> +++++++++++++-------
> >  2 files changed, 76 insertions(+), 34 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> > b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> > index d967ba1..25e199a 100644
> > --- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> > +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> > @@ -12,6 +12,10 @@ Required properties:
> >   - interrupts: interrupt number to the cpu.
> >   - clocks: from common clock binding: handle to usb clock.
> >   - clock-names: from common clock binding: Shall be "usbhost".
> > +  - port: if in the SoC there are EHCI phys, they should be listed
> here.
> > +One phy per port. Each port should have its reg entry with a
> > +consecutive number. Also it should contain phys and phy-names
> entries
> > +specifying the phy used by the port.
> 
> What is the reg entry number used for?  As far as I can see, it isn't
> used for anything.  In which case, why have it at all?

Tomasz Figa already commented this. I agree with him, that this should
be better described in the documentation.

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
> You have removed all the OTG stuff from the driver.  This wasn't
> mentioned in the patch description, and it has no connection with the
> PHY work.

Maybe I'll explain more about what are we trying to achieve. The goal
is to replace the old phy driver with the new one. In the old driver it was
difficult to add support to new SoC. It also had issues with having device
and
host working together.

You're right that until the old phy driver is removed support for the it
should
remain. To be able to remove the old driver both new USB2 and new USB3 phy
drivers
have to be ready. The USB3 driver is written by Vivek Gautam and as I see
it, he
is also close to completion.

Regarding the otg part. The old phy driver is the only provider of the otg
structure. It sets the host field of the structure. It is then used by
samsung_usb2phy_init (drivers/usb/phy/phy-samsung-usb2.c) to check which
driver is requesting the phy (is it host or device). In the new driver this
is determined by the entry in device tree. So no need to check the otg
struct
and strstr (!) to check if dev_name is ehci, ohci or other, like the old
driver.

> > +	struct phy *phy[PHY_NUMBER];
> >  };
> >
> >  #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd
> > *)(hcd_to_ehci(hcd)->priv) @@ -69,13 +69,43 @@ static void
> exynos_setup_vbus_gpio(struct platform_device *pdev)
> >  		dev_err(dev, "can't request ehci vbus gpio %d", gpio);  }
> >
> > +static int exynos_phys_on(struct phy *p[]) {
> > +	int i;
> > +	int ret = 0;
> > +
> > +	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
> > +		if (p[i])
> > +			ret = phy_power_on(p[i]);
> > +	if (ret)
> > +		for (i--; i > 0; i--)
> > +			if (p[i])
> > +				phy_power_off(p[i]);
> 
> This loop runs while i > 0.  Therefore you will never turn off the
> power to p[0].

Ups, my bad. Thank you for spotting this.

> 
> > @@ -102,14 +132,26 @@ static int exynos_ehci_probe(struct
> platform_device *pdev)
> >  					"samsung,exynos5440-ehci"))
> >  		goto skip_phy;
> >
> > -	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> > -	if (IS_ERR(phy)) {
> > -		usb_put_hcd(hcd);
> 
> You omitted this line from the new error returns below.

I see.

> 
> > -		dev_warn(&pdev->dev, "no platform data or transceiver
> defined\n");
> > -		return -EPROBE_DEFER;
> > -	} else {
> > -		exynos_ehci->phy = phy;
> > -		exynos_ehci->otg = phy->otg;
> > +	for_each_available_child_of_node(pdev->dev.of_node, child) {
> > +		err = of_property_read_u32(child, "reg", &phy_number);
> > +		if (err) {
> > +			dev_err(&pdev->dev, "Failed to parse device
tree\n");
> > +			of_node_put(child);
> > +			return err;
> 
> Here, for example.  Wouldn't it be better to goto fail_clk?

Right, I will fix this. Thank you.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

