Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab3KNIPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:15:43 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39502 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3KNIPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:15:41 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-25-528486ab98e0
Message-id: <1384416937.5901.6.camel@AMDC1943>
Subject: Re: [PATCH 1/4] mfd: max14577: Add max14577 MFD driver core
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Thu, 14 Nov 2013 09:15:37 +0100
In-reply-to: <20131113131328.GF878@sirena.org.uk>
References: <1384328457-5147-1-git-send-email-k.kozlowski@samsung.com>
 <1384328457-5147-2-git-send-email-k.kozlowski@samsung.com>
 <20131113131328.GF878@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xa7qr21qCDC7/YLI4uFXTYuOM9awW
	Ux8+YbO4/uU5q8X8I+dYLSaunMxsceDPDkaLs01v2C3ufz3KaPHtSgeTxeVdc9gs1h65y25x
	u3EFm8XhFQeYLE53szrweyz4fIXdY0L/J0aPnbPusntsXqHlsWlVJ5vHnWt72DzmnQz06Nuy
	itHj8ya5AM4oLpuU1JzMstQifbsErowrL/+xFPRJVbT+amFuYDwk0sXIwSEhYCLx61hxFyMn
	kCkmceHeerYuRi4OIYGljBKtz0+wgiSEBD4zSjRscwWxeQX0JDbte8EO0iss4CLxr7UAJMwm
	YCyxefkSNhBbREBZ4ur3vSwgc5gFNrBIfHv+jBEkwSKgKrF45mlGkF5OAUOJyQtiIHatYpRY
	eamTHaSGWUBdYtK8RcwQBylJ7G6HictLbF7zlhniBkGJH5PvsUxgFJiFpGUWkrJZSMoWMDKv
	YhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJqS87GBcfszrEKMDBqMTDW7CzOUiINbGsuDL3
	EKMEB7OSCO+jxpYgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyZYnMDt0j8Wa9Z6qsuuqzr7rYL
	ott4H7/xV3n7RXtCafCMiYIxU9hkSoMuT//kxqzM/P/X+hTXtHVP3cNLmL0l/jMXt265xHKs
	6t2p31k7xWOf5ZRwZwbt/W44q9/rzv3kr4f0PrRaSzqlFIcW3390S/ji2f3/o84Jy+Syp6fH
	apfkSVpZsSmxFGckGmoxFxUnAgCgEqwZhwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2013-11-13 at 13:13 +0000, Mark Brown wrote:
> On Wed, Nov 13, 2013 at 08:40:54AM +0100, Krzysztof Kozlowski wrote:
> 
> > +/**
> > + * After resuming from suspend it may happen that IRQ is signalled but
> > + * IRQ GPIO is not high. Also the interrupt registers won't have any data
> > + * (all of them equal to 0x00).
> > + *
> > + * In such case retry few times reading the interrupt registers.
> > + */
> > +#define IRQ_READ_REG_RETRY_CNT		5
> 
> What is the cause here?  This smells like an unreliable workaround for
> some other behaviour.  In general this all looks very like standard
> regmap code.
> 
> > +	for (i = 0; i < MAX14577_IRQ_REGS_NUM; i++) {
> > +		u8 mask_reg = max14577_mask_reg[i];
> > +
> > +		if (mask_reg == MAX14577_REG_INVALID ||
> > +				IS_ERR_OR_NULL(max14577->regmap))
> > +			continue;
> 
> Why would this code even be running if you don't have a register map?
> 
> > +		dev_info(max14577->dev, "Got interrupts [1:0x%02x, 2:0x%02x, 3:0x%02x]\n",
> > +			irq_reg[MAX14577_IRQ_INT1], irq_reg[MAX14577_IRQ_INT2],
> > +			irq_reg[MAX14577_IRQ_INT3]);
> 
> This is far too noisy, dev_dbg() at most.
> 
> > +		gpio_val = gpio_get_value(pdata->irq_gpio);
> > +
> > +		if (gpio_get_value(pdata->irq_gpio) == 0)
> > +			dev_warn(max14577->dev, "IRQ GPIO is not high, retry reading interrupt registers\n");
> > +	} while (gpio_val == 0 && --retry > 0);
> 
> This looks very strange...
> 
> > +	max14577->irq = gpio_to_irq(pdata->irq_gpio);
> > +	ret = gpio_request(pdata->irq_gpio, "max14577_irq");
> > +	if (ret) {
> > +		dev_err(max14577->dev, "Failed requesting GPIO %d: %d\n",
> > +				pdata->irq_gpio, ret);
> > +		goto err;
> > +	}
> > +	gpio_direction_input(pdata->irq_gpio);
> > +	gpio_free(pdata->irq_gpio);
> 
> This means the GPIO handling code that was present in the handling is
> broken, it's trying to use the GPIO after it was freed.
> 
> > +	ret = request_threaded_irq(max14577->irq, NULL, max14577_irq_thread,
> > +				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> > +				   "max14577-irq", max14577);
> 
> Are you *positive* this is a falling triggered IRQ?  All the code to do
> with spinning reading the GPIO state during handling makes it look like
> this is in fact an active low interrupt and a lot of the code in here is
> working around trying to handle that as the wrong kind of IRQ.
> 
> > +int max14577_bulk_write(struct regmap *map, u8 reg, u8 *buf, int count)
> > +{
> > +	return regmap_bulk_write(map, reg, buf, count);
> > +}
> > +EXPORT_SYMBOL_GPL(max14577_bulk_write);
> 
> Given that these are basically all trivial wrappers around regmap they
> probably ought to be static inlines in the header.
> 
> > +static struct max14577_platform_data *max14577_i2c_parse_dt(struct device *dev)
> > +{
> 
> There's no DT binding document?
> 
> > +const struct dev_pm_ops max14577_pm = {
> > +	.suspend = max14577_suspend,
> > +	.resume = max14577_resume,
> > +};
> 
> SET_SYSTEM_SLEEP_PM_OPS().
> 
> > +static int __init max14577_i2c_init(void)
> > +{
> > +	return i2c_add_driver(&max14577_i2c_driver);
> > +}
> > +subsys_initcall(max14577_i2c_init);
> 
> Why not module_i2c_driver?

Thanks for review. I'll the fix issues and send later new version of
patch.

Best regards,
Krzysztof

