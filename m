Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbbAENkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:40:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:50437 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbbAENkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:40:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="436599469"
Date: Mon, 5 Jan 2015 15:40:10 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / PM: Fix PM initialization for devices that are
 not present
Message-ID: <20150105134010.GF1386@lahna.fi.intel.com>
References: <4453924.d7c5RYZUJi@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4453924.d7c5RYZUJi@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 11:38:28PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> If an ACPI device object whose _STA returns 0 (not present and not
> functional) has _PR0 or _PS0, its power_manageable flag will be set
> and acpi_bus_init_power() will return 0 for it.  Consequently, if
> such a device object is passed to the ACPI device PM functions, they
> will attempt to carry out the requested operation on the device,
> although they should not do that for devices that are not present.
> 
> To fix that problem make acpi_bus_init_power() return an error code
> for devices that are not present which will cause power_manageable to
> be cleared for them as appropriate in acpi_bus_get_power_flags().
> However, the lists of power resources should not be freed for the
> device in that case, so modify acpi_bus_get_power_flags() to keep
> those lists even if acpi_bus_init_power() returns an error.
> Accordingly, when deciding whether or not the lists of power
> resources need to be freed, acpi_free_power_resources_lists()
> should check the power.flags.power_resources flag instead of
> flags.power_manageable, so make that change too.
> 
> Furthermore, if acpi_bus_attach() sees that flags.initialized is
> unset for the given device, it should reset the power management
> settings of the device and re-initialize them from scratch instead
> of relying on the previous settings (the device may have appeared
> after being not present previously, for example), so make it use
> the 'valid' flag of the D0 power state as the initial value of
> flags.power_manageable for it and call acpi_bus_init_power() to
> discover its current power state.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
