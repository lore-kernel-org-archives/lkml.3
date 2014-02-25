Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaBYLv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:51:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:44501 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaBYLvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:51:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,539,1389772800"; 
   d="scan'208";a="461870577"
Date: Tue, 25 Feb 2014 17:21:47 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Pavel Machek <pavel@ucw.cz>
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
Message-ID: <20140225115147.GB20856@jenny-desktop>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
 <1391490780-6141-5-git-send-email-jenny.tc@intel.com>
 <20140204113621.GB2450@amd.pavel.ucw.cz>
 <20140220050310.GA2498@jenny-desktop>
 <20140221144400.GA5238@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221144400.GA5238@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 03:44:00PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > +static inline int bq24261_set_cv(struct bq24261_charger *chip, int cv)
> > > > +{
> > > > +	int bat_volt;
> > > > +	int ret;
> > > > +	u8 reg_val;
> > > > +	u8 vindpm_val = 0x0;
> > > > +
> > > > +	/*
> > > > +	* Setting VINDPM value as per the battery voltage
> > > > +	*  VBatt           Vindpm     Register Setting
> > > > +	*  < 3.7v           4.2v       0x0 (default)
> > > > +	*  3.71v - 3.96v    4.36v      0x2
> > > > +	*  > 3.96v          4.6v       0x5
> > > > +	*/
> > > > +	ret = get_battery_voltage(&bat_volt);
> > > > +	if (ret) {
> > > > +		dev_err(&chip->client->dev,
> > > > +			"Error getting battery voltage!!\n");
> > > > +	} else {
> > > 
> > > You forget the error value and continue anyway.
> > 
> > On error, throw the error and program default VINDPM value.
> 
> Is it good idea to attempt charging when we can't read battery
> voltage?

This function decides the VINDPM setting and doesn't enable charging.
VINDPM setting is used to ensure minimum input voltage and thereby allow to
charge with low power charging source. If the voltage read fails, then the
default VINDPM value 0x0 will be programmed and the input voltage may go down
as low as 4.2V. The charging/not charging decision is taken by power supply
charger driver and not by the chip driver. The worst case impact would be that
charging may happen with a low charge current at high battery voltages,
but doesn't compromise safety at all. 

-Jenny
