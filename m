Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3BAEUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 23:20:09 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:43156 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab3BAET5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 23:19:57 -0500
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2013 23:19:57 EST
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 2/4] tools/power turbostat: support HSW
Date: Thu, 31 Jan 2013 23:11:34 -0500
Message-Id: <cdc0f0905ddbbfd269fc44fcfc4725eab9e09709.1359691799.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.2.422.g08c0e7f
In-Reply-To: <1359691896-23567-1-git-send-email-lenb@kernel.org>
References: <1359691896-23567-1-git-send-email-lenb@kernel.org>
In-Reply-To: <9a38405338d7464c852c4524465f84f8a2ac22fb.1359691799.git.len.brown@intel.com>
References: <9a38405338d7464c852c4524465f84f8a2ac22fb.1359691799.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

This patch enables turbostat to run properly on the
next-generation Intel(R) Microarchitecture, code named Haswell (HSW).

HSW supports the BCLK and counters found in SNB.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index ce6d460..b326878 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1397,6 +1397,9 @@ int has_nehalem_turbo_ratio_limit(unsigned int family, unsigned int model)
 	case 0x2D:	/* SNB Xeon */
 	case 0x3A:	/* IVB */
 	case 0x3E:	/* IVB Xeon */
+	case 0x3C:	/* HSW */
+	case 0x3F:	/* HSW */
+	case 0x45:	/* HSW */
 		return 1;
 	case 0x2E:	/* Nehalem-EX Xeon - Beckton */
 	case 0x2F:	/* Westmere-EX Xeon - Eagleton */
@@ -1488,6 +1491,9 @@ void rapl_probe(unsigned int family, unsigned int model)
 	switch (model) {
 	case 0x2A:
 	case 0x3A:
+	case 0x3C:	/* HSW */
+	case 0x3F:	/* HSW */
+	case 0x45:	/* HSW */
 		do_rapl = RAPL_PKG | RAPL_CORES | RAPL_GFX;
 		break;
 	case 0x2D:
@@ -1724,6 +1730,9 @@ int is_snb(unsigned int family, unsigned int model)
 	case 0x2D:
 	case 0x3A:	/* IVB */
 	case 0x3E:	/* IVB Xeon */
+	case 0x3C:	/* HSW */
+	case 0x3F:	/* HSW */
+	case 0x45:	/* HSW */
 		return 1;
 	}
 	return 0;
@@ -2248,7 +2257,7 @@ int main(int argc, char **argv)
 	cmdline(argc, argv);
 
 	if (verbose)
-		fprintf(stderr, "turbostat v3.0 November 23, 2012"
+		fprintf(stderr, "turbostat v3.1 January 8, 2013"
 			" - Len Brown <lenb@kernel.org>\n");
 
 	turbostat_init();
-- 
1.8.1.2.422.g08c0e7f

