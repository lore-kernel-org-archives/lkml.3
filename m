Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaJOMTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:19:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44965 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaJOMTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:19:31 -0400
Date: Wed, 15 Oct 2014 14:19:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
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
Subject: Re: [PATCH 2/8] power_supply: sysfs: Use power_supply_*() API for
 accessing function attrs
Message-ID: <20141015121929.GB26579@amd>
References: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
 <1413289246-31650-3-git-send-email-k.kozlowski@samsung.com>
 <20141015103217.GB14266@amd>
 <1413370199.26771.4.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413370199.26771.4.camel@AMDC1943>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > @@ -76,7 +76,7 @@ static ssize_t power_supply_show_property(struct device *dev,
> > >  	if (off == POWER_SUPPLY_PROP_TYPE) {
> > >  		value.intval = psy->type;
> > >  	} else {
> > > -		ret = psy->get_property(psy, off, &value);
> > > +		ret = power_supply_get_property(psy, off, &value);
> > >  
> > 
> > One thing.. Your power_supply_get_property (and friends) check for psy
> > == NULL. Is it neccessary / good idea? As far as I can tell, it should
> > not really be NULL...
> 
> It is not necessary. I thought it would be a good behavior of such
> exported function. You're right that this shouldn't be NULL especially
> because previously it was dereferenced.
> 
> Other existing power supply exported functions don't check this so maybe
> I shouldn't introduce inconsistency.
> 
> I'll remove the check and re-spin. I'll found ugly typos in commit
> message anyway.

Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
