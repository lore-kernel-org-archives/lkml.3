Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3KMXGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:06:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55057 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751229Ab3KMXFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:05:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/3] ACPI / hotplug: Fix acpi_bus_get_device() return value check
Date: Thu, 14 Nov 2013 00:15:19 +0100
Message-ID: <1785834.mvVFipiyRh@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2434673.zhjYZOTQ4A@vostro.rjw.lan>
References: <2434673.zhjYZOTQ4A@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since acpi_bus_get_device() returns plain int and not acpi_status,
ACPI_FAILURE() should not be used for checking its return value.  Fix
that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -411,8 +411,7 @@ static void acpi_hotplug_notify_cb(acpi_
 		break;
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
-		status = acpi_bus_get_device(handle, &adev);
-		if (ACPI_FAILURE(status))
+		if (acpi_bus_get_device(handle, &adev))
 			goto err_out;
 
 		get_device(&adev->dev);

