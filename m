Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab3LRGwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:52:02 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35370 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3LRGwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:52:00 -0500
Date: Wed, 18 Dec 2013 12:21:31 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@suse.de>, "Chen, Gong" <gong.chen@linux.intel.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-acpi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH] drivers: firmware: Move prototype declartions to header file
 cper.h
Message-ID: <20131218064527.GA3353@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declarations of function cper_estatus_print(),
cper_estatus_check_header() and cper_estatus_check() from file
drivers/acpi/apei/apei-internal.h to header file include/linux/cper.h
because these functions are used by both acpi driver and firmware
driver.
The header file include/linux/cper.h was chosen because it is included
in both the drivers.

This eliminates the following warnings in efi/cper.c:
drivers/firmware/efi/cper.c:346:6: warning: no previous prototype for ‘cper_estatus_print’ [-Wmissing-prototypes]
drivers/firmware/efi/cper.c:374:5: warning: no previous prototype for ‘cper_estatus_check_header’ [-Wmissing-prototypes]
drivers/firmware/efi/cper.c:387:5: warning: no previous prototype for ‘cper_estatus_check’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/acpi/apei/apei-internal.h |    5 -----
 include/linux/cper.h              |    8 ++++++++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/apei/apei-internal.h b/drivers/acpi/apei/apei-internal.h
index 21ba34a..4ae847d 100644
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -135,10 +135,5 @@ static inline u32 cper_estatus_len(struct acpi_generic_status *estatus)
 		return sizeof(*estatus) + estatus->data_length;
 }
 
-void cper_estatus_print(const char *pfx,
-			const struct acpi_generic_status *estatus);
-int cper_estatus_check_header(const struct acpi_generic_status *estatus);
-int cper_estatus_check(const struct acpi_generic_status *estatus);
-
 int apei_osc_setup(void);
 #endif
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 2fc0ec3..080f5f7 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -22,6 +22,14 @@
 #define LINUX_CPER_H
 
 #include <linux/uuid.h>
+#include <linux/acpi.h>
+
+/* Prototype declaration of functions common between acpi and firmware driver*/
+void cper_estatus_print(const char *pfx,
+		        const struct acpi_generic_status *estatus);
+int cper_estatus_check_header(const struct acpi_generic_status *estatus);
+int cper_estatus_check(const struct acpi_generic_status *estatus);
+
 
 /* CPER record signature and the size */
 #define CPER_SIG_RECORD				"CPER"
-- 
1.7.9.5

