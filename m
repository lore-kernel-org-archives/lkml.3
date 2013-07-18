Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201Ab3GRAMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:12:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47991 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802Ab3GRAMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:12:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-acpi@vger.kernel.org
Cc: Matthew Garrett <matthew.garrett@nebula.com>, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        Aaron Lu <aaron.lu@intel.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 1/3] ACPICA: expose OSI version
Date: Thu, 18 Jul 2013 02:20:06 +0200
Message-ID: <1577214.QYL5SKYFj8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1448863.3slS729B6b@vostro.rjw.lan>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <1448863.3slS729B6b@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Lu <aaron.lu@intel.com>

Expose acpi_gbl_osi_data so that code outside of ACPICA can check
the value of the last successfull _OSI call.  The definitions for
OSI versions are moved to actypes.h so that other components can
access them too.

Based on a patch from Matthew Garrett which in turn was based on
an earlier patch from Seth Forshee.

[rjw: Changelog]
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
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

