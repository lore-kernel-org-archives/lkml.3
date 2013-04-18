Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936498Ab3DRVj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 17:39:56 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:11581 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936039Ab3DRVjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 17:39:55 -0400
X-IronPort-AV: E=Sophos;i="4.87,504,1363132800"; 
   d="scan'208";a="19355411"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>
CC: Ben Guthro <benjamin.guthro@citrix.com>
Subject: [PATCH] xen: resolve section mismatch warnings in xen-acpi-processor
Date: Thu, 18 Apr 2013 17:39:48 -0400
Message-ID: <1366321188-17934-1-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following resolves a section mismatch warning below in xen-acpi-processor introduced by
3fac10145b766a2244422788f62dc35978613fd8 [13/13] xen: Re-upload processor PM data to hypervisor after S3 resume (v2)

Warning:
WARNING: drivers/xen/built-in.o(.text+0x2056a): Section mismatch in reference from the function xen_upload_processor_pm_data() to the function .init.text:read_acpi_id()
   The function xen_upload_processor_pm_data() references
   the function __init read_acpi_id().
   This is often because xen_upload_processor_pm_data lacks a __init
   annotation or the annotation of read_acpi_id is wrong.

Reported-by: kbuild test robot <fengguang.wu@intel.com>

Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
---
 drivers/xen/xen-acpi-processor.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 86b6f69..e69eb3b 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -330,7 +330,7 @@ static unsigned int __init get_max_acpi_id(void)
  * for_each_[present|online]_cpu macros which are banded to the virtual
  * CPU amount.
  */
-static acpi_status __init
+static acpi_status
 read_acpi_id(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
 	u32 acpi_id;
@@ -385,7 +385,7 @@ read_acpi_id(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 	return AE_OK;
 }
-static int __init check_acpi_ids(struct acpi_processor *pr_backup)
+static int check_acpi_ids(struct acpi_processor *pr_backup)
 {
 
 	if (!pr_backup)
-- 
1.7.9.5

