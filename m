Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbaAWHhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:37:10 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43788 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaAWHhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:37:06 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-bc-52e0c69f3900
Message-id: <1390462621.25714.5.camel@AMDC1943>
Subject: Re: [PATCH v2 2/2] regulator: s5m8767: Document new bindings for Buck9
 GPIO control
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Thu, 23 Jan 2014 08:37:01 +0100
In-reply-to: <20140122194927.GZ17314@sirena.org.uk>
References: <1390406848-20964-1-git-send-email-k.kozlowski@samsung.com>
 <1390406848-20964-3-git-send-email-k.kozlowski@samsung.com>
 <20140122194927.GZ17314@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t/xy7rzjz0IMjhzSMSi4WqIxcYZ61kt
	pj58wmYx/8g5Vov+NwtZLQ782cFoce7VSkaLs01v2C3ufz3KaPHtSgeTxcK2JSwWl3fNYbOY
	cX4fk8XaI3fZLZZev8hkMWH6WhaLdS+ns1i07j3CbnHyTy+jxeluVouLK74wOYh6rJm3htHj
	cl8vk8fOWXfZPVYu/8LmsWlVJ5vHq9UzWT3uXNvD5jHvZKBH35ZVjB6fN8kFcEVx2aSk5mSW
	pRbp2yVwZUx/upm94B5HxcmrfA2M/exdjJwcEgImEkvvdbJA2GISF+6tZ+ti5OIQEljKKPHy
	SQ+U85lR4vGjTcwgVbwC+hIPFl8B6xAWiJM4vPQMI4jNJmAssXn5EjYQW0RAWeLq970sIM3M
	Ah1sEt9mHgRrYBFQlZjeOwVsECdQw5eWiUwQG9YxSrS83QZ2E7OAusSkeYuYIW5Sktjd3gkV
	l5fYvOYt1BWCEj8m32OZwCgwC0nLLCRls5CULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yf
	u4kREqFfdjAuPmZ1iFGAg1GJhzfhy/0gIdbEsuLK3EOMEhzMSiK8/w48CBLiTUmsrEotyo8v
	Ks1JLT7EyMTBKdXAGNml/2er7K57mkdm+8y3aJz281tERddszUUf1xtJhXGd3lBqmux2a8n6
	r0wObffzX0zOTNwmnS37cUriDr1m5jLGwAUvX77+eeHGDOUWBvUE1g55Kx9Tyyk6U8PX3LvK
	cD9FT+pyN8eJiU5FPyvnZ4g7PJs/pU5vk9eBZ97eEfdv7D1XmvnKVomlOCPRUIu5qDgRAOez
	W1GuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 19:49 +0000, Mark Brown wrote:
> On Wed, Jan 22, 2014 at 05:07:28PM +0100, Krzysztof Kozlowski wrote:
> > Add documentation for new bindings for controlling (enable/disable) the
> > Buck9 Converter by GPIO (BUCK9EN).
> 
> Your CC list for this is *very* large...
Hmmm... The get_maintainers produces such long list for any change in
Documentation/devicetree/bindings... I'll stop using it for this.

> 
> > +	- s5m8767,pmic-ext-control-enable: regulator can be enabled/disabled
> > +		by GPIO (valid only for buck9).
> > +	- s5m8767,pmic-ext-control-gpio: GPIO specifier for one GPIO
> > +		controlling this regulator (valid only for buck9).
> > +		This property is required when 's5m8767,pmic-ext-control-enable' is specified.
> 
> In what situation might the GPIO be present but not usable - can't we
> just use the presence of the GPIO property?  Also GPIO properties are
> supposed to be always "-gpios".
Remove the "s5m8767,pmic-ext-control-enable" and use only
"s5m8767,pmic-ext-control-gpios"? Sure, that makes sense. Thanks for
idea.


Best regards,
Krzysztof

