Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaG3EYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:24:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:53280 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbaG3EVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:21:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="551067930"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Sascha Wildner <swildner@gmail.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 05/17] ACPICA: Remove some extraneous printf arguments.
Date: Wed, 30 Jul 2014 12:20:53 +0800
Message-Id: <d06fd3f3dc2250f62859273109b346b12846ce5f.1406689494.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Wildner <swildner@gmail.com>

Arguments that have no associated % format specifier.
Apparently these are not caught by any current compilers.
ACPICA BZ 1090. Sascha Wildner.

Currently this patch only affects applications under the
toos/power/acpi folder.

Reference: https://bugs.acpica.org/show_bug.cgi?id=1090
Signed-off-by: Sascha Wildner <swildner@gmail.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/exdump.c   |    6 +++---
 drivers/acpi/acpica/utfileio.c |    3 +--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/exdump.c b/drivers/acpi/acpica/exdump.c
index 925202a..0f23c3f 100644
--- a/drivers/acpi/acpica/exdump.c
+++ b/drivers/acpi/acpica/exdump.c
@@ -494,7 +494,7 @@ acpi_ex_dump_object(union acpi_operand_object *obj_desc,
 				}
 			}
 
-			acpi_os_printf("\n", next);
+			acpi_os_printf("\n");
 			break;
 
 		case ACPI_EXD_HDLR_LIST:
@@ -528,7 +528,7 @@ acpi_ex_dump_object(union acpi_operand_object *obj_desc,
 				}
 			}
 
-			acpi_os_printf("\n", next);
+			acpi_os_printf("\n");
 			break;
 
 		case ACPI_EXD_RGN_LIST:
@@ -562,7 +562,7 @@ acpi_ex_dump_object(union acpi_operand_object *obj_desc,
 				}
 			}
 
-			acpi_os_printf("\n", next);
+			acpi_os_printf("\n");
 			break;
 
 		case ACPI_EXD_NODE:
diff --git a/drivers/acpi/acpica/utfileio.c b/drivers/acpi/acpica/utfileio.c
index bdf9914..4e263a8 100644
--- a/drivers/acpi/acpica/utfileio.c
+++ b/drivers/acpi/acpica/utfileio.c
@@ -201,8 +201,7 @@ acpi_ut_read_table(FILE * fp,
 			status = fl_check_for_ascii(fp, NULL, FALSE);
 			if (ACPI_SUCCESS(status)) {
 				acpi_os_printf
-				    ("File appears to be ASCII only, must be binary\n",
-				     table_header.length, file_size);
+				    ("File appears to be ASCII only, must be binary\n");
 			}
 #endif
 			return (AE_BAD_HEADER);
-- 
1.7.10

