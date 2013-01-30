Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3A3V6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:58:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34417 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055Ab3A3V6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:58:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/2] ACPI / scan: Fix acpi_bus_get_device() check in acpi_match_device()
Date: Wed, 30 Jan 2013 23:03:07 +0100
Message-ID: <6099377.PFvsxPeyib@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1451967.YMyGeCCNtu@vostro.rjw.lan>
References: <1451967.YMyGeCCNtu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since acpi_bus_get_device() returns int and not acpi_status, change
acpi_match_device() so that it doesn't apply ACPI_FAILURE() to the
return value of acpi_bus_get_device().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -491,9 +491,9 @@ const struct acpi_device_id *acpi_match_
 					       const struct device *dev)
 {
 	struct acpi_device *adev;
+	acpi_handle handle = ACPI_HANDLE(dev);
 
-	if (!ids || !ACPI_HANDLE(dev)
-	    || ACPI_FAILURE(acpi_bus_get_device(ACPI_HANDLE(dev), &adev)))
+	if (!ids || !handle || acpi_bus_get_device(handle, &adev))
 		return NULL;
 
 	return __acpi_match_device(adev, ids);

