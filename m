Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaA0ABz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 19:01:55 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50111 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753076AbaA0ABy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 19:01:54 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI / scan: Clear match_driver flag in acpi_bus_trim()
Date: Mon, 27 Jan 2014 01:16:09 +0100
Message-ID: <1737561.u7lWGR6b7C@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Drivers should not bind to struct acpi_device objects that
acpi_bus_trim() has been called for, so make that function
clear flags.match_driver for those objects.

If that is not done, an ACPI driver may theoretically try to operate
a device that is not physically present.

Fixes: 202317a573b2 (ACPI / scan: Add acpi_device objects for all device nodes in the namespace)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -2106,6 +2106,7 @@ void acpi_bus_trim(struct acpi_device *a
 	list_for_each_entry_reverse(child, &adev->children, node)
 		acpi_bus_trim(child);
 
+	adev->flags.match_driver = false;
 	if (handler) {
 		if (handler->detach)
 			handler->detach(adev);

