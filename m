Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbaDWGyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:54:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:27906 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbaDWGx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:53:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="525374140"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 1/5] ACPICA: OSL: Add direct inclusion of extra header.
Date: Wed, 23 Apr 2014 14:53:52 +0800
Message-Id: <43884d194fd55ca9124078d3374ec4cf4a8026ef.1398232408.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398232408.git.lv.zheng@intel.com>
References: <cover.1396930406.git.lv.zheng@intel.com> <cover.1398232408.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a linuxized result of an ACPICA commit to upgrade the extra
header mechanism.

This patch enhances the extra header solution to allow Linux to use
ACPI_USE_NATIVE_INTERFACE_HEADER and the file name can be automatically
replaced during ACPICA release process. Using this way, the rest of the
ACPICA users needn't know the name of the extra header file. Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/acpi.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/acpi/acpi.h b/include/acpi/acpi.h
index ca0cb60..682398b 100644
--- a/include/acpi/acpi.h
+++ b/include/acpi/acpi.h
@@ -62,8 +62,8 @@
 #include <acpi/acrestyp.h>		/* Resource Descriptor structs */
 #include <acpi/acpiosxf.h>		/* OSL interfaces (ACPICA-to-OS) */
 #include <acpi/acpixf.h>		/* ACPI core subsystem external interfaces */
-#ifdef ACPI_NATIVE_INTERFACE_HEADER
-#include ACPI_NATIVE_INTERFACE_HEADER
+#ifdef ACPI_USE_NATIVE_INTERFACE_HEADER
+#include <acpi/acpi_opt.h>
 #endif
 
 #endif				/* __ACPI_H__ */
-- 
1.7.10

