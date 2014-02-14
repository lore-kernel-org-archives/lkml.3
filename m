Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaBNHrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:47:06 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27911 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaBNHrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:47:03 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-84-52fdc9f5e593
Message-id: <1392364019.29133.11.camel@AMDC1943>
Subject: Re: [PATCH v2 07/14] regulator: s2mps11: Copy supported regulators
 from initconst
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>
Date: Fri, 14 Feb 2014 08:46:59 +0100
In-reply-to: <20140213190730.GB28112@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-8-git-send-email-k.kozlowski@samsung.com>
 <20140213190730.GB28112@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/xy7pfT/4NMmiYwm6xccZ6VoupD5+w
	WVz/8pzV4mzTG3aL+1+PMlp8u9LBZHF51xw2ixnn9zFZrD1yl93idDerxcUVX5gs5v5uZHXg
	8dg56y67x6ZVnWwed67tYfOYdzLQo2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDJ272xgKzjI
	UdF6dQljA+MVti5GTg4JAROJT02rmSBsMYkL99YDxbk4hASWMkpM6pnACuF8ZpTYvPkTSxcj
	OwevgIFEqxtIvbBAjMT5F7NYQWw2AWOJzcuXgM0UEVCWuPp9LwtIK7PAIWaJ778PsIMkWARU
	JVbP28sMYnMCNezdsZsdYv46oGVtU8CuYBZQl5g0bxEzxEVKErvbO9kh4vISm9e8BYvzCghK
	/Jh8j2UCo8AsJC2zkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIfHzZwbj4
	mNUhRgEORiUe3g93/wQJsSaWFVfmHmKU4GBWEuF13/83SIg3JbGyKrUoP76oNCe1+BAjEwen
	VAOjLQODKNPGkGUvfA9W/9E5cl3OZfqauoPWXPOei4hxy5lqfrx+QOK9/VlBhpD6E/73a7zS
	Gv/ZnfCbI+r6dk/b0+7mqZ2cpjHz9PoEzxilH27+Ubcn9VhTw5JtQm62LTpi1utqaiuKJKt/
	it9VPfbSP7l57qOLX1Ja47lttruI7GDqMj+y9roSS3FGoqEWc1FxIgA2qbHFbQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-13 at 19:07 +0000, Mark Brown wrote:
> On Thu, Feb 13, 2014 at 10:14:00AM +0100, Krzysztof Kozlowski wrote:
> 
> > -	for (i = 0; i < S2MPS11_REGULATOR_CNT; i++)
> > +	s2mps11->rdev = devm_kzalloc(&pdev->dev,
> > +			sizeof(*s2mps11->rdev)*rdev_num, GFP_KERNEL);
> > +	if (!s2mps11->rdev)
> > +		return -ENOMEM;
> 
> If we're using managed allocations do we actually need to keep the rdev
> table at all?  We only normally use it to free.

You're right, the "s2mps11->rdev" is not needed at all.

> 
> > +	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata)*rdev_num, GFP_KERNEL);
> > +	if (!rdata)
> > +		return -ENOMEM;
> > +
> 
> > +	/* rdata was needed only for of_regulator_match() during probe */
> > +	if (rdata)
> > +		devm_kfree(&pdev->dev, rdata);
> > +
> 
> If this is always going to be freed within the probe path (in the same
> function indeed) why is it a managed allocaton at all?

Actually no good reason, simplifies a little the return statements on
error conditions. I'll use kzalloc() and kfree().

Best regards,
Krzysztof

