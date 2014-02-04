Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaBDLgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:36:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46926 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaBDLgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:36:43 -0500
Date: Tue, 4 Feb 2014 12:36:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jenny TC <jenny.tc@intel.com>
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
Message-ID: <20140204113640.GD2450@amd.pavel.ucw.cz>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
 <1391490780-6141-4-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391490780-6141-4-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -22,6 +22,19 @@ config POWER_SUPPLY_CHARGER
>  	  drivers to keep the charging logic outside and the charger driver
>  	  just need to abstract the charger hardware.
>  
> +config POWER_SUPPLY_CHARGING_ALGO_PSE
> +	bool "PSE compliant charging algorithm"
> +	help
> +	  Say Y here to select Product Safety Engineering (PSE) compliant
> +	  charging algorithm. As per PSE standard the battery characteristics
> +	  and thereby the charging rates can vary on different temperature
> +	  zones. This config will enable PSE compliant charging algorithm with
> +	  maintenance charging support. At runtime the algorithm will be
> +	  selected by the psy charger driver based on the type of the battery
> +	  charging profile.

Information where to expect PSE compliant chargers would be nice.

> +static inline bool __is_battery_full
> +	(long volt, long cur, long iterm, unsigned long cv)
> +{

codingstyle.

> +	pr_devel("%s:current=%ld pse_mod_bprof->chrg_term_mA =%ld voltage_now=%ld full_cond=%ld",
> +			__func__, cur, iterm, volt * 100, (FULL_CV_MIN * cv));
> +
> +	return (cur > 0) && (cur <= iterm) &&
> +	((volt * 100)  >= (FULL_CV_MIN * cv));

Codingstyle. Just run checkpatch.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
