Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaDRHyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 03:54:49 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61645 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDRHyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:54:46 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-4f-5350da437869
Message-id: <1397807684.29800.8.camel@AMDC1943>
Subject: Re: [PATCH 1/2] mfd: sec-core: Remove duplicated device type from
 sec_pmic
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 18 Apr 2014 09:54:44 +0200
In-reply-to: <20140417082628.GG28725@lee--X1>
References: <1397477015-13900-1-git-send-email-k.kozlowski@samsung.com>
 <20140417082628.GG28725@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.8.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xa7rOtwKCDabu4LHYOGM9q8XZpjfs
	Fve/HmW0uLxrDpvF2iN32S1Od7NaXFzxhcmB3ePOtT1sHvNOBnr0bVnF6PF5k1wASxSXTUpq
	TmZZapG+XQJXxspLtQVXpSredf5nbWCcJNrFyMkhIWAicbppLxuELSZx4d56IJuLQ0hgKaPE
	hjenWCGcz4wST3q3s4NU8QroSzw9d48JxBYWCJVombsfLM4mYCyxefkSoG4ODhEBFYlzb8xB
	epkF/jFKLJl4lhmkhkVAVWLbvDawXk4BXYkfD7rAeoUEsiTmti1hBLGZBdQlJs1bxAxxkZLE
	uXVrGCH2Ckr8mHyPBaJGXmLzmrfMExgFZiFpmYWkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OL
	S/PS9ZLzczcxQsL6yw7GxcesDjEKcDAq8fBq/PAPFmJNLCuuzD3EKMHBrCTCq1waECzEm5JY
	WZValB9fVJqTWnyIkYmDU6qB0bd50xE+tk3VF/crf8+tCF4pv//abb+rTct3hZ3VTuvZVu7x
	5bHfMs9fRx93Rmmu+Mr1+4oIS4nY7qcREvUWe2/9L8pYetr2N8el8OS5jAszVWw9NOPLl024
	on3ItcdKavncCdPkVq/5cK6pNJGr77FX1/Ilaul+dy7kaCx0CT0j5fR0c2mMlhJLcUaioRZz
	UXEiACX83ZlJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-04-17 at 09:26 +0100, Lee Jones wrote:
> > The device type was stored in sec_pmic state container twice:
> >  - unsigned long type
> >  - int device_type
> 
> Can you explain that one of them is in the main container and the
> other is stored in pdata, which in turn is located in the main
> container, as this implies that both of them are located in the same
> place, which is not quite true.

Sure, I'll expand this section. However they were both stored in the
same place - struct sec_pmic. Additionally device_type is stored in
pdata.

> 
> > The 'type' field was never used outside of probe so it can be safely
> > removed.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/sec-core.c           | 5 +++--
> >  include/linux/mfd/samsung/core.h | 1 -
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> > index d4682c6cbff5..fccfd71f8abd 100644
> > --- a/drivers/mfd/sec-core.c
> > +++ b/drivers/mfd/sec-core.c
> > @@ -251,6 +251,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
> >  	struct sec_platform_data *pdata = dev_get_platdata(&i2c->dev);
> >  	const struct regmap_config *regmap;
> >  	struct sec_pmic_dev *sec_pmic;
> > +	unsigned long device_type;
> >  	int ret;
> >  
> >  	sec_pmic = devm_kzalloc(&i2c->dev, sizeof(struct sec_pmic_dev),
> > @@ -262,7 +263,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
> >  	sec_pmic->dev = &i2c->dev;
> >  	sec_pmic->i2c = i2c;
> >  	sec_pmic->irq = i2c->irq;
> > -	sec_pmic->type = sec_i2c_get_driver_data(i2c, id);
> > +	device_type = sec_i2c_get_driver_data(i2c, id);
> 
> Better to change the return type of 'sec_i2c_get_driver_data()' than
> to rely on a cast later on.

Hmmm... it was like that before Pankaj Dubey change (8f695de515b9).
Solving that issue (-Wpointer-to-int-cast) along with keeping 'int' as
return type of sec_i2c_get_driver_data would lead to one of:
1. Using temporary variable in ec_i2c_get_driver_data just for cast.

static inline int sec_i2c_get_driver_data(struct i2c_client *i2c,
						const struct i2c_device_id *id)
{
	unsigned long type;

	if (i2c->dev.of_node) {
		const struct of_device_id *match;
		match = of_match_node(sec_dt_match, i2c->dev.of_node);
		type = (unsigned long)match->data;
	}
	type = id->driver_data;

	return (int)type;
}

or
2. Double cast: (int)(unsigned long)match->data;

For me both are kind a ugly... What do you think?


> 
> >  	if (sec_pmic->dev->of_node) {
> >  		pdata = sec_pmic_i2c_parse_dt_pdata(sec_pmic->dev);
> > @@ -270,7 +271,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
> >  			ret = PTR_ERR(pdata);
> >  			return ret;
> >  		}
> > -		pdata->device_type = sec_pmic->type;
> > +		pdata->device_type = (int)device_type;
> >  	}
> >  	if (pdata) {
> >  		sec_pmic->device_type = pdata->device_type;
> > diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
> > index 84aaf6c25794..2633083262ea 100644
> > --- a/include/linux/mfd/samsung/core.h
> > +++ b/include/linux/mfd/samsung/core.h
> > @@ -49,7 +49,6 @@ struct sec_pmic_dev {
> >  	struct regmap_irq_chip_data *irq_data;
> >  
> >  	int ono;
> > -	unsigned long type;
> >  	bool wakeup;
> >  	bool wtsr_smpl;
> >  };
> > -- 
> > 1.8.3.2
> > 
> 

