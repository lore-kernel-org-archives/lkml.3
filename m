Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3L3MjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:39:12 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52549 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755810Ab3L3MjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:39:10 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mike Lothian <mike@fireburn.co.uk>, madcatx@atlas.cz,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@linux.ie>,
        Takashi Iwai <tiwai@suse.de>,
        =?ISO-8859-1?Q?Joaqu=EDn_Aramend=EDa?= <samsagax@gmail.com>
Subject: Re: [PATCH][update] ACPIPHP / radeon / nouveau: Fix VGA switcheroo problem related to hotplug events
Date: Mon, 30 Dec 2013 13:52:46 +0100
Message-ID: <1571235.xlQ25FNpVL@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131230092043.GB2494@intel.com>
References: <10163453.2AxBLHI1XI@vostro.rjw.lan> <3135179.iXEx1Rk87m@vostro.rjw.lan> <20131230092043.GB2494@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 30, 2013 11:20:43 AM Mika Westerberg wrote:
> On Sun, Dec 29, 2013 at 10:36:56PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > The changes in the ACPI-based PCI hotplug (ACPIPHP) subsystem made
> > during the 3.12 development cycle uncovered a problem with VGA
> > switcheroo that on some systems, when the device-specific method
> > (ATPX in the radeon case, _DSM in the nouveau case) is used to turn
> > off the discrete graphics, the BIOS generates ACPI hotplug events for
> > that device and those events cause ACPIPHP to attempt to remove the
> > device from the system (they are events for a device that was present
> > previously and is not present any more, so that's what should be done
> > according to the spec).  Then, the system stops functioning correctly.
> > 
> > Since the hotplug events in question were simply silently ignored
> > previously, the least intrusive way to address that problem is to
> > make ACPIPHP ignore them again.  For this purpose, introduce a new
> > ACPI device flag, no_hotplug, and modify ACPIPHP to ignore hotplug
> > events for PCI devices whose ACPI companions have that flag set.
> > Next, make the radeon and nouveau switcheroo detection code set the
> > no_hotplug flag for the discrete graphics' ACPI companion.
> > 
> > Fixes: bbd34fcdd1b2 (ACPI / hotplug / PCI: Register all devices under the given bridge)
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=61891
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=64891
> > Reported-and-tested-by: Mike Lothian <mike@fireburn.co.uk>
> > Reported-and-tested-by: <madcatx@atlas.cz>
> > Reported-by: Joaquín Aramendía <samsagax@gmail.com>
> > Cc: Alex Deucher <alexdeucher@gmail.com>
> > Cc: Dave Airlie <airlied@linux.ie>
> > Cc: Takashi Iwai <tiwai@suse.de>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Cc: 3.12+ <stable@vger.kernel.org> # 3.12+
> 
> FWIW, Thunderbolt hotplug still works fine after this patch is applied :)

I've checked that, but thanks for the confirmation!

Rafael

