Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbaBUOoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:44:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52210 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaBUOoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:44:03 -0500
Date: Fri, 21 Feb 2014 15:44:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jenny Tc <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        freemangordon@abv.bg, linux-omap@vger.kernel.org
Subject: Re: [PATCH 4/4] power_supply: bq24261 charger driver
Message-ID: <20140221144400.GA5238@amd.pavel.ucw.cz>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
 <1391490780-6141-5-git-send-email-jenny.tc@intel.com>
 <20140204113621.GB2450@amd.pavel.ucw.cz>
 <20140220050310.GA2498@jenny-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220050310.GA2498@jenny-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +static inline int bq24261_set_cv(struct bq24261_charger *chip, int cv)
> > > +{
> > > +	int bat_volt;
> > > +	int ret;
> > > +	u8 reg_val;
> > > +	u8 vindpm_val = 0x0;
> > > +
> > > +	/*
> > > +	* Setting VINDPM value as per the battery voltage
> > > +	*  VBatt           Vindpm     Register Setting
> > > +	*  < 3.7v           4.2v       0x0 (default)
> > > +	*  3.71v - 3.96v    4.36v      0x2
> > > +	*  > 3.96v          4.6v       0x5
> > > +	*/
> > > +	ret = get_battery_voltage(&bat_volt);
> > > +	if (ret) {
> > > +		dev_err(&chip->client->dev,
> > > +			"Error getting battery voltage!!\n");
> > > +	} else {
> > 
> > You forget the error value and continue anyway.
> 
> On error, throw the error and program default VINDPM value.

Is it good idea to attempt charging when we can't read battery
voltage?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
