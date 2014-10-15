Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaJOKuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:50:07 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23704 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaJOKuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:50:05 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-c3-543e51594afd
Content-transfer-encoding: 8BIT
Message-id: <1413370199.26771.4.camel@AMDC1943>
Subject: Re: [PATCH 2/8] power_supply: sysfs: Use power_supply_*() API for
 accessing function attrs
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 15 Oct 2014 12:49:59 +0200
In-reply-to: <20141015103217.GB14266@amd>
References: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
 <1413289246-31650-3-git-send-email-k.kozlowski@samsung.com>
 <20141015103217.GB14266@amd>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e/4Vd3IQLsQg+UtMhYHt2pabJyxntVi
	0pP3zBYTV05mtug8+4TZ4mzTG3aL+1+PMlpM+bOcyWLT42usFpd3zWGz+Nx7hNHiycIzTBZr
	j9xlt7jduILN4u6po2wWp7tZLU7vLnEQ9JjQ/4nRY+esu+wem1doeWxa1cnmcefaHjaPeScD
	PTYvqffY+b2B3aNvyypGjxWrv7N7fN4kF8AdxWWTkpqTWZZapG+XwJXxbuZ05oI/3BUv379m
	amC8wtnFyMkhIWAi0dB5nR3CFpO4cG89G4gtJLCUUWLmVD0Qm1dAUOLH5HssXYwcHMwC8hJH
	LmWDhJkF1CUmzVvE3MXIBVT+mVGi4Ws3I0S9vsTMOYfB5ggLpEoc71/DAmKzCRhLbF6+BCwu
	AjRna98KsGZmgS5WiZ1TloA1swioSjy/f5kZxOYU0JRY1AJyEMiGJYwSLxpmsINcISGgLNHY
	7zaBUWAWkvtmIdw3C8l9CxiZVzGKppYmFxQnpeca6hUn5haX5qXrJefnbmKExN2XHYyLj1kd
	YhTgYFTi4eU4YBsixJpYVlyZe4hRgoNZSYQ30d8uRIg3JbGyKrUoP76oNCe1+BAjEwenVANj
	/KmH9woc9bmucpyOMJfYMOmAVaH8yl9/ZTpv5Sj6HfpSdrDR2+zNWoPu9ZLvwxU8HzcmzRXT
	fXjNwLepfXnzxNBq/Yj18/ty3194nPLs3ZtI6aQl/57Oq7KzCrs2hT0+uMJnh9z+kDdubquW
	Ll90WfF98dkf/ZYWn95Yqa3m4mqIUGVsWztdiaU4I9FQi7moOBEAiUR9Q5kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-10-15 at 12:32 +0200, Pavel Machek wrote:
> On Tue 2014-10-14 14:20:40, Krzysztof Kozlowski wrote:
> > Replace direct calls to power supply function attributes with wrappers.
> > Wrappers provide safe access access in case of unregistering the power
> > supply (.e.g by removing the driver). Replace:
> >  - get_property -> power_supply_get_property
> >  - set_property -> power_supply_set_property
> >  - property_is_writeable -> power_supply_property_is_writeable
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks for looking at patches.


> > @@ -76,7 +76,7 @@ static ssize_t power_supply_show_property(struct device *dev,
> >  	if (off == POWER_SUPPLY_PROP_TYPE) {
> >  		value.intval = psy->type;
> >  	} else {
> > -		ret = psy->get_property(psy, off, &value);
> > +		ret = power_supply_get_property(psy, off, &value);
> >  
> 
> One thing.. Your power_supply_get_property (and friends) check for psy
> == NULL. Is it neccessary / good idea? As far as I can tell, it should
> not really be NULL...

It is not necessary. I thought it would be a good behavior of such
exported function. You're right that this shouldn't be NULL especially
because previously it was dereferenced.

Other existing power supply exported functions don't check this so maybe
I shouldn't introduce inconsistency.

I'll remove the check and re-spin. I'll found ugly typos in commit
message anyway.

Best regards,
Krzysztof


