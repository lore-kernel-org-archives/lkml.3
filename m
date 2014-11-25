Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaKYFAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 00:00:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24533 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaKYFAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 00:00:38 -0500
From: Ethan Zhao <ethan.zhao@oracle.com>
To: linda.knippers@hp.com, viresh.kumar@linaro.org, rjw@rjwysocki.net,
        corbet@lwn.net, dirk.j.brandewie@intel.com
Cc: linux-doc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ethan.kernel@gmail.com,
        Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH 2/2 v3] intel_pstate: add kernel parameter to enable loading on  Sun X86 servers.
Date: Tue, 25 Nov 2014 13:59:38 +0900
Message-Id: <1416891578-14171-3-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416891578-14171-1-git-send-email-ethan.zhao@oracle.com>
References: <1416891578-14171-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To force loading on Oracle Sun X86 servers, provide one kernel command line
parameter

  intel_pstate = onora

For those who be aware of the risk doing so.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 v2: change to hardware vendor specific naming parameter.

 Documentation/kernel-parameters.txt | 3 +++
 drivers/cpufreq/intel_pstate.c      | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 479f332..e4b1b81 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1446,6 +1446,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 		       disable
 		         Do not enable intel_pstate as the default
 		         scaling driver for the supported processors
+		       onora
+		         Enable loading intel_pstate on Oracle Sun Servers(X86).
+			 only for those who be aware of the risk.
 
 	intremap=	[X86-64, Intel-IOMMU]
 			on	enable Interrupt Remapping (default)
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index fa67fb3..e49b050 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -866,6 +866,7 @@ static struct cpufreq_driver intel_pstate_driver = {
 };
 
 static int __initdata no_load;
+static unsigned int  load_on_sun;
 
 static int intel_pstate_msrs_not_valid(void)
 {
@@ -1005,7 +1006,8 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
 		if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
 			!strncmp(hdr.oem_table_id, v_info->oem_table_id,
 				ACPI_OEM_TABLE_ID_SIZE) &&
-			intel_pstate_has_acpi_ppc())
+			intel_pstate_has_acpi_ppc() &&
+			!load_on_sun)
 			return true;
 	}
 
@@ -1080,6 +1082,8 @@ static int __init intel_pstate_setup(char *str)
 
 	if (!strcmp(str, "disable"))
 		no_load = 1;
+	if (!strcmp(str, "onora"))
+		load_on_sun = 1;
 	return 0;
 }
 early_param("intel_pstate", intel_pstate_setup);
-- 
1.8.3.1

