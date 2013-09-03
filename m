Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154Ab3ICXug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 19:50:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33638 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934132Ab3ICXud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 19:50:33 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, keescook@chromium.org, hpa@zytor.com,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH V3 07/11] acpi: Ignore acpi_rsdp kernel parameter when module loading is restricted
Date: Tue,  3 Sep 2013 19:50:14 -0400
Message-Id: <1378252218-18798-8-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

This option allows userspace to pass the RSDP address to the kernel, which
makes it possible for a user to circumvent any restrictions imposed on
loading modules. Disable it in that case.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 drivers/acpi/osl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 6ab2c35..e4c4410 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -45,6 +45,7 @@
 #include <linux/list.h>
 #include <linux/jiffies.h>
 #include <linux/semaphore.h>
+#include <linux/module.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -245,7 +246,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
 acpi_physical_address __init acpi_os_get_root_pointer(void)
 {
 #ifdef CONFIG_KEXEC
-	if (acpi_rsdp)
+	if (acpi_rsdp && !secure_modules())
 		return acpi_rsdp;
 #endif
 
-- 
1.8.3.1

