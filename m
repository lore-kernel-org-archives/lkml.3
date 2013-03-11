Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3CKKxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:53:52 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:62931 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546Ab3CKKxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:53:51 -0400
Message-ID: <1362999228.3137.55.camel@x61.thuisdomein>
Subject: [PATCH] acpi: remove reference to ACPI_HOTPLUG_IO
From: Paul Bolle <pebolle@tiscali.nl>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2013 11:53:48 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2013 10:53:49.0510 (UTC) FILETIME=[B648EE60:01CE1E46]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for ACPI Container and Module Devices got
added in v2.6.11. Its default value has always been set to
    (ACPI_HOTPLUG_MEMORY || ACPI_HOTPLUG_CPU || ACPI_HOTPLUG_IO)

But the Kconfig symbol ACPI_HOTPLUG_IO has never existed. So it's
pointless to use it to set this default value.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested, actually.

 drivers/acpi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 92ed969..b46f5e3 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -334,7 +334,7 @@ config X86_PM_TIMER
 
 config ACPI_CONTAINER
 	bool "Container and Module Devices"
-	default (ACPI_HOTPLUG_MEMORY || ACPI_HOTPLUG_CPU || ACPI_HOTPLUG_IO)
+	default (ACPI_HOTPLUG_MEMORY || ACPI_HOTPLUG_CPU)
 	help
 	  This driver supports ACPI Container and Module devices (IDs
 	  ACPI0004, PNP0A05, and PNP0A06).
-- 
1.7.11.7

