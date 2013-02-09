Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947679Ab3BIBIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:08:52 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:64724 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947640Ab3BIBIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:49 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 12/16] tools/power turbostat: support Haswell
Date: Fri,  8 Feb 2013 20:08:16 -0500
Message-Id: <70b43400bc290764b49ff3497a9824604c66c409.1360371180.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360372100-28482-1-git-send-email-lenb@kernel.org>
References: <1360372100-28482-1-git-send-email-lenb@kernel.org>
In-Reply-To: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
References: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

This patch enables turbostat to run properly on the
next-generation Intel(R) Microarchitecture, code named "Haswell" (HSW).

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
1.8.1.3.535.ga923c31

