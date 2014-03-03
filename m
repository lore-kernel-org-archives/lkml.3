Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaCCDLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 22:11:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:27971 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbaCCDLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 22:11:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,575,1389772800"; 
   d="scan'208";a="484583456"
Date: Mon, 3 Mar 2014 08:41:37 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Walleij <linus.walleij@linaro.org>,
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
Subject: Re: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Message-ID: <20140303031137.GA1132@jenny-desktop>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
 <1391490780-6141-4-git-send-email-jenny.tc@intel.com>
 <CACRpkdbppewuSSJu=Y=1T7oOCxz_ynhNspyPT=S894KoUB6H6g@mail.gmail.com>
 <20140228030727.GB27921@jenny-desktop>
 <20140228100816.GA13406@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228100816.GA13406@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 11:08:16AM +0100, Pavel Machek wrote:
> On Fri 2014-02-28 08:37:27, Jenny Tc wrote:
> > On Thu, Feb 27, 2014 at 09:18:57PM +0100, Linus Walleij wrote:
> > > On Tue, Feb 4, 2014 at 6:12 AM, Jenny TC <jenny.tc@intel.com> wrote:
> > > 
> > > > +static inline bool __is_battery_full
> > > > +       (long volt, long cur, long iterm, unsigned long cv)
> > > 
> > > Overall I wonder if you've run checkpatch on these patches, but why
> > > are you naming this one function with a double __underscore?
> > > Just is_battery_full_check() or something would work fine I guess?
> > 
> > Just to convey that is_battery_full is a local function and not generic. You
> > can find similar usage in power_supply_core.c (__power_supply_changed_work)
> > and in other drivers. Isn't it advised to have __ prefixes?
> 
> It is static; everybody sees it is local. __ prefix usually means
> something else.

Agreed, I will remove the __ prefix in next patchset. Meanwhile I would
appreciate if anyone could help me to understand what __ prefix really means.

> > > > +       u16 capacity;   /* mAh */
> > > > +       u16 voltage_max; /* mV */
> > > > +       /* charge termination current */
> > > > +       u16 chrg_term_mA;
> > > > +       /* Low battery level voltage */
> > > > +       u16 low_batt_mV;
> > > > +       /* upper and lower temperature limits on discharging */
> > > > +       s8 disch_temp_ul; /* Degree Celsius */
> > > > +       s8 disch_temp_ll; /* Degree Celsius */
> > > > +       /* number of temperature monitoring ranges */
> > > > +       u16 temp_mon_ranges;
> > > > +       struct psy_ps_temp_chg_table temp_mon_range[BATT_TEMP_NR_RNG];
> > > > +       /* lowest temperature supported */
> > > > +       s8 temp_low_lim;
> > > > +} __packed;
> > > 
> > > Why packed, and convert to kerneldoc for this struct.
> > 
> > Battery charging profile, may come from EEPROM/emmc which would be packed.
> 
> Do you need to do endianness conversion, too?

May/may not depending on the stored format. If needed, the endianess conversion
should be done at driver level where the EEPROM/emmc reading happens.
