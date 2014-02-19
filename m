Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaBSGCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:02:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:36553 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbaBSGCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:02:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="483861801"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Patch v2 4/5] acpi_processor: use acpi_evaluate_ost() to replace open-coded version
Date: Wed, 19 Feb 2014 14:02:18 +0800
Message-Id: <1392789739-32317-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392789739-32317-1-git-send-email-jiang.liu@linux.intel.com>
References: <1392789739-32317-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use public function acpi_evaluate_ost() to replace open-coded
version of evaluating ACPI _OST method.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/processor_perflib.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index ff90054..cfc8aba 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -156,17 +156,9 @@ static int acpi_processor_get_platform_limit(struct acpi_processor *pr)
  */
 static void acpi_processor_ppc_ost(acpi_handle handle, int status)
 {
-	union acpi_object params[2] = {
-		{.type = ACPI_TYPE_INTEGER,},
-		{.type = ACPI_TYPE_INTEGER,},
-	};
-	struct acpi_object_list arg_list = {2, params};
-
-	if (acpi_has_method(handle, "_OST")) {
-		params[0].integer.value = ACPI_PROCESSOR_NOTIFY_PERFORMANCE;
-		params[1].integer.value =  status;
-		acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
-	}
+	if (acpi_has_method(handle, "_OST"))
+		acpi_evaluate_ost(handle, ACPI_PROCESSOR_NOTIFY_PERFORMANCE,
+				  status, NULL);
 }
 
 int acpi_processor_ppc_has_changed(struct acpi_processor *pr, int event_flag)
-- 
1.7.10.4

