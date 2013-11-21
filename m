Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab3KUKb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:31:56 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37239 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3KUKby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:31:54 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-33-528de1176431
Message-id: <1385029909.26695.5.camel@AMDC1943>
Subject: Re: [PATCH v2 1/5] mfd: max14577: Add max14577 MFD driver core
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
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Thu, 21 Nov 2013 11:31:49 +0100
In-reply-to: <20131120153103.GG2674@sirena.org.uk>
References: <1384956732-19526-1-git-send-email-k.kozlowski@samsung.com>
 <1384956732-19526-2-git-send-email-k.kozlowski@samsung.com>
 <20131120153103.GG2674@sirena.org.uk>
References: <1384956732-19526-1-git-send-email-k.kozlowski@samsung.com>
 <1384956732-19526-2-git-send-email-k.kozlowski@samsung.com>
 <20131120153103.GG2674@sirena.org.uk>
In-reply-to: <20131120153103.GG2674@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t/xy7riD3uDDH6sVrM4uFXTYuOM9awW
	Ux8+YbO4/uU5q8X8I+dYLSaunMxsceDPDkaLc69WMlqcbXrDbnH/61FGi29XOpgsNj2+xmqx
	sG0Ji8XlXXPYLNYeuctucbtxBZvFhOlrWSwOrzjAZLHu5XQWi9PdrBavDraxOIh6rJm3htFj
	wecr7B4T+j8xeuycdZfdY+XyL2wem1doeWxa1cnm8Wr1TFaPO9f2sHnMOxnosXlJvUffllWM
	Hp83yXlsnBsawBfFZZOSmpNZllqkb5fAlXFj72HWgs38FWf6FjM3ML7j7mLk5JAQMJGYuLOL
	GcIWk7hwbz1bFyMXh5DAUkaJrfN/QTmfGSUObZjECFLFK6AvcfniKzYQW1jAXeLdrB52EJtN
	wFhi8/IlYHERAWWJq9/3soA0Mwv0sknM2PgUrIhFQFVid9NJsEGcAkYSC+71QW1YyyhxY9tB
	VjQOsipOoFHqEpPmLYI6Vklid3snO0RcXmLzmrfMEOcJSvyYfI9lAqPQLCQts5CUzUJStoCR
	eRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSNx/3cG49JjVIUYBDkYlHt4HT3uChFgTy4or
	cw8xSnAwK4nwXrnaGyTEm5JYWZValB9fVJqTWnyIkYmDU6qBsTqUbddsAYO/zx/FhQvnHPr9
	XCt775FZVnudPjb4FqUYnFh890D7tOR5HB84g1WfWs79Nd1w+fdTQRJ78033t4UvUNz6OD7t
	zzzFrjPb5+qe9v7xwkv0bUn9fLYzvaYPPT2X8x/aMEP74srHq28+zHaJk2pmfnxcRp7hFefk
	LuZomzalKS0mp5RYijMSDbWYi4oTAQ7zRw/ZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-20 at 15:31 +0000, Mark Brown wrote:
> On Wed, Nov 20, 2013 at 03:12:08PM +0100, Krzysztof Kozlowski wrote:
> 
> > +static irqreturn_t max14577_irq_thread(int irq, void *data)
> > +{
> > +	struct max14577 *max14577 = data;
> > +	u8 irq_reg[MAX14577_IRQ_REGS_NUM] = {0};
> > +	u8 tmp_irq_reg[MAX14577_IRQ_REGS_NUM] = {};
> > +	int i, cur_irq;
> > +
> > +	max14577_bulk_read(max14577->regmap, MAX14577_REG_INT1,
> > +			&tmp_irq_reg[MAX14577_IRQ_INT1],
> > +			MAX14577_IRQ_REGS_NUM);
> 
> All this interrupt handling looks like a straight copy of the regmap
> code?

You are right, I will convert it to regmap_irq_chip.

> > +int max14577_irq_resume(struct max14577 *max14577)
> > +{
> > +	int ret = 0;
> > +
> > +	if (max14577->irq && max14577->irq_domain)
> > +		ret = max14577_irq_thread(0, max14577);
> 
> Are you sure that this is not going to race nastily if the interrupt
> goes off during resume?

I believe this code came from max77693. At least it looks very similar.
Also it seems it was a fast workaround for interrupt occurring during
device resume (before I2C bus resume). Handling this interrupt failed
and interrupt registers were not cleared.

This code is not needed now, especially after using regmap IRQ handling.

> 
> > +
> > +	return ret >= 0 ? 0 : ret;
> 
> This check isn't a triumph of legibility.  

OK.

> 
> > +	if (IS_ERR_OR_NULL(pdata)) {
> > +		dev_err(&i2c->dev, "No platform data found: %ld\n",
> > +				PTR_ERR(pdata));
> > +		return -EINVAL;
> > +	}
> 
> Why IS_ERR_OR_NULL().

Right, it should be just check for null.

> 
> > +#else
> > +#define max14577_suspend	NULL
> > +#define max14577_resume		NULL
> > +#endif /* CONFIG_PM */
> 
> You don't need these since you use SIMPLE_DEV_PM_OPS().

OK.

> 
> > +#else
> > +#define max14577_dt_match	NULL
> > +#endif
> 
> Similarly here.

OK.

Thanks for comments.

Best regards,
Krzysztof




