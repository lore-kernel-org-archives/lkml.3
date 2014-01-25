Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaAYREM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 12:04:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39691 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaAYREJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 12:04:09 -0500
Date: Sat, 25 Jan 2014 18:04:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali Roh?r <pali.rohar@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rhyland Klein <rklein@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/4] power_supply: Introduce Generic Power Supply
 charging driver
Message-ID: <20140125170402.GA27959@Nokia-N900>
References: <1390411194-21410-1-git-send-email-jenny.tc@intel.com>
 <1390411194-21410-3-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390411194-21410-3-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The Power Supply charging driver connects multiple subsystems
> to do charging in a generic way. The subsystems involves power_supply,
> thermal and battery communication subsystems (1wire).
> With this the charging is handled in a generic way.

...do we really need copy of documentation file in changelog?

> +2. Reading Battery charging profile
> +===================================
> +
> +Power Supply charging driver expose sAPIs to retrieve battery profile of a

typo sAPI.

> +battery. The battery profile can be read by battery identification driver which
> +may be 1wire/I2C/SFI driver. Battery identification driver can register the
> +battery profile with the power supply charging driver using the API
> +psy_battery_prop_changed(). The driver also exposes API
> +psy_get_batt_prop() to retrieve the battery profile which can be

Please be consistent. _get_battery_pro_ ?

> +used by power supply drivers to setup the charging. Also drivers
> +can register for battery removal/insertion notifications using
> +power_supply_reg_notifier()

> +/* register with power_supply subsystem */
> +power_supply_registe(device, &psy_usb);

"r("
> +	* Read access using get_property_function
> +		* Returns the online property set using the set_property
> +		  function
> +	* Write access using set_property function
> +		* Expose the value through get_property_fucntion.

typo "function"

> +* POWER_SUPPLY_PROP_PRESENT
> +	* Read access using get_property_function
> +		* Returns the present property set using the set_property
> +		  function
> +	* Write access using set_property function
> +		* Expose the value through get_property_fucntion.

here too.

> +	* Write access using set_property
> +		* Set Maximum charging current
> +		* Action: Configure safety charging registers if any. If not no
> +			  actions expected for this.

Having property that does nothing sounds evil to me.

> +* POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGING
> +	* Write access using set_property
> +		* Enable/Disable charging. Charger supplies power to platform,
> +		  but charging is disabled

This is unclear. Charging is always disabled?

> +	* Write access using set_property
> +		* Reset charger Watch Dog Timer
> +		* Action: Reset charger Watch dog timer.

IntereSting caPitalization.

Also how do higher levels know how often to reset wdt?

> +3.4 Throttling data configuration
> +=============================
> +Power supply charging driver can take actions for Thermal throttling requests.
> +Power supply core sends event PSY_EVENT_THROTTLE  on power_supply_notifier
> +chain. Power supply charging driver handle this event and takes throttling
> +actions as in the throttling configuration structure. The throttling
> +configuration structure has the following format

missing :

> +Power supply charging driver process this event and takes actions to setup
> +charging

Missing .

> +Power supply charging driver supports pluggable charging algorithms. Charging
> +algorithms process charging profile and/or applies different logic (pulse

"processes".

> +	/* callback function to retreive battery thresholds */
> +	pse_algo.get_batt_thresholds = my_algo__get_bat_thresholds;

Too many __s.

> +config POWER_SUPPLY_CHARGER
> +	bool "Power Supply Charger"
> +	help
> +	  Say Y here to enable the power supply charging control driver. Charging
> +	  control supports charging in a generic way. This allows the charger
> +	  drivers to keep the charging logic outside and the charger driver
> +	  just need to abstract the charger hardware

Missing .

> +struct psy_event_node {
> +	struct list_head node;
> +	unsigned long event;
> +	struct psy_cable_props cap;
> +	struct power_supply *psy;
> +	struct psy_ps_batt_chg_prof batt_property;

Pls gt sm readable identfrs.

> +struct power_supply_charger_cxt {

ps_charger_context ?

						Pavel
