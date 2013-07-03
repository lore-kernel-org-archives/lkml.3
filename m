Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3GCXSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:18:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57734 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab3GCXSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:18:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 2/4] ACPI / dock: Do not check CONFIG_ACPI_DOCK_MODULE
Date: Thu, 04 Jul 2013 01:26:11 +0200
Message-ID: <3875539.nz3LziUdX0@vostro.rjw.lan>
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

Since commit 94add0f (ACPI / dock: Initialize ACPI dock subsystem
upfront) the ACPI dock driver cannot be a module, so
CONFIG_ACPI_DOCK_MODULE is never set.  For this reason, simplify
the preprocessor conditional in include/acpi/acpi_drivers.h
referring to that symbol unnecessarily.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/acpi/acpi_drivers.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-pm/include/acpi/acpi_drivers.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_drivers.h
+++ linux-pm/include/acpi/acpi_drivers.h
@@ -117,7 +117,7 @@ struct acpi_dock_ops {
 	acpi_notify_handler uevent;
 };
 
-#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
+#ifdef CONFIG_ACPI_DOCK
 extern int is_dock_device(acpi_handle handle);
 extern int register_dock_notifier(struct notifier_block *nb);
 extern void unregister_dock_notifier(struct notifier_block *nb);
@@ -150,6 +150,6 @@ static inline int register_hotplug_dock_
 static inline void unregister_hotplug_dock_device(acpi_handle handle)
 {
 }
-#endif
+#endif /* CONFIG_ACPI_DOCK */
 
 #endif /*__ACPI_DRIVERS_H__*/

