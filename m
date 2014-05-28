Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaE1HlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:41:06 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56225 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbaE1Hjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:39:52 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v2 2/5] acpi, apei, ghes: Introduce ACPI_APEI_NMI to make NMI error notification a GHES feature.
Date: Wed, 28 May 2014 09:39:27 +0200
Message-Id: <1401262770-25343-3-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401262770-25343-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1401262770-25343-1-git-send-email-tomasz.nowicki@linaro.org>
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
index c4dac71..4b734a2 100644
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
@@ -26,6 +25,15 @@ config ACPI_APEI_GHES
 	  by firmware to produce more valuable hardware error
 	  information for Linux.
 
+config ACPI_APEI_NMI
+	bool "NMI error notification support"
+	default y
+	depends on ACPI_APEI_GHES && X86
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

