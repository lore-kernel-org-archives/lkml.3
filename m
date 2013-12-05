Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab3LEHor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 02:44:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:54586 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab3LEHoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 02:44:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,831,1378882800"; 
   d="scan'208";a="447234928"
Date: Thu, 5 Dec 2013 15:47:35 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>,
        Len Brown <len.brown@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 0/4] Convert ACPI fan driver to platform driver
Message-ID: <20131205074734.GA4432@localhost.sh.intel.com>
References: <1386059312-2990-1-git-send-email-aaron.lu@intel.com>
 <1654759.afJtadVnDQ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1654759.afJtadVnDQ@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 12:07:31AM +0100, Rafael J. Wysocki wrote:
> On Tuesday, December 03, 2013 04:28:28 PM Aaron Lu wrote:
> > This patchset converts ACPI fan driver to platform driver. Patch 1-3 are
> > cleanups for existing fan driver and patch 4 does the convertion.
> > 
> > Tested on harris beach.
> > Apply on top of Rafael's linux-next branch.
> > 
> > Aaron Lu (4):
> >   ACPI / fan: remove unused macro for debug
> >   ACPI / fan: remove no need check for device pointer
> >   ACPI / fan: use acpi_device_xxx_power instead of acpi_bus equivelant
> >   ACPI / fan: convert to platform driver
> > 
> >  drivers/acpi/acpi_platform.c |  3 ++
> >  drivers/acpi/device_pm.c     |  1 +
> >  drivers/acpi/fan.c           | 88 ++++++++++++++++----------------------------
> >  drivers/acpi/internal.h      |  2 -
> >  include/acpi/acpi_bus.h      |  1 +
> >  5 files changed, 36 insertions(+), 59 deletions(-)
> 
> Unfortunately, we need to postpone these conversions, because Matthew Garrett
> has problems with adding more entries to acpi_platform_device_ids[].  He seems
> to be concerned that that list will grow indefinitely and will become difficult
> to maintain eventually.
> 
> For this reason, he would prefer it if we did the following:
> - Figure out the list of ACPI device IDs we need to create PNP devices for
>   via ACPI PNP.

I'm not sure how to tell this, is it that as long as the ACPI node has a
PNPxxxx ID we will need to create a PNP device for it? And in this case,
do we only check the _HID or both _HID and _CID?

> - Make ACPI PNP create PNP devices for these IDs only and make the ACPI core create
>   platform devices for all "unassigned" ACPI device objects by default.

Does "unassigned" mean (all ACPI devices) - (ACPI devices that have a
PNP device created already)?

Thanks,
Aaron

> - Do the conversions at that point.
> 
> I'm slightly worried that we'll encounter ordering issues while doing that, but
> this is the only way forward I can see without going straight against the
> Matthew's objections, which I'd prefer to avoid.
> 
> Thanks,
> Rafael
> 
