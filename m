Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaJIVIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:08:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59165 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349AbaJIVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Lee, Chun-Yi" <jlee@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 033/163] ACPI / RTC: Fix CMOS RTC opregion handler accesses to wrong addresses
Date: Thu,  9 Oct 2014 14:00:58 -0700
Message-Id: <1412888588-26755-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>

commit 9389f46e9782ea5e56fbd7b2e59ba7c08f3ba86b upstream.

The value64 parameter is an u64 point that used to transfer the value
for write to CMOS, or used to return the value that's read from CMOS.

The value64 is an u64 point, so don't need get address again. It causes
acpi_cmos_rtc_space_handler always return 0 to reader and didn't write
expected value to CMOS.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/acpi_cmos_rtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_cmos_rtc.c b/drivers/acpi/acpi_cmos_rtc.c
index 84190ed..aff69d9 100644
--- a/drivers/acpi/acpi_cmos_rtc.c
+++ b/drivers/acpi/acpi_cmos_rtc.c
@@ -35,7 +35,7 @@ acpi_cmos_rtc_space_handler(u32 function, acpi_physical_address address,
 		      void *handler_context, void *region_context)
 {
 	int i;
-	u8 *value = (u8 *)&value64;
+	u8 *value = (u8 *)value64;
 
 	if (address > 0xff || !value64)
 		return AE_BAD_PARAMETER;
-- 
1.9.1

