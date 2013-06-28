Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3F1Wpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:45:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54520 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab3F1Wpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:45:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 2/3] ACPI: Drop ACPI bus notifier call chain
Date: Sat, 29 Jun 2013 00:54:21 +0200
Message-ID: <38153939.Z5E3mv4vzh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1515394.L46AJCfCTt@vostro.rjw.lan>
References: <1640211.P0jyS5muX2@vostro.rjw.lan> <1515394.L46AJCfCTt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

There are no users of the ACPI bus notifier call chain,
acpi_bus_notify_list, any more, so drop it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c      |   16 ----------------
 include/acpi/acpi_bus.h |    2 --
 2 files changed, 18 deletions(-)

Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -499,19 +499,6 @@ static void acpi_bus_check_scope(acpi_ha
 	 */
 }
 
-static BLOCKING_NOTIFIER_HEAD(acpi_bus_notify_list);
-int register_acpi_bus_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_register(&acpi_bus_notify_list, nb);
-}
-EXPORT_SYMBOL_GPL(register_acpi_bus_notifier);
-
-void unregister_acpi_bus_notifier(struct notifier_block *nb)
-{
-	blocking_notifier_chain_unregister(&acpi_bus_notify_list, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_acpi_bus_notifier);
-
 /**
  * acpi_bus_notify
  * ---------------
@@ -525,9 +512,6 @@ static void acpi_bus_notify(acpi_handle
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Notification %#02x to handle %p\n",
 			  type, handle));
 
-	blocking_notifier_call_chain(&acpi_bus_notify_list,
-		type, (void *)handle);
-
 	switch (type) {
 
 	case ACPI_NOTIFY_BUS_CHECK:
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -356,8 +356,6 @@ extern int acpi_notifier_call_chain(stru
 extern int register_acpi_notifier(struct notifier_block *);
 extern int unregister_acpi_notifier(struct notifier_block *);
 
-extern int register_acpi_bus_notifier(struct notifier_block *nb);
-extern void unregister_acpi_bus_notifier(struct notifier_block *nb);
 /*
  * External Functions
  */

