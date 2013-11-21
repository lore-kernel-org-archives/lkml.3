Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3KULnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:43:25 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12147 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3KULnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:43:23 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-d3-528df1d82e4f
Message-id: <1385034199.748.21.camel@AMDC1943>
Subject: Re: [PATCH v2 1/5] mfd: max14577: Add max14577 MFD driver core
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
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
Date: Thu, 21 Nov 2013 12:43:19 +0100
In-reply-to: <20131121103408.GA22536@lee--X1>
References: <1384956732-19526-1-git-send-email-k.kozlowski@samsung.com>
 <1384956732-19526-2-git-send-email-k.kozlowski@samsung.com>
 <20131121103408.GA22536@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t/xK7o3PvYGGZx6ZmZxcKumxcYZ61kt
	pj58wmZx/ctzVov5R86xWkxcOZnZ4sCfHYwW516tZLQ42/SG3eL+16OMFt+udDBZbHp8jdVi
	YdsSFovLu+awWaw9cpfd4nbjCjaLCdPXslgcXnGAyWLdy+ksFqe7WS1eHWxjcRD1WDNvDaPH
	gs9X2D0m9H9i9Ng56y67x8rlX9g8Nq/Q8ti0qpPN49Xqmawed67tYfOYdzLQY/OSeo++LasY
	PT5vkvPYODc0gC+KyyYlNSezLLVI3y6BK2PW1NOsBZvtKq48/s7YwDhLv4uRk0NCwETix8V/
	bBC2mMSFe+uBbC4OIYGljBJ9i69COZ8ZJT5dfcgMUsUroCdx78hkMFtYwF3i3awedhCbTcBY
	YvPyJUANHBwiAioS596Yg/QyC/SwSfQ/2cQKUsMioCpx+NNUdpAaTgFdiYsrUiDmr2CUaLza
	DTaTWUBdYtK8RcwQFylJ7G7vZIeIy0tsXvMW6gZBiR+T77FMYBSYhaRlFpKyWUjKFjAyr2IU
	TS1NLihOSs810itOzC0uzUvXS87P3cQIieCvOxiXHrM6xCjAwajEw/vgaU+QEGtiWXFl7iFG
	CQ5mJRHeV897g4R4UxIrq1KL8uOLSnNSiw8xMnFwSjUwOs0x/ePjEFK21frNk5Drhici9z7f
	cDuZZ4ufrqdZRcOPf094uY5ypPZ7ys/S//uqp2futSOV2us+yXeWr3i6sVm+YWpClpdx2qzt
	c7gFLnfF7WqV9JlxfNN/1e39/l76CvfFrfZ/XVWs+OnI3VXss3OvpofuXJzudjx96tMdoiZ/
	d53sKa2brcRSnJFoqMVcVJwIAFX/bMG+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-21 at 10:34 +0000, Lee Jones wrote:
> <snip>
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
> Where is this used?
> 
> <snip>
> 
> > +#define DECLARE_IRQ(idx, _group, _mask)		\
> > +	[(idx)] = { .group = (_group), .mask = (_mask) }
> 
> I'm pretty sure the parentheses are supurfluous.
> 
> > +static const inline struct max14577_irq_data *
> > irq_to_max14577_irq(struct max14577 *max14577, int irq)
> 
> We should tab this back out.
> 
> > +{
> > +	struct irq_data *data = irq_get_irq_data(irq);
> > +	return &max14577_irqs[data->hwirq];
> 
> Shouldn't you be using irq_create_mapping() or irq_find_mapping() here?
> 
> > +static void max14577_irq_mask(struct irq_data *data)
> > +{
> > +	struct max14577 *max14577 = irq_get_chip_data(data->irq);
> 
>                                     irq_data_get_irq_chip_data(data); ?
> 
> > +	const struct max14577_irq_data *irq_data =
> > +	    irq_to_max14577_irq(max14577, data->irq);
> > +
> > +	if (!irq_data)
> > +		return;
> > +
> > +	if (irq_data->group >= MAX14577_IRQ_REGS_NUM)
> > +		return;
> > +
> > +	max14577->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
> > +}
> 
> <snip>
> 
> > +int max14577_irq_resume(struct max14577 *max14577)
> > +{
> > +	int ret = 0;
> > +
> > +	if (max14577->irq && max14577->irq_domain)
> > +		ret = max14577_irq_thread(0, max14577);
> > +
> > +	return ret >= 0 ? 0 : ret;
> 
> Please open this out to something more easily comprehensible.

Thanks for pointing these out however after using regmap_irq_chip whole
file won't be needed anymore.

(...)

> > +static int max14577_i2c_probe(struct i2c_client *i2c,
> > +			      const struct i2c_device_id *id)
> > +{
> > +	struct max14577 *max14577;
> > +	struct max14577_platform_data *pdata = dev_get_platdata(&i2c->dev);
> > +	u8 reg_data;
> > +	int ret = 0;
> > +
> > +	if (i2c->dev.of_node) {
> 
> Can you pull this out. It looks neater as the top as:
>   struct device_node *np = i2c->dev.of_node;

I am not sure if I understand you correctly. You would like to change
this to:
-------------------------
static int max14577_i2c_probe(struct i2c_client *i2c,
                              const struct i2c_device_id *id)
{
        struct max14577 *max14577;
        struct max14577_platform_data *pdata =
dev_get_platdata(&i2c->dev);
        struct device_node *np = i2c->dev.of_node;
        u8 reg_data;
        int ret = 0;

        if (np) {
                pdata = devm_kzalloc(&i2c->dev,
                                sizeof(struct max14577_platform_data),
                                GFP_KERNEL);
-------------------------
The variable 'np' would be used only once.


> 
> > +		pdata = devm_kzalloc(&i2c->dev,
> > +				sizeof(struct max14577_platform_data),
> 
> I prefer:
>   sizeof(*pdata),

OK. Line will be shorter. I will change this patter also in other
places.

> 
> > +				GFP_KERNEL);
> > +		if (!pdata)
> > +			return -ENOMEM;
> > +		i2c->dev.platform_data = pdata;
> > +	}
> > +
> > +	if (IS_ERR_OR_NULL(pdata)) {
> 
> It's not likely to be an ERR, just do:
>  if (!pdata) {

OK.


> > +		dev_err(&i2c->dev, "No platform data found: %ld\n",
> > +				PTR_ERR(pdata));
> > +		return -EINVAL;
> > +	}
> > +
> > +	max14577 = devm_kzalloc(&i2c->dev, sizeof(struct max14577), GFP_KERNEL);
> > +	if (!max14577)
> > +		return -ENOMEM;
> > +
> > +	i2c_set_clientdata(i2c, max14577);
> > +	max14577->pdata = pdata;
> 
> How many different places do you want to store this?
> 
> > +	max14577->dev = &i2c->dev;
> 
> You're storing dev here anyway.
> 
> Remove the pdata property and get it from dev when/if you require it.

OK.


> > +	max14577->i2c = i2c;
> > +	max14577->irq = i2c->irq;
> > +
> > +	max14577->regmap = devm_regmap_init_i2c(i2c, &max14577_regmap_config);
> > +	if (IS_ERR(max14577->regmap)) {
> > +		ret = PTR_ERR(max14577->regmap);
> > +		dev_err(max14577->dev, "Failed to allocate register map: %d\n",
> > +				ret);
> > +		return ret;
> > +	}
> > +
> > +	ret = max14577_read_reg(max14577->regmap, MAX14577_REG_DEVICEID,
> > +			&reg_data);
> > +	if (ret) {
> > +		dev_err(max14577->dev, "Device not found on this channel: %d\n",
> > +				ret);
> > +		return ret;
> > +	}
> > +	max14577->vendor_id = (reg_data & 0x7);
> > +	max14577->device_id = ((reg_data & 0xF8) >> 0x3);
> > +	dev_info(max14577->dev, "Device ID: 0x%x, vendor: 0x%x\n",
> > +			max14577->device_id, max14577->vendor_id);
> > +
> > +	ret = max14577_irq_init(max14577);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = mfd_add_devices(max14577->dev, -1, max14577_devs,
> > +			ARRAY_SIZE(max14577_devs), NULL, 0, NULL);
> 
> You should be passing the irqdomain as the final parameter here.

I replaced the IRQ handling with regmap_irq_chip so this would look like
this:
-------------------------
        ret = mfd_add_devices(max14577->dev, -1, max14577_devs,
                        ARRAY_SIZE(max14577_devs), NULL, 0,
                        regmap_irq_get_domain(max14577->irq_data));
-------------------------
Am I correct?


> > +	if (ret < 0)
> > +		goto err_mfd;
> > +
> > +	device_init_wakeup(max14577->dev, 1);
> > +
> > +	return 0;
> > +
> > +err_mfd:
> > +	max14577_irq_exit(max14577);
> > +	return ret;
> > +}
> > +
> > +static int max14577_i2c_remove(struct i2c_client *i2c)
> > +{
> > +	struct max14577 *max14577 = i2c_get_clientdata(i2c);
> > +
> > +	mfd_remove_devices(max14577->dev);
> > +	max14577_irq_exit(max14577);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct i2c_device_id max14577_i2c_id[] = {
> > +	{ MAX14577_MFD_DEV_NAME, 0 },
> 
> Can you use the proper name here, these types of defines are pretty ugly.

OK.

> <snip>
> 
> > +#ifdef CONFIG_OF
> > +static struct of_device_id max14577_dt_match[] = {
> > +	{ .compatible = "maxim,max14577", },
> > +	{},
> > +};
> > +#else
> > +#define max14577_dt_match	NULL
> > +#endif
> 
> You don't need to do this and use of_match_ptr().
> 
> Remove the #ifdef.

Yes, Mark also pointed this.

> 
> > +static SIMPLE_DEV_PM_OPS(max14577_pm, max14577_suspend, max14577_resume);
> > +
> > +static struct i2c_driver max14577_i2c_driver = {
> > +	.driver = {
> > +		.name = MAX14577_MFD_DEV_NAME,
> 
> Can you use the proper name here, these types of defines are pretty ugly.

OK.

> 
> > +		.owner = THIS_MODULE,
> > +		.pm = &max14577_pm,
> > +		.of_match_table = of_match_ptr(max14577_dt_match),
> > +	},
> > +	.probe = max14577_i2c_probe,
> > +	.remove = max14577_i2c_remove,
> > +	.id_table = max14577_i2c_id,
> > +};
> 
> >>>>>>>>>>>>>>>>>>>>>>
> 
> > +static int __init max14577_i2c_init(void)
> > +{
> > +	return i2c_add_driver(&max14577_i2c_driver);
> > +}
> > +subsys_initcall(max14577_i2c_init);
> > +
> > +static void __exit max14577_i2c_exit(void)
> > +{
> > +	i2c_del_driver(&max14577_i2c_driver);
> > +}
> > +module_exit(max14577_i2c_exit);
> 
> >>>>>>>>>>>>>>>>>>>>>>
> 
> Remove all this and replace with:
>   module_i2c_driver(max14577_i2c_driver);

The subsys_initcall is needed. Marek Szyprowski replied to this here:
http://thread.gmane.org/gmane.linux.drivers.devicetree/51903/focus=1594651


(...)

> > +struct max14577_regulator_platform_data {
> > +	int id;
> > +	struct regulator_init_data *initdata;
> > +	struct device_node *of_node;
> 
> Do you ever set this? What's the point of it is it's set in the device?

Do you mean the whole struct max14577_regulator_platform_data or only
some member of it (of_node?)?

Best regards,
Krzysztof


