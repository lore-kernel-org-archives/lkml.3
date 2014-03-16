Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaCPLMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 07:12:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50063 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaCPLMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 07:12:33 -0400
Date: Sun, 16 Mar 2014 12:12:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.14-rc: /proc/acpi/battery gone?
Message-ID: <20140316111231.GA25825@amd.pavel.ucw.cz>
References: <20140314211456.GA23213@amd.pavel.ucw.cz>
 <CAKb7Uvh1TaNLmi0YVBPmCD571ZU_sM1DpbYUSA8xQZnS5xUbCA@mail.gmail.com>
 <1677000.FsvVVRjEvo@vostro.rjw.lan>
 <201403150217.50526.s.L-H@gmx.de>
 <532471EC.1070107@intel.com>
 <20140315160545.GA6689@amd.pavel.ucw.cz>
 <53248D6D.1010405@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53248D6D.1010405@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >New kernel should work with old userspace... and clearly it does not.
> >
> >Do you have test patch for a revert?
> 
> Please try this patch.

I tried to apply it, but it is a bit too wordwrapped :-(.

Thanks,
									Pavel

> @@ -301,6 +320,14 @@ static enum power_supply_property
> energy_battery_props[] = {
>  	POWER_SUPPLY_PROP_SERIAL_NUMBER,
>  };
> 
> +#ifdef CONFIG_ACPI_PROCFS_POWER
> +inline char *acpi_battery_units(struct acpi_battery *battery)
> +{
> +	return (battery->power_unit == ACPI_BATTERY_POWER_UNIT_MA) ?
> +		"mA" : "mW";
> +}
> +#endif
> +
>  /* --------------------------------------------------------------------------
>                                 Battery Management
> 
> --------------------------------------------------------------------------
> */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
