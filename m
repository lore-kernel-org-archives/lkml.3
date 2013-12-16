Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3LPMzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:55:41 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34394 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3LPMzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:55:38 -0500
X-AuditID: cbfec7f4-b7fc96d000006cd4-01-52aef84731ad
From: Kamil Debski <k.debski@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        matt.porter@linaro.org
References: <1386943380-28596-1-git-send-email-k.debski@samsung.com>
 <52AB1D75.4030207@ti.com> <008a01cef817$b24844e0$16d8cea0$%debski@samsung.com>
 <52AEC145.6070208@ti.com>
In-reply-to: <52AEC145.6070208@ti.com>
Subject: RE: [PATCH RESEND v2 1/2] phy: core: Add an exported of_phy_get
 function
Date: Mon, 16 Dec 2013 13:55:34 +0100
Message-id: <023f01cefa5e$1cbe81c0$563b8540$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac76PVn8eIcZAbAxQdC0qUCqL69s8AAIGGAg
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xy7ruP9YFGUxcqGkx/8g5Vou2KwfZ
	LS487WGzuLxrDpvFjPP7mCwWLWtltlh75C67xcSmaewW62e8ZnHg9LhzbQ+bR9+WVYwex29s
	Z/L4vEkugCWKyyYlNSezLLVI3y6BK2PrpDmsBfuUKqbc+cjawHhHqouRk0NCwETiwpMTrBC2
	mMSFe+vZuhi5OIQEljJKzFy9jwXCaWCSaLzUwtTFyMHBJqApseqeB0hcRGAFo8SBB8eZQRxm
	gXZGie8v1jNDdGxklPi2dhYbyFxOATWJj1/mgNnCAsESt3Z3MoPYLAKqEod7T4HZvAIOEm09
	MxkhbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywxyhYSAusSjv7ogYREBI4l79z+wQZSISNxt
	eM46gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihMTOlx2M
	i49ZHWIU4GBU4uENXLcuSIg1say4MvcQowQHs5IIb/1xoBBvSmJlVWpRfnxRaU5q8SFGJg5O
	qQZGmU11S+Xyynjm7y7J2PsxhTVMONSXKzzxB2fUzqq6/rXanybNzWsQC9xSqPOmQrxhR//0
	X+ZvXwvzn9Q4f4trje8Nhu0Lfi2L5lRuzDJwMrbf8q6SXdtyR5HBOY6fZc37fxdVCi7L01of
	4rE//9fSKSeNH7fb992NuPCmcenRKxm251leOnoqsRRnJBpqMRcVJwIAcp4ppHsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Monday, December 16, 2013 10:01 AM
> 
> On Friday 13 December 2013 08:56 PM, Kamil Debski wrote:
> > Hi Kishon,
> >
> >> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> >> Sent: Friday, December 13, 2013 3:45 PM
> >>
> >> Hi,
> >>
> >> On Friday 13 December 2013 07:32 PM, Kamil Debski wrote:
> >>> Previously the of_phy_get function took a struct device * and was
> >>> declared static. It was impossible to call it from another driver
> >>> and thus it was impossible to get phy defined for a given node. The
> >>> old function was renamed to _of_phy_get and was left for internal
> use.
> >>> of_phy_get function was added and it was exported. The function
> >>> enables to get a phy for a given device tree node.
> >>>
> >>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> >>> ---
> >>> It seems that my git send-email is playing up and sent the previous
> >>> emails without from. This is a resend. Sorry for any confusion.
> >>> ---
> >>>  drivers/phy/phy-core.c  |   41 ++++++++++++++++++++++++++++++++---
> --
> >> ----
> >>>  include/linux/phy/phy.h |    1 +
> >>>  2 files changed, 33 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c index
> >>> 03cf8fb..f0dbd42 100644
> >>> --- a/drivers/phy/phy-core.c
> >>> +++ b/drivers/phy/phy-core.c
> >>> @@ -240,8 +240,8 @@ out:
> >>>  EXPORT_SYMBOL_GPL(phy_power_off);
> >>>
> >>>  /**
> >>> - * of_phy_get() - lookup and obtain a reference to a phy by
> phandle
> >>> - * @dev: device that requests this phy
> >>> + * _of_phy_get() - lookup and obtain a reference to a phy by
> >>> + phandle
> >>> + * @np: device_node for which to get the phy
> >>>   * @index: the index of the phy
> >>>   *
> >>>   * Returns the phy associated with the given phandle value, @@
> >>> -250,20 +250,17 @@ EXPORT_SYMBOL_GPL(phy_power_off);
> >>>   * not yet loaded. This function uses of_xlate call back function
> >> provided
> >>>   * while registering the phy_provider to find the phy instance.
> >>>   */
> >>> -static struct phy *of_phy_get(struct device *dev, int index)
> >>> +static struct phy *_of_phy_get(struct device_node *np, int index)
> >>>  {
> >>>  	int ret;
> >>>  	struct phy_provider *phy_provider;
> >>>  	struct phy *phy = NULL;
> >>>  	struct of_phandle_args args;
> >>>
> >>> -	ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-
> >> cells",
> >>> +	ret = of_parse_phandle_with_args(np, "phys", "#phy-cells",
> >>>  		index, &args);
> >>> -	if (ret) {
> >>> -		dev_dbg(dev, "failed to get phy in %s node\n",
> >>> -			dev->of_node->full_name);
> >>> +	if (ret)
> >>>  		return ERR_PTR(-ENODEV);
> >>> -	}
> >>>
> >>>  	mutex_lock(&phy_provider_mutex);
> >>>  	phy_provider = of_phy_provider_lookup(args.np); @@ -283,6 +280,32
> >> @@
> >>> err0:
> >>>  }
> >>>
> >>>  /**
> >>> + * of_phy_get() - lookup and obtain a reference to a phy using a
> >> device_node.
> >>> + * @np: device_node for which to get the phy
> >>> + * @index: the index of the phy
> >>
> >> Would be better if the user can get the PHY by string instead of
> index.
> >
> > Ok, this sounds doable. I will add of_phy_get_by_name analogous to
> the
> > clk framework.
> 
> Nope. It was decided initially to have minimal no of APIs exported to
> get PHYs.
> So you can just get string as argument instead of index and leave the
> name of the API to just of_phy_get.

If you say so. I just sent a new version taking a string id instead of
an index. I hope you find it satisfying.

> Thanks
> Kishon
> 
> >
> >>> + *
> >>> + * Returns the phy driver, after getting a refcount to it; or
> >>> + * -ENODEV if there is no such phy.  The caller is responsible for
> >>> + * calling phy_put() to release that count.
> >>> + */
> >>> +struct phy *of_phy_get(struct device_node *np, int index) {
> >>> +	struct phy *phy = NULL;
> >>> +
> >>> +	phy = _of_phy_get(np, index);
> >>> +	if (IS_ERR(phy))
> >> dev_err here?
> >
> > dev_err requires a dev, so it is not possible with the arguments used.
> > And we do not want to add any extra parameters to keep the function
> > call analogous to other of_*_get (as for example of_clk_get).
> >
> > Best wishes,
> >

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


