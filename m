Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3AKUxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:53:06 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38102 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab3AKUxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:53:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 1/16] ACPI: Separate adding ACPI device objects from probing ACPI drivers
Date: Fri, 11 Jan 2013 21:58:50 +0100
Message-ID: <6935441.WoipOdx2kz@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130111203759.GC13897@intel.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <2859994.arbXorpfaz@vostro.rjw.lan> <20130111203759.GC13897@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 10:37:59 PM Mika Westerberg wrote:
> On Fri, Jan 11, 2013 at 09:31:43PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI / scan: Fix check of device_attach() return value.
> > 
> > Since device_attach() returns 1 on success and 0 on failure,
> > the check against its return value in acpi_bus_device_attach()
> > should be reveresed.  Make it so.
> 
> Not sure if it matters but it returns 0 if no device was bound to a driver
> and -ENODEV in case of error. If we only want to terminate in case of
> error, following might be better.
> 
> 	} else if (device_attach(&device->dev) < 0) {

Yes, this check will be better.

Which means that the patch is actually yours, so I've just added the changelog. :-)

Thanks,
Rafael


---
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: ACPI / scan: Fix check of device_attach() return value.

Since device_attach() returns 1 on success (a driver has been bound
to the device), the check against its return value in
acpi_bus_device_attach() should modified to take that into accout.
Make it so.

[rjw: Subject and changelog.]
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1598,7 +1598,7 @@ static acpi_status acpi_bus_device_attac
 	if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
 		/* This is a known good platform device. */
 		acpi_create_platform_device(device);
-	} else if (device_attach(&device->dev)) {
+	} else if (device_attach(&device->dev) < 0) {
 		status = AE_CTRL_DEPTH;
 	}
 	return status;

