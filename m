Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3JKGro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:47:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:5130 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab3JKGrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:47:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1078,1371106800"; 
   d="scan'208";a="409269235"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH 1/8] ACPI, APEI, CPER: Fix status check during error printing
Date: Fri, 11 Oct 2013 02:32:39 -0400
Message-Id: <1381473166-29303-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit aaf9d93 only catches condition check before print,
but the similar check is needed during printing CPER error
sections.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/acpi/apei/cper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
index 33dc6a0..f827f02 100644
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -353,7 +353,7 @@ void apei_estatus_print(const char *pfx,
 	       cper_severity_str(severity));
 	data_len = estatus->data_length;
 	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
-	while (data_len > sizeof(*gdata)) {
+	while (data_len >= sizeof(*gdata)) {
 		gedata_len = gdata->error_data_length;
 		apei_estatus_print_section(pfx, gdata, sec_no);
 		data_len -= gedata_len + sizeof(*gdata);
-- 
1.8.4.rc3

