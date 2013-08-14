Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab3HNO4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:56:06 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:50440 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739Ab3HNOz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:55:56 -0400
Message-ID: <1376492078.7311.6.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v3 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers
 for DWC3 core
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: balbi@ti.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Wed, 14 Aug 2013 17:54:38 +0300
In-Reply-To: <20130814142056.GB2673@joshc>
References: <1376485183-2664-1-git-send-email-iivanov@mm-sol.com>
	 <1376485183-2664-3-git-send-email-iivanov@mm-sol.com>
	 <20130814142056.GB2673@joshc>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Wed, 2013-08-14 at 09:20 -0500, Josh Cartwright wrote: 
> On Wed, Aug 14, 2013 at 03:59:42PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > These drivers handles control and configuration of the HS
> > and SS USB PHY transceivers. They are part of the driver
> > which manage Synopsys DesignWare USB3 controller stack
> > inside Qualcomm SoC's.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> [..]
> > diff --git a/drivers/usb/phy/phy-msm-dwc3-hs.c b/drivers/usb/phy/phy-msm-dwc3-hs.c
> > new file mode 100644
> > index 0000000..465a8f5
> > --- /dev/null
> > +++ b/drivers/usb/phy/phy-msm-dwc3-hs.c
> [..]
> > +
> > +struct msm_dwc3_hs_phy {
> > +	struct usb_phy		phy;
> > +	void __iomem		*base;
> > +	struct device		*dev;
> > +
> > +	struct clk		*xo_clk;
> > +	struct clk		*sleep_a_clk;
> > +
> > +	struct regulator	*v3p3;
> > +	struct regulator	*v1p8;
> > +	struct regulator	*vddcx;
> > +	struct regulator	*vbus;
> > +};
> > +
> > +#define	phy_to_dwc3_phy(x)	container_of((x), struct msm_dwc3_hs_phy, phy)
> > +
> > +
> > +/**
> > + *
> > + * Write register with debug info.
> 
> what debug info?

Will fix this. It was left from the earliest versions of the functions. 

> 
> > + *
> > + * @base - DWC3 base virtual address.
> > + * @offset - register offset.
> > + * @val - value to write.
> > + *
> > + */
> > +static inline void msm_dwc3_hs_write(void *base, u32 offset, u32 val)
> 
> You've dropped __iomem here; have you run through sparse?

Obviously not :-). Thanks for noticing this.

> 
> > +{
> > +	iowrite32(val, base + offset);
> > +}
> > +
> > +/**
> > + * Write register and read back masked value to confirm it is written
> > + *
> > + * @base - DWC3 base virtual address.
> > + * @offset - register offset.
> > + * @mask - register bitmask specifying what should be updated
> > + * @val - value to write.
> > + *
> > + */
> > +static inline void msm_dwc3_hs_write_readback(void *base, u32 offset,
> > +					    const u32 mask, u32 val)
> > +{
> 
> Same comment here.

Will be fixed in next version.

Thanks,
Ivan

