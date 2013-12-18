Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab3LRG54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:57:56 -0500
Received: from mga14.intel.com ([143.182.124.37]:58557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab3LRG5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:57:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="328666815"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Peter Huewe <peterhuewe@gmx.de>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jiri Kosina <jkosina@suse.cz>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>
Subject: [RFC Patch v1 07/13] ACPI, TPM: matching node name instead of full path when searching for TPM device
Date: Wed, 18 Dec 2013 14:58:15 +0800
Message-Id: <1387349901-3391-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When searching ACPI object for TPM device, it should match current
ACPI object name instead of the full path.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/char/tpm/tpm_ppi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index e1f3337..1e9cc11 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -30,7 +30,7 @@ static acpi_status ppi_callback(acpi_handle handle, u32 level, void *context,
 	acpi_status status = AE_OK;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 
-	if (ACPI_SUCCESS(acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer))) {
+	if (ACPI_SUCCESS(acpi_get_name(handle, ACPI_SINGLE_NAME, &buffer))) {
 		if (strstr(buffer.pointer, context) != NULL) {
 			*return_value = handle;
 			status = AE_CTRL_TERMINATE;
-- 
1.7.10.4

