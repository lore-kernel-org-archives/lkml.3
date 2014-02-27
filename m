Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaB0Uql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:46:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55451 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaB0Uqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:46:39 -0500
Date: Thu, 27 Feb 2014 21:46:37 +0100
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
Subject: Re: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Message-ID: <20140227204636.GA5053@amd.pavel.ucw.cz>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
 <1391490780-6141-4-git-send-email-jenny.tc@intel.com>
 <20140204113640.GD2450@amd.pavel.ucw.cz>
 <20140220051655.GB2498@jenny-desktop>
 <20140221144529.GB5238@amd.pavel.ucw.cz>
 <20140226025444.GA21449@jenny-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226025444.GA21449@jenny-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-02-26 08:24:44, Jenny Tc wrote:
> On Fri, Feb 21, 2014 at 03:45:29PM +0100, Pavel Machek wrote:
> > On Thu 2014-02-20 10:46:55, Jenny Tc wrote:
> > > On Tue, Feb 04, 2014 at 12:36:40PM +0100, Pavel Machek wrote:
> > > > > --- a/drivers/power/Kconfig
> > > > > +++ b/drivers/power/Kconfig
> > > > > @@ -22,6 +22,19 @@ config POWER_SUPPLY_CHARGER
> > > > >  	  drivers to keep the charging logic outside and the charger driver
> > > > >  	  just need to abstract the charger hardware.
> > > > >  
> > > > > +config POWER_SUPPLY_CHARGING_ALGO_PSE
> > > > > +	bool "PSE compliant charging algorithm"
> > > > > +	help
> > > > > +	  Say Y here to select Product Safety Engineering (PSE) compliant
> > > > > +	  charging algorithm. As per PSE standard the battery characteristics
> > > > > +	  and thereby the charging rates can vary on different temperature
> > > > > +	  zones. This config will enable PSE compliant charging algorithm with
> > > > > +	  maintenance charging support. At runtime the algorithm will be
> > > > > +	  selected by the psy charger driver based on the type of the battery
> > > > > +	  charging profile.
> > > > 
> > > > Information where to expect PSE compliant chargers would be nice.
> > > 
> > > This algorithm can be used with non PSE compliant chargers also. This is a SW
> > > based charging algorithm.
> > 
> > Ok, but you need to explain for the users when it might be good idea
> > to select this option...
> > 
> > Or maybe this should not be user configurable and drivers should just
> > select it?
> 
> The idea is to allow pluggable charging algorithms. Currently we have only one
> charging algorithm proposed, but can have other charging algorithms (like pulse
> charging, rule based charging etc.). Based on the platform need, the algorithms
> can be selected. So this should be a user configurable option. I can add more
> explanation on when to select this option.

Yes please. Because with current description, user has no chance.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
