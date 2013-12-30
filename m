Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab3L3JNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 04:13:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:39007 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab3L3JNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 04:13:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,573,1384329600"; 
   d="scan'208";a="431622881"
Date: Mon, 30 Dec 2013 11:20:43 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mike Lothian <mike@fireburn.co.uk>, madcatx@atlas.cz,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@linux.ie>,
        Takashi Iwai <tiwai@suse.de>,
        =?iso-8859-1?Q?Joaqu=EDn_Aramend=EDa?= <samsagax@gmail.com>
Subject: Re: [PATCH][update] ACPIPHP / radeon / nouveau: Fix VGA switcheroo
 problem related to hotplug events
Message-ID: <20131230092043.GB2494@intel.com>
References: <10163453.2AxBLHI1XI@vostro.rjw.lan>
 <3135179.iXEx1Rk87m@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3135179.iXEx1Rk87m@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 10:36:56PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The changes in the ACPI-based PCI hotplug (ACPIPHP) subsystem made
> during the 3.12 development cycle uncovered a problem with VGA
> switcheroo that on some systems, when the device-specific method
> (ATPX in the radeon case, _DSM in the nouveau case) is used to turn
> off the discrete graphics, the BIOS generates ACPI hotplug events for
> that device and those events cause ACPIPHP to attempt to remove the
> device from the system (they are events for a device that was present
> previously and is not present any more, so that's what should be done
> according to the spec).  Then, the system stops functioning correctly.
> 
> Since the hotplug events in question were simply silently ignored
> previously, the least intrusive way to address that problem is to
> make ACPIPHP ignore them again.  For this purpose, introduce a new
> ACPI device flag, no_hotplug, and modify ACPIPHP to ignore hotplug
> events for PCI devices whose ACPI companions have that flag set.
> Next, make the radeon and nouveau switcheroo detection code set the
> no_hotplug flag for the discrete graphics' ACPI companion.
> 
> Fixes: bbd34fcdd1b2 (ACPI / hotplug / PCI: Register all devices under the given bridge)
> References: https://bugzilla.kernel.org/show_bug.cgi?id=61891
> References: https://bugzilla.kernel.org/show_bug.cgi?id=64891
> Reported-and-tested-by: Mike Lothian <mike@fireburn.co.uk>
> Reported-and-tested-by: <madcatx@atlas.cz>
> Reported-by: Joaquín Aramendía <samsagax@gmail.com>
> Cc: Alex Deucher <alexdeucher@gmail.com>
> Cc: Dave Airlie <airlied@linux.ie>
> Cc: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: 3.12+ <stable@vger.kernel.org> # 3.12+

FWIW, Thunderbolt hotplug still works fine after this patch is applied :)
