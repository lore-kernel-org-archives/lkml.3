Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaCGUJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:09:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49319 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaCGUJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:09:51 -0500
Date: Fri, 7 Mar 2014 21:09:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jenny Tc <jenny.tc@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
Message-ID: <20140307200949.GA27645@amd.pavel.ucw.cz>
References: <1392875640-29230-1-git-send-email-jenny.tc@intel.com>
 <1392875640-29230-3-git-send-email-jenny.tc@intel.com>
 <CACRpkdaU44iinj2iDNdYm62J+4jQbg+XJ=Zq4GmJryPeu7GfTQ@mail.gmail.com>
 <20140228042753.GC27921@jenny-desktop>
 <CACRpkdbuCC=-aYmyeaGW0GfkhRU8SEc=1+2f6k3tA7TygiZRJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbuCC=-aYmyeaGW0GfkhRU8SEc=1+2f6k3tA7TygiZRJA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > +++ b/include/linux/power/power_supply_charger.h
> >>
> >> > +#define MAX_CUR_VOLT_SAMPLES 3
> >> > +#define DEF_CUR_VOLT_SAMPLE_JIFF (30*HZ)
> >>
> >> Why are things defined in Jiffies like this insead of seconds, milliseconds
> >> etc? This will vary with the current operating frequency of the system,
> >> why should physical measurements do that?
> >
> > Is it fine if I use msecs_to_jiffies(30000)?
> 
> Keep the
> #define DEF_CUR_VOLT_SAMPLE_PERIOD 30000
> 
> Then use msecs_to_jiffies(DEF_CUR_VOLT_SAMPLE_PERIOD)
> in the call site.

Actually, I do not think this is good suggestion. 30*HZ -- is pretty
clearly 30 seconds. 30000 may be 30sec or 30msec ... hard to tell.

If the constant is used in just one place, maybe you don't need the
define?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
