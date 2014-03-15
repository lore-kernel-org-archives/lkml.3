Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaCOQFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 12:05:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33329 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbaCOQFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 12:05:47 -0400
Date: Sat, 15 Mar 2014 17:05:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.14-rc: /proc/acpi/battery gone?
Message-ID: <20140315160545.GA6689@amd.pavel.ucw.cz>
References: <20140314211456.GA23213@amd.pavel.ucw.cz>
 <CAKb7Uvh1TaNLmi0YVBPmCD571ZU_sM1DpbYUSA8xQZnS5xUbCA@mail.gmail.com>
 <1677000.FsvVVRjEvo@vostro.rjw.lan>
 <201403150217.50526.s.L-H@gmx.de>
 <532471EC.1070107@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532471EC.1070107@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>They have attempted to use the sysfs api, but apparently that
> >>>integration was done with an older version of that API. There's also
> >>>some attempt to get it to work with upower, but I couldn't figure out
> >>>how to make that work either on my (up-to-date gentoo) box. (TBH I
> >>>didn't spend more than an hour or two on it, so it may not be
> >>>impossible.)
> >>
> >>Tianyu, can you please have a look at this?
> >
> >Disclaimer, I've never used wmbattery so far.
> >
> >The current upstream version (2.42, released in early december 2013)
> >of wmbattery[1] no longer reads from /proc/acpi/ at all. Apparently
> >it changed to using upower by default, with non-default fall-backs for
> >reading from sysfs.
> >
> >The only change required for building upower with wmbattery 2.42
> >appears to be a new build-dependency on libupower-glib-dev (at least
> >on Debian, built from the upower source package). Given that this
> >version is present in Debian testing and unstable, I'd assume that it's
> >supposed to work using upower, although I haven't confirmed that myself.
> >
> >Judging from the Gentoo ebuild, you probably just have to add
> >"sys-power/upower" to the RDEPEND variable and make sure to build
> >wmbattery 2.42; this is untested.
> >
> 
> Hi Stefan:
> 	I just glance wmbattery code. I find the code in the acpi.c is
> already using the new sysfs battery interfaces, right?
> 
> ...
> 
> #define SYSFS_PATH "/sys/class/power_supply"
> 
> ...
> char *acpi_labels[] = {
> 	"uevent",
> 	"status",
> 	"BAT",
> 	"AC",
> 	"POWER_SUPPLY_CAPACITY=",
> 	"POWER_SUPPLY_??????_FULL_DESIGN=", /* CHARGE or ENERGY */
> 	"POWER_SUPPLY_PRESENT=",
> 	"POWER_SUPPLY_??????_NOW=",
> 	"POWER_SUPPLY_CURRENT_NOW=",
> 	"POWER_SUPPLY_STATUS=",
> #if ACPI_THERMAL
> 	"thermal_zone",
> #endif
> 	"POWER_SUPPLY_ONLINE=",
> 	"POWER_SUPPLY_??????_FULL=",
> 	NULL
> };

New kernel should work with old userspace... and clearly it does not.

Do you have test patch for a revert?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
