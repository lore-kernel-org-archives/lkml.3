Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaBQKlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:41:04 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52602 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaBQKlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:41:02 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-48-5301e73b44aa
Message-id: <1392633657.11078.4.camel@AMDC1943>
Subject: Re: [PATCH v3 14/15] charger: max14577: Configure battery-dependent
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
        Tomasz Figa <t.figa@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Jenny Tc <jenny.tc@intel.com>
Date: Mon, 17 Feb 2014 11:40:57 +0100
In-reply-to: <20140217100735.GA20218@lee--X1>
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
 <1392627950-26927-15-git-send-email-k.kozlowski@samsung.com>
 <20140217100735.GA20218@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xK7rWzxmDDbp+illsnLGe1WLqwyds
	Fte/PGe1mPTkPbPFxJWTmS3Wfu1htzjb9Ibd4v7Xo4wWmx5fY7W4vGsOm8XaI3fZLW43rmCz
	ON3NarF+xmsWBz6PnbPusntsXqHlsXjPSyaPTas62TzuXNvD5jHvZKDH5iX1Hn1bVjF6fN4k
	F8AZxWWTkpqTWZZapG+XwJXR9ayVuWANd8WOGdfYGxifcHQxcnJICJhI7OxdyQJhi0lcuLee
	rYuRi0NIYCmjxImzR9ghnM+MEjtWrgKr4hXQlzi/fRobiC0skCDx5+IvMJtNwFhi8/IlQDYH
	h4iAisS5N+YgvcwCk1gk3s6dD1bDIqAq0dK+mhXE5hTQlXjc9gJqwUpGiXV96xhBEswC6hKT
	5i1ihjhJSWJ3eyc7RFxeYvOat8wQRwhK/Jh8j2UCo8AsJC2zkJTNQlK2gJF5FaNoamlyQXFS
	eq6hXnFibnFpXrpecn7uJkZIPH3Zwbj4mNUhRgEORiUeXoNqxmAh1sSy4srcQ4wSHMxKIrx/
	HwKFeFMSK6tSi/Lji0pzUosPMTJxcEo1MM5cmazCvqPq5N1Dao1aa+e6aXk0HGO0udKyfesi
	66c5vLdXsqnEGIQlbjsw0d4moFkkIOTYviPFBmWNXPLzfr5e8TVKS/jp/P35YhunTPwoOdsx
	x6zhkmTZ0U95RybLlZbMYp2/+MT/Sz3ZjwtXGW/g5+fXmrbloIzc8fAbrfWqK7bcviwwlV2J
	pTgj0VCLuag4EQCMJqa3hQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 10:07 +0000, Lee Jones wrote:
> > diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
> > index a8cd7de3526a..fc69d7beb1aa 100644
> > --- a/include/linux/mfd/max14577-private.h
> > +++ b/include/linux/mfd/max14577-private.h
> > @@ -269,6 +269,20 @@ enum maxim_muic_charger_type {
> >  #define MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP	 25000U
> >  #define MAX77836_CHARGER_CURRENT_LIMIT_MAX		475000U
> >  
> > +/* MAX14577 charger End-Of-Charge current limits
> > + * (as in MAXIM_CHGCTRL5 register), uA
> > + */
> > +#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_MIN		50000U
> > +#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_STEP		10000U
> > +#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_MAX		200000U
> > +
> > +/* MAX14577/MAX77836 Battery Constant Voltage
> > + * (as in MAXIM_CHGCTRL3 register), uV
> > + */
> 
> These are not proper multi-line comments.
> 
> Documentation/CodingSytle:
> 
>  The preferred style for long (multi-line) comments is:
>  
>          /*
>           * This is the preferred style for multi-line
>           * comments in the Linux kernel source code.
>           * Please use it consistently.
>           *
>           * Description:  A column of asterisks on the left side,
>           * with beginning and ending almost-blank lines.
>           */

Sure. Sorry for bugging with such trivial mistakes.

Best regards,
Krzysztof

