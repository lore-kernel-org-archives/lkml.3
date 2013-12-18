Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3LRO53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:57:29 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16846 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab3LRO5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:57:15 -0500
X-AuditID: cbfec7f4-b7fc96d000006cd4-0c-52b1b7c99c7a
Message-id: <1387378632.1433.4.camel@AMDC1943>
Subject: Re: [PATCH 4/5] regulator: s5m8767: Use GPIO for controlling Buck9/eMMC
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Wed, 18 Dec 2013 15:57:12 +0100
In-reply-to: <20131218134720.GU28455@sirena.org.uk>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
 <1387286601-21646-5-git-send-email-k.kozlowski@samsung.com>
 <20131218134720.GU28455@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t/xy7ont28MMmj/Y2rRcDXEYurDJ2wW
	84+cY7Xof7OQ1eLAnx2MFuderWS0ONv0ht3i/tejjBbfrnQwWSxsW8JicXnXHDaLtUfuslss
	vX6RyWLC9LUsFodXHGCyWPdyOovFyT+9jBanu1ktLq74wmRxbMYSRgcRjzXz1jB6LPh8hd3j
	cl8vk8fOWXfZPVYu/8LmsWlVJ5vHq9UzWT3uXNvD5jHvZKBH35ZVjB6fN8kFcEdx2aSk5mSW
	pRbp2yVwZTy/181W8IClYsLXjWwNjHeZuxg5OSQETCRmr2hhhbDFJC7cW88GYgsJLGWU+H9C
	uYuRC8j+zChxdHsfWIJXQE9i4t1FYM3CAgEST+5tBLPZBIwlNi9fAlYjIqAscfX7XhaQZmaB
	B6wS7ccugRWxCKhKzP51mh3E5gRq2PrmDBPEhnWMEgcPfgDrZhZQl5g0bxHUeUoSu9s72SHi
	8hKb17xlhrhCUOLH5HssExgFZiFpmYWkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLz
	czcxQiL0yw7GxcesDjEKcDAq8fAu8NkYJMSaWFZcmXuIUYKDWUmEV2grUIg3JbGyKrUoP76o
	NCe1+BAjEwenVANjuZb4zq4JYnoHxX2diwJKu16ULtn+XfnOyfe21kUNV/cGPVqbG3n59Rm1
	esk1ITyZQe+efH7vsPGG9L1ZKyyE7TsnrsopyHt9rOPl9ohDk+T/zNq53szu0a6L6fc5Hx/4
	P1nRX+lxnrj58umTH6jZ5nQy7l1Ra/9Yb99SCZYlradW/O3RkmW9osRSnJFoqMVcVJwIAH8Q
	TASuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 13:47 +0000, Mark Brown wrote:
> On Tue, Dec 17, 2013 at 02:23:20PM +0100, Krzysztof Kozlowski wrote:
> 
> > +static int s5m8767_reg_gpio_is_enabled(struct regulator_dev *rdev)
> > +{
> > +	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
> > +	int val;
> > +
> > +	if (!s5m8767->buck9_uses_gpio)
> > +		return s5m8767_reg_is_enabled(rdev);
> > +
> > +	val = gpio_get_value(s5m8767->buck9_gpio);
> > +
> > +	return val == 1;
> > +}
> 
> Don't open code this, use the core GPIO handling - see ena_gpio.

OK, I'll rewrite the patch.

Best regards,
Krzysztof

