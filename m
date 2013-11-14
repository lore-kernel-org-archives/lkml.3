Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab3KNIct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:32:49 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44282 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3KNIco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:32:44 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-7c-52848aaad6d6
Message-id: <1384417960.5901.14.camel@AMDC1943>
Subject: Re: [PATCH 1/4] mfd: max14577: Add max14577 MFD driver core
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Thu, 14 Nov 2013 09:32:40 +0100
In-reply-to: <20131113115018.GE21713@e106331-lin.cambridge.arm.com>
References: <1384328457-5147-1-git-send-email-k.kozlowski@samsung.com>
 <1384328457-5147-2-git-send-email-k.kozlowski@samsung.com>
 <20131113115018.GE21713@e106331-lin.cambridge.arm.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xa7qrulqCDBbvVrQ4uFXTYuOM9awW
	Ux8+YbO4/uU5q8X8I+dYLSaunMxsceDPDkaLs01v2C3ufz3KaPHtSgeTxeVdc9gs1h65y26x
	9PpFJovbjSvYLA6vOMBkcbqb1UHAY828NYweCz5fYfeY0P+J0WPnrLvsHptXaHlsWtXJ5nHn
	2h42j3knAz36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoErY/PHbtaCbQIV23e+YW1g/MndxcjJ
	ISFgIrHm9yVmCFtM4sK99WwgtpDAUkaJWR8SIOzPjBJLJuWD2LwC+hKTZ/8BqufgEBZwkfjX
	WgASZhMwlti8fAlYq4iAukTPri8sXYxcHMwCm1gltmxfDZZgEVCV+L9yLtguTgFnidsnLrCB
	FAkJ7GGU+P10KhNIghmoe9K8RVAHKUnsbu9kh4jLS2xe85YZ4ghBiR+T77FMYBSYhaRlFpKy
	WUjKFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQIibSvOxiXHrM6xCjAwajEw1uwszlI
	iDWxrLgy9xCjBAezkgjvo8aWICHelMTKqtSi/Pii0pzU4kOMTBycUg2MjSK79P0fTHz+zz4p
	V/PQyh23XrT/tD0l3P57+XzuOx/uHLwgMb3t9lohIfEVNZovp9hMXqyvavux8Wqd+rUuI+ML
	YR9tH4dVFGxZe2rJtcfZ/0Sa2FfEpHvZr2Gf8U498y1fmlb7gzfvFddEb6+7v1HpavGk373H
	nc8uiTP4dGLKjc1/mXcsZ1ZiKc5INNRiLipOBACBLtjakgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, 2013-11-13 at 11:50 +0000, Mark Rutland wrote:
> I see some of_* calls in the code, but no documentation of the binding.
> As this has more than just a compatible, interrupts, and reg, it needs
> its own binding document.
> 
> [...]
> 
> > +static struct mfd_cell max14577_devs[] = {
> > +       { .name = "max14577-muic",
> > +               .of_compatible = "maxim,max14577-muic", },
> 
> The compatible string looks fine to me, but should be documented.

Sure, I will add documentation.

> [...]
> 
> > +#ifdef CONFIG_OF
> > +static struct max14577_platform_data *max14577_i2c_parse_dt(struct device *dev)
> > +{
> > +       struct max14577_platform_data *pdata;
> > +       struct device_node *np = dev->of_node;
> > +
> > +       pdata = devm_kzalloc(dev, sizeof(struct max14577_platform_data),
> > +                            GFP_KERNEL);
> > +       if (!pdata)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       pdata->irq_gpio = of_get_named_gpio(np, "irq_gpio", 0);
> 
> In general, '-' is preferred to '_' in property names. This should be
> irq-gpio.

OK.


> What exactly is this used for? I know that others have strong opinions
> about how gpio/irq interaction should be handled.

Later also Mark Brown raised this. I'll leave this to discussion with
Kyungmin Park as I'm not entirely the author of the code.


> 
> > +       if (!gpio_is_valid(pdata->irq_gpio)) {
> > +               dev_err(dev, "Invalid irq_gpio in DT\n");
> > +               return ERR_PTR(-EINVAL);
> > +       }
> > +
> > +       if (of_property_read_bool(np, "wakeup"))
> > +               pdata->wakeup = true;
> 
> What does this mean? It seems like a remarkably generic name for
> something that I'd guess is _very_ specific to this particular binding.
> 
> It might be worth prefixing it, and is certainly worth having a more
> precise name.

It is used for marking device as wake up source. This is same code as in
other max drivers used on Exynos boards (max77693 and max77686).


Thanks for review,
Krzysztof

