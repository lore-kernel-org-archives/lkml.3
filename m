Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbaBRQVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:21:15 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:49373 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbaBRQVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:21:11 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: minyard@acm.org
Cc: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH] Change ACPI IPMI support to "default y"
Date: Tue, 18 Feb 2014 11:20:49 -0500
Message-Id: <1392740449-843-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI IPMI driver implements IPMI operation region support for the ACPI
core. Systems that declare ACPI operation regions may reference them at any
time, including during kernel initialisation. These accesses will fail
unless the ACPI IPMI driver is present, and undesirable system behaviour
may result. Set the default to Y in order to encourage distributions and
users to configure kernels to avoid awkward surprises.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/acpi/Kconfig      | 2 +-
 drivers/char/ipmi/Kconfig | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

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
index 0baa8fa..a125610 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -45,6 +45,7 @@ config IPMI_DEVICE_INTERFACE
 
 config IPMI_SI
        tristate 'IPMI System Interface handler'
+       default y if ACPI
        help
          Provides a driver for System Interfaces (KCS, SMIC, BT).
 	 Currently, only KCS and SMIC are supported.  If
-- 
1.8.5.3

