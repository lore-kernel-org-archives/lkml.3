Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847AbaEGNXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:23:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34414 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461AbaEGNXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:23:49 -0400
Date: Wed, 7 May 2014 15:23:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jenny Tc <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org, dbaryshkov@gmail.com, cbouatmailru@gmail.com,
        anton.vorontsov@linaro.org, tony@atomide.com,
        linux-omap@vger.kernel.org
Subject: Re: [jenny.tc@intel.com: [RFC] power_supply: Introduce generic psy
 charging driver]
Message-ID: <20140507132347.GA21687@amd.pavel.ucw.cz>
References: <20140429062526.GA12879@jenny-desktop>
 <20140505124745.GC16461@amd.pavel.ucw.cz>
 <20140507084655.GA25243@jenny-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507084655.GA25243@jenny-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +#define PSY_MAX_CV(psy) \
> > > +		psy_get_ps_int_property(psy,\
> > > +			POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX)
> > > +#define PSY_VOLTAGE_NOW(psy) \
> > > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW)
> > > +#define PSY_VOLTAGE_OCV(psy) \
> > > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_VOLTAGE_OCV)
> > > +#define PSY_CURRENT_NOW(psy) \
> > > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_CURRENT_NOW)
> > > +#define PSY_STATUS(psy) \
> > > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_STATUS)
> > > +#define PSY_TEMPERATURE(psy) \
> > > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_TEMP)
> > > +#define PSY_BATTERY_TYPE(psy) \
> > > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_TECHNOLOGY)
> > > +#define PSY_ONLINE(psy) \
> > > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_ONLINE)
> > 
> > This looks like bad idea. Just opencode it.
> 
> This was to make it more readable, and avoids open codes in multiple places.
> Initially Anton had positive thoughts about this. Isn't it more readable with
> the macros?

Well... I'd expect PSY_ONLINE() macro to do something like (psy &
0x01), not call function. Yes, it is shorter, but IMO it is not
clearer.

But if Anton likes it...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
