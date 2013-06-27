Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab3F0PC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:02:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:42951 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3F0PCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:02:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,952,1363132800"; 
   d="scan'208";a="32217204"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafaell J . Wysocki" <rjw@sisk.pl>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <xen-devel@lists.xen.org>
CC: Ben Guthro <benjamin.guthro@citrix.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH v4 1/5] acpi: Remove need to include linux/acpi.h in common acpica code
Date: Thu, 27 Jun 2013 11:01:59 -0400
Message-ID: <1372345323-9266-2-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372345323-9266-1-git-send-email-benjamin.guthro@citrix.com>
References: <1372345323-9266-1-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the definition of acpi_os_prepare_sleep into the OS services layer header,
and remove the include of linux/acpi.h from common acpica code.

Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
Cc: Rafaell J. Wysocki <rjw@sisk.pl>
Cc: Bob Moore <robert.moore@intel.com>
---
 drivers/acpi/acpica/hwsleep.c |    1 -
 include/acpi/acpiosxf.h       |    6 ++++++
 include/linux/acpi.h          |    3 ---
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index e3828cc..867b947 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -43,7 +43,6 @@
  */
 
 #include <acpi/acpi.h>
-#include <linux/acpi.h>
 #include "accommon.h"
 
 #define _COMPONENT          ACPI_HARDWARE
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 5b3d2bd..c68b779 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -276,4 +276,10 @@ char *acpi_os_get_next_filename(void *dir_handle);
 
 void acpi_os_close_directory(void *dir_handle);
 
+/*
+ * ACPI sleep preparation
+ */
+acpi_status acpi_os_prepare_sleep(u8 sleep_state,
+				  u32 pm1a_control, u32 pm1b_control);
+
 #endif				/* __ACPIOSXF_H__ */
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 17b5b59..709a2f2 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -479,9 +479,6 @@ static inline bool acpi_driver_match_device(struct device *dev,
 #ifdef CONFIG_ACPI
 void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
-
-acpi_status acpi_os_prepare_sleep(u8 sleep_state,
-				  u32 pm1a_control, u32 pm1b_control);
 #ifdef CONFIG_X86
 void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
 #else
-- 
1.7.9.5

