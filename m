Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaJFTXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:23:40 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:49368 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaJFTXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:23:38 -0400
From: minyard@acm.org
To: linux-acpi@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH] Change ACPI IPMI support to "default y"
Date: Mon,  6 Oct 2014 14:23:11 -0500
Message-Id: <1412623391-1923-1-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <matthew.garrett@nebula.com>

The ACPI IPMI driver implements IPMI operation region support for the ACPI
core. Systems that declare ACPI operation regions may reference them at any
time, including during kernel initialisation. These accesses will fail
unless the ACPI IPMI driver is present, and undesirable system behaviour
may result. Set the default to Y in order to encourage distributions and
users to configure kernels to avoid awkward surprises.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/acpi/Kconfig      | 2 +-
 drivers/char/ipmi/Kconfig | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index d0f3265..21d384d 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -176,7 +176,7 @@ config ACPI_PROCESSOR
 config ACPI_IPMI
 	tristate "IPMI"
 	depends on IPMI_SI
-	default n
+	default y
 	help
 	  This driver enables the ACPI to access the BMC controller. And it
 	  uses the IPMI request/response message to communicate with BMC
diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
index db1c9b7..e0d688a 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -5,6 +5,7 @@
 menuconfig IPMI_HANDLER
        tristate 'IPMI top-level message handler'
        depends on HAS_IOMEM
+       default y if ACPI
        help
          This enables the central IPMI message handler, required for IPMI
 	 to work.
@@ -45,6 +46,7 @@ config IPMI_DEVICE_INTERFACE
 
 config IPMI_SI
        tristate 'IPMI System Interface handler'
+       default y if ACPI
        help
          Provides a driver for System Interfaces (KCS, SMIC, BT).
 	 Currently, only KCS and SMIC are supported.  If
-- 
1.8.3.1

