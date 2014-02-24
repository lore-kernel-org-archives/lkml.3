Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaBXCYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:24:32 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:53151 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaBXCY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:24:28 -0500
From: minyard@acm.org
To: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Russ Anderson <rja@sgi.com>,
        Matthew Garrett <matthew.garrett@nebula.com>, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org
Subject: [PATCH 3/3] Change ACPI IPMI support to "default y"
Date: Sun, 23 Feb 2014 20:23:36 -0600
Message-Id: <1393208616-16500-4-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393208616-16500-1-git-send-email-minyard@acm.org>
References: <1393208616-16500-1-git-send-email-minyard@acm.org>
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
---
 drivers/acpi/Kconfig      | 2 +-
 drivers/char/ipmi/Kconfig | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 4770de5..0e6aab9 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -162,7 +162,7 @@ config ACPI_PROCESSOR
 config ACPI_IPMI
 	tristate "IPMI"
 	depends on IPMI_SI
-	default n
+	default y
 	help
 	  This driver enables the ACPI to access the BMC controller. And it
 	  uses the IPMI request/response message to communicate with BMC
diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
index 8e14360..5eb7e85 100644
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

