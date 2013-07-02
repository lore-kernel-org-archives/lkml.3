Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab3GBN6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 09:58:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:21795 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab3GBN6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 09:58:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,980,1363158000"; 
   d="scan'208";a="359348966"
Message-ID: <51D2DCAE.1000209@intel.com>
Date: Tue, 02 Jul 2013 21:59:10 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "lenb@kernel.org" <lenb@kernel.org>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 1/2] ACPICA: expose OSI version
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <1371508629.523.3.camel@x230> <10189900.qsvQBSpnvI@vostro.rjw.lan> <2211483.MscZsfrrDc@vostro.rjw.lan> <51D2DC1D.60101@intel.com>
In-Reply-To: <51D2DC1D.60101@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose acpi_gbl_osi_data so that driver can know the value of the last
successfull call of _OSI. The definitions for OSI versions have been
moved to actypes.h so that other components can access them.

Based on a patch by Matthew Garrett <matthew.garrett@nebula.com>, which
is again based on a patch by Seth Forshee <seth.forshee@canonical.com>.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/acpi/acpica/aclocal.h | 13 -------------
 include/acpi/acpixf.h         |  1 +
 include/acpi/actypes.h        | 15 +++++++++++++++
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index dfed265..d4a49016 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -931,19 +931,6 @@ struct acpi_bit_register_info {
 
 /* Structs and definitions for _OSI support and I/O port validation */
 
-#define ACPI_OSI_WIN_2000               0x01
-#define ACPI_OSI_WIN_XP                 0x02
-#define ACPI_OSI_WIN_XP_SP1             0x03
-#define ACPI_OSI_WINSRV_2003            0x04
-#define ACPI_OSI_WIN_XP_SP2             0x05
-#define ACPI_OSI_WINSRV_2003_SP1        0x06
-#define ACPI_OSI_WIN_VISTA              0x07
-#define ACPI_OSI_WINSRV_2008            0x08
-#define ACPI_OSI_WIN_VISTA_SP1          0x09
-#define ACPI_OSI_WIN_VISTA_SP2          0x0A
-#define ACPI_OSI_WIN_7                  0x0B
-#define ACPI_OSI_WIN_8                  0x0C
-
 #define ACPI_ALWAYS_ILLEGAL             0x00
 
 struct acpi_interface_info {
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 1b09300..22d497e 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -62,6 +62,7 @@ extern u32 acpi_current_gpe_count;
 extern struct acpi_table_fadt acpi_gbl_FADT;
 extern u8 acpi_gbl_system_awake_and_running;
 extern u8 acpi_gbl_reduced_hardware;	/* ACPI 5.0 */
+extern u8 acpi_gbl_osi_data;
 
 /* Runtime configuration of debug print levels */
 
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index a64adcc..22b03c9 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -1144,4 +1144,19 @@ struct acpi_memory_list {
 #endif
 };
 
+/* Definitions for _OSI support */
+
+#define ACPI_OSI_WIN_2000               0x01
+#define ACPI_OSI_WIN_XP                 0x02
+#define ACPI_OSI_WIN_XP_SP1             0x03
+#define ACPI_OSI_WINSRV_2003            0x04
+#define ACPI_OSI_WIN_XP_SP2             0x05
+#define ACPI_OSI_WINSRV_2003_SP1        0x06
+#define ACPI_OSI_WIN_VISTA              0x07
+#define ACPI_OSI_WINSRV_2008            0x08
+#define ACPI_OSI_WIN_VISTA_SP1          0x09
+#define ACPI_OSI_WIN_VISTA_SP2          0x0A
+#define ACPI_OSI_WIN_7                  0x0B
+#define ACPI_OSI_WIN_8                  0x0C
+
 #endif				/* __ACTYPES_H__ */
-- 
1.8.3.2.10.g43d11f4
