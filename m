Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab3AQC4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:56:31 -0500
Received: from smtp.outflux.net ([198.145.64.163]:57765 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759154Ab3AQCzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:55:48 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 36/86] drivers/acpi: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:28 -0800
Message-Id: <1358391258-1771-37-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Len Brown <lenb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/acpi/Kconfig |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 38c5078..7ec178e 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -176,7 +176,6 @@ config ACPI_FAN
 
 config ACPI_DOCK
 	bool "Dock"
-	depends on EXPERIMENTAL
 	help
 	  This driver supports ACPI-controlled docking stations and removable
 	  drive bays such as the IBM Ultrabay and the Dell Module Bay.
@@ -202,7 +201,7 @@ config ACPI_PROCESSOR
 	  the module will be called processor.
 config ACPI_IPMI
 	tristate "IPMI"
-	depends on EXPERIMENTAL && IPMI_SI && IPMI_HANDLER
+	depends on IPMI_SI && IPMI_HANDLER
 	default n
 	help
 	  This driver enables the ACPI to access the BMC controller. And it
@@ -214,14 +213,13 @@ config ACPI_IPMI
 
 config ACPI_HOTPLUG_CPU
 	bool
-	depends on EXPERIMENTAL && ACPI_PROCESSOR && HOTPLUG_CPU
+	depends on ACPI_PROCESSOR && HOTPLUG_CPU
 	select ACPI_CONTAINER
 	default y
 
 config ACPI_PROCESSOR_AGGREGATOR
 	tristate "Processor Aggregator"
 	depends on ACPI_PROCESSOR
-	depends on EXPERIMENTAL
 	depends on X86
 	help
 	  ACPI 4.0 defines processor Aggregator, which enables OS to perform
@@ -337,8 +335,7 @@ config X86_PM_TIMER
 	  systems require this timer. 
 
 config ACPI_CONTAINER
-	tristate "Container and Module Devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Container and Module Devices"
 	default (ACPI_HOTPLUG_MEMORY || ACPI_HOTPLUG_CPU || ACPI_HOTPLUG_IO)
 	help
 	  This driver supports ACPI Container and Module devices (IDs
-- 
1.7.9.5

