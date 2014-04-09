Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbaDIPRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:17:44 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53880 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786AbaDIPOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:14:24 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        bp@suse.de, m.chehab@samsung.com
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH 3/7] ACPI, APEI, GHES: Introduce ACPI_APEI_NMI to make NMI error notification a GHES feature.
Date: Wed,  9 Apr 2014 17:14:31 +0200
Message-Id: <1397056476-9183-4-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently APEI depends on x86 architecture. It is because of NMI hardware
error notification of GHES which is currently supported by x86 only.
However, many other APEI features can be still used perfectly by other
architectures.

This commit adds ACPI_APEI_NMI which will be used in next patches to isolate
NMI related code in ghes.c file. Only NMI error notification feature
depends on x86 and it is selected by default for x86 arch.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 drivers/acpi/apei/Kconfig |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index c4dac71..3ae248a 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -3,7 +3,6 @@ config ACPI_APEI
 	select MISC_FILESYSTEMS
 	select PSTORE
 	select UEFI_CPER
-	depends on X86
 	help
 	  APEI allows to report errors (for example from the chipset)
 	  to the operating system. This improves NMI handling
@@ -16,6 +15,7 @@ config ACPI_APEI_GHES
 	select ACPI_HED
 	select IRQ_WORK
 	select GENERIC_ALLOCATOR
+	select ACPI_APEI_NMI if X86
 	help
 	  Generic Hardware Error Source provides a way to report
 	  platform hardware errors (such as that from chipset). It
@@ -26,6 +26,14 @@ config ACPI_APEI_GHES
 	  by firmware to produce more valuable hardware error
 	  information for Linux.
 
+config ACPI_APEI_NMI
+	bool "NMI error notification support"
+	depends on ACPI_APEI_GHES
+	help
+	  Firmware first mode can use NMI notification mechanism to report errors
+	  to operating system. This feature is currently supported by X86
+	  architecture only.
+
 config ACPI_APEI_PCIEAER
 	bool "APEI PCIe AER logging/recovering support"
 	depends on ACPI_APEI && PCIEAER
-- 
1.7.9.5

