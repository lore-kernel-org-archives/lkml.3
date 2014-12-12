Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966151AbaLLKwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:52:05 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:47299 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966055AbaLLKv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:51:59 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Lv Zheng <lv.zheng@intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-acpi@vger.kernel.org,
        devel@acpica.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
Date: Fri, 12 Dec 2014 11:51:28 +0100
Message-Id: <1418381488-25123-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro __DATE__ and friends is not allowed in the kernel. Also,
including the build time in output doesn't seem to provide any value.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/acpi/acpica/acapps.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/acapps.h b/drivers/acpi/acpica/acapps.h
index 3d2c88289da9..f72826176ebe 100644
--- a/drivers/acpi/acpica/acapps.h
+++ b/drivers/acpi/acpica/acapps.h
@@ -64,15 +64,15 @@
 /* Macros for signons and file headers */
 
 #define ACPI_COMMON_SIGNON(utility_name) \
-	"\n%s\n%s version %8.8X%s [%s]\n%s\n\n", \
+	"\n%s\n%s version %8.8X%s\n%s\n\n", \
 	ACPICA_NAME, \
-	utility_name, ((u32) ACPI_CA_VERSION), ACPI_WIDTH, __DATE__, \
+	utility_name, ((u32) ACPI_CA_VERSION), ACPI_WIDTH, \
 	ACPICA_COPYRIGHT
 
 #define ACPI_COMMON_HEADER(utility_name, prefix) \
-	"%s%s\n%s%s version %8.8X%s [%s]\n%s%s\n%s\n", \
+	"%s%s\n%s%s version %8.8X%s\n%s%s\n%s\n", \
 	prefix, ACPICA_NAME, \
-	prefix, utility_name, ((u32) ACPI_CA_VERSION), ACPI_WIDTH, __DATE__, \
+	prefix, utility_name, ((u32) ACPI_CA_VERSION), ACPI_WIDTH, \
 	prefix, ACPICA_COPYRIGHT, \
 	prefix
 
-- 
2.1.3

