Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab3GCXSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:18:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57726 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891Ab3GCXSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:18:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 4/4] ACPI / dock: Drop unnecessary local variable from dock_add()
Date: Thu, 04 Jul 2013 01:28:08 +0200
Message-ID: <1947347.R35Ynr5mt7@vostro.rjw.lan>
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

The local variable id in dock_add() is not necessary, so drop it.

While we're at it, use an initializer to clear the local variable ds
and drop the memset() used for this purpose.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -836,14 +836,13 @@ static struct attribute_group dock_attri
  */
 static int __init dock_add(acpi_handle handle)
 {
-	int ret, id;
-	struct dock_station ds, *dock_station;
+	struct dock_station *dock_station, ds = { 0 };
 	struct platform_device *dd;
 	acpi_status status;
+	int ret;
 
-	id = dock_station_count;
-	memset(&ds, 0, sizeof(ds));
-	dd = platform_device_register_data(NULL, "dock", id, &ds, sizeof(ds));
+	dd = platform_device_register_data(NULL, "dock", dock_station_count,
+					   &ds, sizeof(ds));
 	if (IS_ERR(dd))
 		return PTR_ERR(dd);
 

