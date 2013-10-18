Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3JRInS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 04:43:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:31583 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab3JRIip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 04:38:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,520,1378882800"; 
   d="scan'208";a="376533858"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com
Cc: arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH v3 1/9] ACPI, APEI, CPER: Fix status check during error printing
Date: Fri, 18 Oct 2013 04:23:36 -0400
Message-Id: <1382084624-10857-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit aaf9d93 only catches condition check before print,
but the similar check is needed during printing CPER error
sections.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
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

