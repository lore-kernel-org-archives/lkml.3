Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab3KTOA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:00:56 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62457 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3KTOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:00:52 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-9f-528cc091f71c
From: Tomasz Figa <t.figa@samsung.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow grouping multiple pinmux/pinconf
 nodes
Date: Wed, 20 Nov 2013 15:00:36 +0100
Message-id: <7242109.um7KlGhuI2@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <528BB789.5020201@wwwdotorg.org>
References: <1384881034-10520-1-git-send-email-t.figa@samsung.com>
 <528BB789.5020201@wwwdotorg.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xK7oTD/QEGdz8pWEx/8g5Vouzyw6y
	Wfx/9JrVonfBVTaLs01v2C2m/FnOZLHp8TVWi8u75rBZzDi/j8li7ZG77BavDraxWBybsYTR
	gcdjdsNFFo871/aweWxeUu/Rt2UVo8f2a/OYPT5vkvPYODc0gD2KyyYlNSezLLVI3y6BK2PX
	6U0sBWuUKk78mMXYwPhCqouRk0NCwERi2b9ZLBC2mMSFe+vZuhi5OIQEljJKnJ39jQXC6WKS
	aF7UyA5SxSagJvG54REbiC0ioCUx6dk/RpAiZoFDzBKtLy6DJYQFQiUermhgBrFZBFQlFi7e
	CmbzCmhKrN/zAmwQv4C6xLttT5lAbFEBN4npPw6C1XAK6Er8Xb0ELC4kkCrx7cNMVoheQYkf
	k++BncosIC+xb/9UVghbS2L9zuNMExgFZyEpm4WkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OL
	S/PS9ZLzczcxQmLoyw7GxcesDjEKcDAq8fBKLOgOEmJNLCuuzD3EKMHBrCTC27W3J0iINyWx
	siq1KD++qDQntfgQIxMHp1QDo7V4ceYsWcfXomq5Rz/f5k7kMnWLD150RTTw2JaAqIdzuDM3
	HP16ryqo9E/Sq9TTin69H+a1+wV0GXzdP1V0pnsjz4pvz999vzfp942iFrewc54/GZ4uXBhy
	tPnCx4wA+bO9GlfZ55x0/De5hansv27cvaPu/rFXTjvFG0x5K6joJVpwVDzophJLcUaioRZz
	UXEiAI+MOGV/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tuesday 19 of November 2013 12:10:01 Stephen Warren wrote:
> On 11/19/2013 10:10 AM, Tomasz Figa wrote:
> > One of remaining limitations of current pinctrl-samsung driver was
> > the inability to parse multiple pinmux/pinconf group nodes grouped
> > inside a single device tree node. It made defining groups of pins for
> > single purpose, but with different parameters very inconvenient.
> > 
> > This patch implements Tegra-like support for grouping multiple pinctrl
> > groups inside one device tree node, by completely changing the way
> > pin groups and functions are parsed from device tree.
> 
> > The code creating
> > pinctrl maps from DT nodes has been borrowed from pinctrl-tegra,
> 
> A lot of the Tegra code has been slightly generalized and put into
> pinconf-generic.c. Can the Samsung driver be converted to use that core
> code rather than adding another copy of it? Perhaps this isn't possible
> given the backwards-compatibility requirements that allow either 1- or
> 2-level nodes though, although I imagine that could be added to the core
> code. One thing you'd certainly need to do is enhance the code in
> pinconf-generic.c so that you could substitute your own
> pinconf_generic_parse_dt_config() function or dt_params[] table, to
> allow for the SoC-specific property names, but I doubt that's too hard.
> Tegra could be converted then too:-)

I can't say that it's not a good idea, but I would prefer this to be
merged first as an Exynos-specific patch and only then somehow try to
figure out how to remove code duplication. This is due to the fact that
I won't have too much time to work on this in very near future, but this
feature itself is rather convenient and it would be nice to have it
anyway.

> 
> > while
> > the initial creation of groups and functions has been completely
> > rewritten with following assumptions:
> >  - each group consists of just one pin and does not depend on data
> >    from device tree,
> >  - each function is represented by a device tree child node of the
> >    pin controller, which in turn can contain multiple child nodes
> >    for pins that need to have different configuration values.
> 
> OK, I think that sounds reasonable.
> 
> > Device Tree bindings are fully backwards compatible. New functionality
> > can be used by defining a new pinctrl group consisting of several child
> > nodes, as on following example:
> > 
> > 	sd4_bus8: sd4-bus-width8 {
> > 		part-1 {
> > 			samsung,pins = "gpk0-3", "gpk0-4",
> > 					"gpk0-5", "gpk0-6";
> > 			samsung,pin-function = <3>;
> > 			samsung,pin-pud = <3>;
> > 			samsung,pin-drv = <3>;
> > 		};
> > 		part-2 {
> > 			samsung,pins = "gpk1-3", "gpk1-4",
> > 					"gpk1-5", "gpk1-6";
> > 			samsung,pin-function = <4>;
> > 			samsung,pin-pud = <4>;
> > 			samsung,pin-drv = <3>;
> > 		};
> > 	};
> 
> OK, that all looks great!
> 
> > diff --git a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
> 
> The DT changes fully, and the code a little briefly,
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> 
> Just a minor comment below,
> 
> > diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
> 
> > +static int samsung_pinctrl_create_function(struct device *dev,
> > +				struct samsung_pinctrl_drv_data *drvdata,
> > +				struct device_node *func_np,
> > +				struct samsung_pmx_func *func)
> ...
> > +	for (i = 0; i < npins; ++i) {
> > +		const char *gname;
> > +		char *gname_copy;
> > +
> > +		ret = of_property_read_string_index(func_np, "samsung,pins",
> > +							i, &gname);
> > +		if (ret) {
> > +			dev_err(dev,
> > +				"failed to read pin name %d from %s node\n",
> > +				i, func_np->name);
> > +			return ret;
> >  		}
> > +
> > +		gname_copy = devm_kzalloc(dev, strlen(gname) + 1, GFP_KERNEL);
> > +		if (!gname_copy)
> > +			return -ENOMEM;
> > +		strcpy(gname_copy, gname);
> 
> Is the lifetime of the string "returned" by
> of_property_read_string_index() really so short that you must copy the
> string? I'd be tempted just to store the pointer, although perhaps you
> need to get() the node so that's safe.

Right. I have done it the copy-less way in other places, but missed this
one. Thanks.

Best regards,
Tomasz

