Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934914Ab3BTIJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:09:04 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41342 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934882Ab3BTIJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:09:02 -0500
X-AuditID: cbfee691-b7f556d000001a24-a3-5124849dbeba
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
 <002a01ce0f31$24e5fef0$6eb1fcd0$%han@samsung.com>
 <20130220073704.GE2648@core.coreip.homeip.net>
In-reply-to: <20130220073704.GE2648@core.coreip.homeip.net>
Subject: Re: [PATCH 05/11] mfd: twl6040: use devm_gpio_request_one() and
 devm_request_threaded_irq()
Date: Wed, 20 Feb 2013 17:09:01 +0900
Message-id: <000b01ce0f41$8a99a8e0$9fccfaa0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PPRbICIP8c6DESw6d7tOxxDuGEwABE7Cg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zY925LSqBBu1PZS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG5Jvr2QvmyFTcXLSVtYFxrlgXIyeHhICJxIz9v9ghbDGJC/fW
	s3UxcnEICSxjlNh08iATTNG5RQ0sEIlFjBJ3vv+CqprNJDHh5V8WkCo2ATWJL18OA43i4BAR
	MJSYsaYKJMwskCfxbVETG1zztbMHwdZxClhLrN70lhnEFhZIk9h/cTLYNhYBVYmFi1eD2bwC
	thKta/+zQNiCEj8m32OBGKolsX7ncSYIW15i8xqQORxAl6pLPPqrCxIWETCSWHF/NRtEiYjE
	vhfvGEFukBCYxy6x+cJtqF0CEt8mH2KB6JWV2HSAGeJhSYmDK26wTGCUmIVk8ywkm2ch2TwL
	yYoFjCyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MUJia+IOxvsHrA8xJgOtn8gsJZqcD4zN
	vJJ4Q2NjEzMTUxNzS1NzU9KElcR55S/JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpgFFrz
	n8FhQ4JUw6yMuVMUOFN9ZFb9K7/7Jlzs8puX9b1BJbvcq9clVB+bfVj/SZ5qwt/tCaLyyhGO
	vUdu7z238FhLyHH26znBXRdN7l1ne/Jepd7pXfsppSbvRzzRPHNOJK0S663lu3BtmZqUG7P7
	0ysuDxaqbPjox7gqdfU6vYqP27OnzjTarcRSnJFoqMVcVJwIAKz7/u/DAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO7cFpVAg603JSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxuSb69kL5shU3Fy0lbWB
	ca5YFyMnh4SAicS5RQ0sELaYxIV769m6GLk4hAQWMUrc+f4LypnNJDHh5V+wKjYBNYkvXw6z
	dzFycIgIGErMWFMFEmYWyJP4tqgJofna2YPsIAlOAWuJ1ZveMoPYwgJpEvsvTmYCsVkEVCUW
	Ll4NZvMK2Eq0rv3PAmELSvyYfI8FYqiWxPqdx5kgbHmJzWtA5nAAXaou8eivLkhYRMBIYsX9
	1WwQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNz
	NzGCI/eZ1A7GlQ0WhxgFOBiVeHg15isHCrEmlhVX5h5ilOBgVhLhbXZSCRTiTUmsrEotyo8v
	Ks1JLT7EmAz06ERmKdHkfGBSySuJNzQ2MTOyNDKzMDIxNydNWEmcl/HUkwAhgfTEktTs1NSC
	1CKYLUwcnFINjJ6+lxfql/1S/smpmxmRwLms3ObzEglJjqYDDimFkgc13F+dvZjy68ec3ff6
	WX/rvg16x/pt1+ntrZ67Z98yttHL8vp64S7bQVPVsFfbelLKFvNeCDiebTNHhM0oU+/ddkkJ
	ubrutD8sH36xPjijwb4oY6e0hOqdBc7famKD60O/XjWfwhQeqsRSnJFoqMVcVJwIANi5KoEg	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2013 4:37 PM, Dmitry Torokhov wrote:
> 
> Hi Jingoo,
> 
> On Wed, Feb 20, 2013 at 03:11:38PM +0900, Jingoo Han wrote:
> > Use devm_gpio_request_one() and devm_request_threaded_irq() to make
> > cleanup paths and  more simple.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/mfd/twl6040.c |   26 +++++++-------------------
> >  1 files changed, 7 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
> > index f361bf3..2d38512 100644
> > --- a/drivers/mfd/twl6040.c
> > +++ b/drivers/mfd/twl6040.c
> > @@ -586,8 +586,8 @@ static int twl6040_probe(struct i2c_client *client,
> >  		twl6040->audpwron = -EINVAL;
> >
> >  	if (gpio_is_valid(twl6040->audpwron)) {
> > -		ret = gpio_request_one(twl6040->audpwron, GPIOF_OUT_INIT_LOW,
> > -				       "audpwron");
> > +		ret = devm_gpio_request_one(twl6040->dev, twl6040->audpwron,
> > +					GPIOF_OUT_INIT_LOW, "audpwron");
> >  		if (ret)
> >  			goto gpio_err;
> >  	}
> > @@ -596,14 +596,14 @@ static int twl6040_probe(struct i2c_client *client,
> >  			IRQF_ONESHOT, 0, &twl6040_irq_chip,
> >  			&twl6040->irq_data);
> >  	if (ret < 0)
> > -		goto irq_init_err;
> > +		goto gpio_err;
> >
> >  	twl6040->irq_ready = regmap_irq_get_virq(twl6040->irq_data,
> >  					       TWL6040_IRQ_READY);
> >  	twl6040->irq_th = regmap_irq_get_virq(twl6040->irq_data,
> >  					       TWL6040_IRQ_TH);
> >
> > -	ret = request_threaded_irq(twl6040->irq_ready, NULL,
> > +	ret = devm_request_threaded_irq(twl6040->dev, twl6040->irq_ready, NULL,
> >  				   twl6040_readyint_handler, IRQF_ONESHOT,
> >  				   "twl6040_irq_ready", twl6040);
> >  	if (ret) {
> > @@ -611,12 +611,12 @@ static int twl6040_probe(struct i2c_client *client,
> >  		goto readyirq_err;
> >  	}
> >
> > -	ret = request_threaded_irq(twl6040->irq_th, NULL,
> > +	ret = devm_request_threaded_irq(twl6040->dev, twl6040->irq_th, NULL,
> >  				   twl6040_thint_handler, IRQF_ONESHOT,
> >  				   "twl6040_irq_th", twl6040);
> >  	if (ret) {
> >  		dev_err(twl6040->dev, "Thermal IRQ request failed: %d\n", ret);
> > -		goto thirq_err;
> > +		goto readyirq_err;
> >  	}
> >
> >  	/* dual-access registers controlled by I2C only */
> > @@ -676,19 +676,12 @@ static int twl6040_probe(struct i2c_client *client,
> >  	ret = mfd_add_devices(&client->dev, -1, twl6040->cells, children,
> >  			      NULL, 0, NULL);
> >  	if (ret)
> > -		goto mfd_err;
> > +		goto readyirq_err;
> >
> >  	return 0;
> >
> > -mfd_err:
> > -	free_irq(twl6040->irq_th, twl6040);
> > -thirq_err:
> > -	free_irq(twl6040->irq_ready, twl6040);
> >  readyirq_err:
> >  	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
> > -irq_init_err:
> > -	if (gpio_is_valid(twl6040->audpwron))
> > -		gpio_free(twl6040->audpwron);
> >  gpio_err:
> >  	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
> >  power_err:
> > @@ -706,11 +699,6 @@ static int twl6040_remove(struct i2c_client *client)
> >  	if (twl6040->power_count)
> >  		twl6040_power(twl6040, 0);
> >
> > -	if (gpio_is_valid(twl6040->audpwron))
> > -		gpio_free(twl6040->audpwron);
> > -
> > -	free_irq(twl6040->irq_ready, twl6040);
> > -	free_irq(twl6040->irq_th, twl6040);
> >  	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
> >
> >  	mfd_remove_devices(&client->dev);
> 
> Are you sure it is OK to have sub-devices removed and regmap destroyed
> with IRQs still active?

Yes, you're right. 
I will use devm_free_irq().

> 
> Thanks.
> 
> --
> Dmitry

