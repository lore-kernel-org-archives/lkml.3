Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab3GCXTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:19:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57738 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393Ab3GCXSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:18:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 1/4] ACPI / dock: Actually define acpi_dock_init() as void
Date: Thu, 04 Jul 2013 01:25:16 +0200
Message-ID: <13622907.v865rbM3rp@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2759309.GsYqNLU1ac@vostro.rjw.lan>
References: <1640211.P0jyS5muX2@vostro.rjw.lan> <1515394.L46AJCfCTt@vostro.rjw.lan> <2759309.GsYqNLU1ac@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Commit 94add0f (ACPI / dock: Initialize ACPI dock subsystem upfront)
changed the header of acpi_dock_init() in internal.h so that it is
supposed to be a void function now, but it forgot to update its
actual definition in dock.c according to which it still is supposed
to return int.

Although that didn't cause any visible breakage or even a compiler
warning to be thrown, which is odd enough, fix it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 3.10+ <stable@vger.kernel.org>
---
 drivers/acpi/dock.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -931,10 +931,10 @@ find_dock_and_bay(acpi_handle handle, u3
 	return AE_OK;
 }
 
-int __init acpi_dock_init(void)
+void __init acpi_dock_init(void)
 {
 	if (acpi_disabled)
-		return 0;
+		return;
 
 	/* look for dock stations and bays */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
@@ -942,11 +942,10 @@ int __init acpi_dock_init(void)
 
 	if (!dock_station_count) {
 		pr_info(PREFIX "No dock devices found.\n");
-		return 0;
+		return;
 	}
 
 	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 	pr_info(PREFIX "%s: %d docks/bays found\n",
 		ACPI_DOCK_DRIVER_DESCRIPTION, dock_station_count);
-	return 0;
 }

