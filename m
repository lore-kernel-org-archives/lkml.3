Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3LMP0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:26:35 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34040 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3LMP0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:26:32 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-3c-52ab27255da5
From: Kamil Debski <k.debski@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        matt.porter@linaro.org
References: <1386943380-28596-1-git-send-email-k.debski@samsung.com>
 <52AB1D75.4030207@ti.com>
In-reply-to: <52AB1D75.4030207@ti.com>
Subject: RE: [PATCH RESEND v2 1/2] phy: core: Add an exported of_phy_get
 function
Date: Fri, 13 Dec 2013 16:26:28 +0100
Message-id: <008a01cef817$b24844e0$16d8cea0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac74EfF9VTVZhBVgRLGdBBTm6A+mcQABPwWQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xy7qq6quDDO5OMLeYf+Qcq0XblYPs
	Fhee9rBZXN41h81ixvl9TBaLlrUyW6w9cpfdYmLTNHaL9TNeszhwety5tofNo2/LKkaP4ze2
	M3l83iQXwBLFZZOSmpNZllqkb5fAlfHhxR/2gjUyFR3TLrE2MP4U7WLk5JAQMJHovtzMCGGL
	SVy4t56ti5GLQ0hgKaNEz/4N7BBOA5NE14O3QA4HB5uApsSqex4gcRGBFYwSBx4cZwZxmAXa
	GSW+v1jPDDJKSCBB4t3NT2A2p4CaxI2X91hAbGGBYIlbuzuZQQaxCKhK/O1NAAnzCjhIHDr9
	ggXCFpT4MRminFlAS2L9zuNMELa8xOY1b8FaJQTUJR791QUJiwgYSRzaOReqXETibsNz1gmM
	QrOQTJqFZNIsJJNmIWlZwMiyilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkbr7uYFx6zOoQ
	owAHoxIP703u1UFCrIllxZW5hxglOJiVRHi7ZIBCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGOc1
	mF/6+mJqo5C/07Ejb2Z8+nl4TmP3buUZut8M7njfWbC/wU/wrevr0jDmH+2hThGbGcOks8Sl
	RFmrxLfm/5/j8Drchyc7O8rFSuvdCXm+JJ3s+3mLQlxnuzzSuMy42ljZ/ufn/Enyf+x6vn/9
	LcZ1pfFO3LrDi39Nm5aVbHI08DXrzULLJUosxRmJhlrMRcWJAF050X55AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Friday, December 13, 2013 3:45 PM
> 
> Hi,
> 
> On Friday 13 December 2013 07:32 PM, Kamil Debski wrote:
> > Previously the of_phy_get function took a struct device * and was
> > declared static. It was impossible to call it from another driver and
> > thus it was impossible to get phy defined for a given node. The old
> > function was renamed to _of_phy_get and was left for internal use.
> > of_phy_get function was added and it was exported. The function
> > enables to get a phy for a given device tree node.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > ---
> > It seems that my git send-email is playing up and sent the previous
> > emails without from. This is a resend. Sorry for any confusion.
> > ---
> >  drivers/phy/phy-core.c  |   41 ++++++++++++++++++++++++++++++++-----
> ----
> >  include/linux/phy/phy.h |    1 +
> >  2 files changed, 33 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c index
> > 03cf8fb..f0dbd42 100644
> > --- a/drivers/phy/phy-core.c
> > +++ b/drivers/phy/phy-core.c
> > @@ -240,8 +240,8 @@ out:
> >  EXPORT_SYMBOL_GPL(phy_power_off);
> >
> >  /**
> > - * of_phy_get() - lookup and obtain a reference to a phy by phandle
> > - * @dev: device that requests this phy
> > + * _of_phy_get() - lookup and obtain a reference to a phy by phandle
> > + * @np: device_node for which to get the phy
> >   * @index: the index of the phy
> >   *
> >   * Returns the phy associated with the given phandle value, @@
> > -250,20 +250,17 @@ EXPORT_SYMBOL_GPL(phy_power_off);
> >   * not yet loaded. This function uses of_xlate call back function
> provided
> >   * while registering the phy_provider to find the phy instance.
> >   */
> > -static struct phy *of_phy_get(struct device *dev, int index)
> > +static struct phy *_of_phy_get(struct device_node *np, int index)
> >  {
> >  	int ret;
> >  	struct phy_provider *phy_provider;
> >  	struct phy *phy = NULL;
> >  	struct of_phandle_args args;
> >
> > -	ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-
> cells",
> > +	ret = of_parse_phandle_with_args(np, "phys", "#phy-cells",
> >  		index, &args);
> > -	if (ret) {
> > -		dev_dbg(dev, "failed to get phy in %s node\n",
> > -			dev->of_node->full_name);
> > +	if (ret)
> >  		return ERR_PTR(-ENODEV);
> > -	}
> >
> >  	mutex_lock(&phy_provider_mutex);
> >  	phy_provider = of_phy_provider_lookup(args.np); @@ -283,6 +280,32
> @@
> > err0:
> >  }
> >
> >  /**
> > + * of_phy_get() - lookup and obtain a reference to a phy using a
> device_node.
> > + * @np: device_node for which to get the phy
> > + * @index: the index of the phy
> 
> Would be better if the user can get the PHY by string instead of index.

Ok, this sounds doable. I will add of_phy_get_by_name analogous to the clk
framework.

> > + *
> > + * Returns the phy driver, after getting a refcount to it; or
> > + * -ENODEV if there is no such phy.  The caller is responsible for
> > + * calling phy_put() to release that count.
> > + */
> > +struct phy *of_phy_get(struct device_node *np, int index) {
> > +	struct phy *phy = NULL;
> > +
> > +	phy = _of_phy_get(np, index);
> > +	if (IS_ERR(phy))
> dev_err here?

dev_err requires a dev, so it is not possible with the arguments used.
And we do not want to add any extra parameters to keep the function call
analogous to other of_*_get (as for example of_clk_get).

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


