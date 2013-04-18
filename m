Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936309Ab3DRSsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:48:11 -0400
Received: from smtp.citrix.com ([66.165.176.89]:5855 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab3DRSsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:48:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,503,1363132800"; 
   d="scan'208";a="20272492"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>
CC: Ben Guthro <benjamin.guthro@citrix.com>
Subject: [PATCH] xen: resolve section mismatch warnings
Date: Thu, 18 Apr 2013 14:48:00 -0400
Message-ID: <1366310880-818-1-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/xen/xen-acpi-processor.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 86b6f69..285e3d5 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -470,7 +470,7 @@ static void free_acpi_perf_data(void)
 	free_percpu(acpi_perf_data);
 }
 
-static int xen_upload_processor_pm_data(void)
+static int __init xen_upload_processor_pm_data(void)
 {
 	struct acpi_processor *pr_backup = NULL;
 	unsigned int i;
@@ -498,7 +498,7 @@ static int xen_upload_processor_pm_data(void)
 	return rc;
 }
 
-static void xen_acpi_processor_resume(void)
+static void __init xen_acpi_processor_resume(void)
 {
 	bitmap_zero(acpi_ids_done, nr_acpi_bits);
 	xen_upload_processor_pm_data();
-- 
1.7.9.5

