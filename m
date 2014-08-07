Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbaHGONO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:13:14 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:59063 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399AbaHGONM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:13:12 -0400
Date: Thu, 7 Aug 2014 15:13:07 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 2/6] usb: host: ehci-st: Add EHCI support for ST STB
 devices
Message-ID: <20140807141307.GA12137@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1407344589-24863-1-git-send-email-peter.griffin@linaro.org>
 <1407344589-24863-3-git-send-email-peter.griffin@linaro.org>
 <201408062307.18851.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201408062307.18851.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for reviewing, see my comments below: -

> > +static int st_ehci_platform_reset(struct usb_hcd *hcd)
> > +{
> > +	struct platform_device *pdev = to_platform_device(hcd->self.controller);
> > +	struct usb_ehci_pdata *pdata = dev_get_platdata(&pdev->dev);
> > +	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
> > +	int retval;
> > +
> > +	if (pdata->pre_setup) {
> > +		retval = pdata->pre_setup(hcd);
> > +		if (retval < 0)
> > +			return retval;
> > +	}
> 
> What is the point in going through a platform data function pointer here?
> Can't you just open-code st_ehci_configure_bus() here?

Yes I can, I've done as you suggest in v4.
> 
> > +	 * Use reasonable defaults so platforms don't have to provide these
> > +	 * with DT probing on ARM.
> > +	 */
> > +	if (!pdata)
> > +		pdata = &ehci_platform_defaults;
> 
> How would you ever get here with pdata set?

This is left over from using ohci-platform as a starting point. pdata is not
set when booting via DT and gets initialized here.

As this driver depends on OF and will never run without DT I've initialised
pdata where it gets defined in V4.

I've then also removed the check further down in probe that causes some unnecessary
indentation where we get the phys / clocks.
> 
> > +	err = dma_coerce_mask_and_coherent(&dev->dev, DMA_BIT_MASK(32));
> > +	if (err)
> > +		return err;
> 
> Remove this here, and rely on the correct mask to be set from the DT scan.

I've removed in V4.

regards,

Peter.
