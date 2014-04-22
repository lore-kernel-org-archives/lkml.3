Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaDVIJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:09:50 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50530 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaDVIJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:09:45 -0400
Date: Tue, 22 Apr 2014 09:09:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/2] mfd: sec-core: Remove duplicated device type from
 sec_pmic
Message-ID: <20140422080939.GE17657@lee--X1>
References: <1397477015-13900-1-git-send-email-k.kozlowski@samsung.com>
 <20140417082628.GG28725@lee--X1>
 <1397807684.29800.8.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397807684.29800.8.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +	unsigned long device_type;
> > >  	int ret;
> > >  
> > >  	sec_pmic = devm_kzalloc(&i2c->dev, sizeof(struct sec_pmic_dev),
> > > @@ -262,7 +263,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
> > >  	sec_pmic->dev = &i2c->dev;
> > >  	sec_pmic->i2c = i2c;
> > >  	sec_pmic->irq = i2c->irq;
> > > -	sec_pmic->type = sec_i2c_get_driver_data(i2c, id);
> > > +	device_type = sec_i2c_get_driver_data(i2c, id);
> > 
> > Better to change the return type of 'sec_i2c_get_driver_data()' than
> > to rely on a cast later on.
> 
> Hmmm... it was like that before Pankaj Dubey change (8f695de515b9).
> Solving that issue (-Wpointer-to-int-cast) along with keeping 'int' as
> return type of sec_i2c_get_driver_data would lead to one of:
> 1. Using temporary variable in ec_i2c_get_driver_data just for cast.
> 
> static inline int sec_i2c_get_driver_data(struct i2c_client *i2c,
> 						const struct i2c_device_id *id)
> {
> 	unsigned long type;
> 
> 	if (i2c->dev.of_node) {
> 		const struct of_device_id *match;
> 		match = of_match_node(sec_dt_match, i2c->dev.of_node);
> 		type = (unsigned long)match->data;
> 	}
> 	type = id->driver_data;
> 
> 	return (int)type;
> }
> 
> or
> 2. Double cast: (int)(unsigned long)match->data;
> 
> For me both are kind a ugly... What do you think?

I'm saying, why don't you change everything; the return value of
sec_i2c_get_driver_data(), pdata->device_type and device_type to long
or unsigned long? Then the only cast you need to do is from void*.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
