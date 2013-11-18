Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab3KRNS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:18:28 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57065 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750779Ab3KRNSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:18:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI / scan: Set flags.match_driver in acpi_bus_scan_fixed()
Date: Mon, 18 Nov 2013 14:30:56 +0100
Message-ID: <12372702.nqQ0u36ADq@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Before commit 6931007cc90b (ACPI / scan: Start matching drivers
after trying scan handlers) the match_driver flag for all devices
was set in acpi_add_single_object(), but now it is set by
acpi_bus_device_attach() which is not called for the "fixed"
devices added by acpi_bus_scan_fixed().  This means that
flags.match_driver is never set for those devices now, so make
acpi_bus_scan_fixed() set it before calling device_attach().

Fixes: 6931007cc90b (ACPI / scan: Start matching drivers after trying scan handlers)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -2023,6 +2023,7 @@ static int acpi_bus_scan_fixed(void)
 		if (result)
 			return result;
 
+		device->flags.match_driver = true;
 		result = device_attach(&device->dev);
 		if (result < 0)
 			return result;
@@ -2039,6 +2040,7 @@ static int acpi_bus_scan_fixed(void)
 		if (result)
 			return result;
 
+		device->flags.match_driver = true;
 		result = device_attach(&device->dev);
 	}
 

