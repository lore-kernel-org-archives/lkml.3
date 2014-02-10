Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaBJPGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:06:20 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50577 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaBJPGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:06:05 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-aa-52f8eadafc1c
Message-id: <1392044761.24553.2.camel@AMDC1943>
Subject: Re: [PATCH v2 14/15] charger: max14577: Configure battery-dependent
 settings from DTS
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Jenny Tc <jenny.tc@intel.com>
Date: Mon, 10 Feb 2014 16:06:01 +0100
In-reply-to: <20140210121405.GH22773@lee--X1>
References: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
 <1391767487-10017-15-git-send-email-k.kozlowski@samsung.com>
 <20140210121405.GH22773@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xq7q3Xv0IMvjcaWKxccZ6VoupD5+w
	WVz/8pzVYtKT98wWE1dOZrZY+7WH3eJs0xt2i/tfjzJabHp8jdXi8q45bBZrj9xlt7jduILN
	4nQ3qwOvx85Zd9k9Nq/Q8li85yWTx6ZVnWwed67tYfOYdzLQY/OSeo++LasYPT5vkgvgjOKy
	SUnNySxLLdK3S+DKOHr5L1vBfYGKt3dXMzcwHuXtYuTkkBAwkTh47yULhC0mceHeejYQW0hg
	KaNE8wTpLkYuIPszo8Svf8vZQRK8AvoSq/50ghUJCyRIbJt4BqyZTcBYYvPyJUBxDg4RARWJ
	c2/MQXqZBT4wS5x6OoMZpIZFQFXi+u3nYHM4BXQlWt/fZYRYsJJR4vi112BFzALqEpPmLWKG
	uEhJYnd7JztEXF5i85q3zBBHCEr8mHyPZQKjwCwkLbOQlM1CUraAkXkVo2hqaXJBcVJ6rpFe
	cWJucWleul5yfu4mRkgMfd3BuPSY1SFGAQ5GJR7eHX++BwmxJpYVV+YeYpTgYFYS4Z358keQ
	EG9KYmVValF+fFFpTmrxIUYmDk6pBsa+dK5jzeddfIrXnrqxMGmHROlT9qo1N9e5lf2yDpOU
	iZW8u2jF1qnrrkh8u6azmGXlFeldEdkmSTZn/qkofvj7PeT1lhTryW2Pr9q9WPOtLcjv3MlD
	2WvtGQ7obaiJvM1R3HnJ/5dDwNu4z0fW6guHff9kL1XwSsehqnc119ct5RFM85cmneNQYinO
	SDTUYi4qTgQAr/3JQ38CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 12:14 +0000, Lee Jones wrote:
> > Remove hard-coded values for:
> >  - Fast Charge current,
> >  - End Of Charge current,
> >  - Fast Charge timer,
> >  - Overvoltage Protection Threshold,
> >  - Battery Constant Voltage,
> > and use DTS to configure them. This allows using the max14577 charger
> > driver with different batteries.
> > 
> > Now the charger driver requires valid configuration data from DTS. In
> > case of wrong configuration data it fails during probe. Patch adds
> > of_compatible to the charger mfd cell in MFD driver core.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: Jenny Tc <jenny.tc@intel.com>
> > ---
> >  drivers/mfd/max14577.c               |    5 +-
> >  drivers/power/max14577_charger.c     |  234 +++++++++++++++++++++++++++++-----
> >  include/linux/mfd/max14577-private.h |   10 ++
> >  include/linux/mfd/max14577.h         |    8 ++
> >  4 files changed, 227 insertions(+), 30 deletions(-)
> 
> <snip>
> 
> > diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
> > index a8cd7de3526a..50cf70bec4d4 100644
> > --- a/include/linux/mfd/max14577-private.h
> > +++ b/include/linux/mfd/max14577-private.h
> > @@ -269,6 +269,16 @@ enum maxim_muic_charger_type {
> >  #define MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP	 25000U
> >  #define MAX77836_CHARGER_CURRENT_LIMIT_MAX		475000U
> >  
> > +/* MAX14577 charger End-Of-Charge current limits (as in MAXIM_CHGCTRL5 register), uA */
> 
> Too many chars. Didn't checkpatch.pl complain about this?

I'll fix this.
> 
> > +#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_MIN		50000U
> > +#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_STEP		10000U
> > +#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_MAX		200000U
> > +
> > +/* MAX14577/MAX77836 Battery Constant Voltage (as in MAXIM_CHGCTRL3
> > register), uV */
> 
> Same here

OK


