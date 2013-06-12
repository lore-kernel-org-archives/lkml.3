Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab3FLXTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:19:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35482 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab3FLXS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:18:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 0/5] ACPI / scan: Make it possible to use the container hotplug with other scan handlers
Date: Thu, 13 Jun 2013 01:23:01 +0200
Message-ID: <1417592.vuSG0cUIGo@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

It turns out that some BIOSes add container device IDs as _CIDs to device
object that in principle may be matched against the other scan handlers (or
ACPI drivers, but that's not a problem, because the container scan handler
can co-exist with an ACPI driver).  That's why our recent fix for an issue
related to the ACPI video driver had to be reverted right before -rc5.

Although I submitted an alternative fix for that bug, I think the problem
with the container scan handler possibly matching devices already having
some other scan handlers attached needs addressing, because we may need to
use the container hotplug profile for those devices.  The following patch
series is supposed to address it.

[1/5] ACPI / scan: Do not bind ACPI drivers to objects with scan handlers
   (this version shouldn't break the Tony's IA64 HP box the previous one broke)
[2/5] ACPI / scan: Separate hotplug profiles from scan handlers
[3/5] ACPI / scan: Add hotplug profile pointer to struct acpi_device
[4/5] ACPI / scan: Use container hotplug profile for matching device objects
[5/5] ACPI / ia64 / sba_iommu: Use ACPI scan handler for discovery

Patches [1-4/5] were run on my Toshiba test box and didn't break it, but it
really doesn't do any ACPI hotplug notifications.

Patch [5/5] is kind of additional, but it wouldn't work correctly without the
previous ones (to be honest, I haven't tried to compile it yet, but here it
goes for completness).

The patches are against the linux-next branch of the linux-pm.git tree.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
