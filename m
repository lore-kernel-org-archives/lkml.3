Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaBZUMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:12:48 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44136 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaBZULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:11:43 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH 07/12] acpi: Ignore acpi_rsdp kernel parameter when trusted_kernel is true.
Date: Wed, 26 Feb 2014 15:11:08 -0500
Message-Id: <1393445473-15068-8-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

This option allows userspace to pass the RSDP address to the kernel, which
makes it possible for a user to execute arbitrary code in the kernel.
Disable this when trusted_kernel is true.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 drivers/acpi/osl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index fc1aa79..087a351 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -44,6 +44,7 @@
 #include <linux/list.h>
 #include <linux/jiffies.h>
 #include <linux/semaphore.h>
+#include <linux/security.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -244,7 +245,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
 acpi_physical_address __init acpi_os_get_root_pointer(void)
 {
 #ifdef CONFIG_KEXEC
-	if (acpi_rsdp)
+	if (acpi_rsdp && !get_trusted_kernel())
 		return acpi_rsdp;
 #endif
 
-- 
1.8.5.3

