Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966976Ab3DQWm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 18:42:57 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:33851 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966963Ab3DQWmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 18:42:38 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 2/2] tools/power turbostat: additional Haswell CPU-id
Date: Wed, 17 Apr 2013 18:42:17 -0400
Message-Id: <149c2319c6316d979de90ce2c8665e9c02d5927b.1366238380.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.2.1.422.gdcd8c09
In-Reply-To: <1366238537-14443-1-git-send-email-lenb@kernel.org>
References: <1366238537-14443-1-git-send-email-lenb@kernel.org>
In-Reply-To: <0b15841b0bbbde75134a777c543dc51fe6187108.1366238380.git.len.brown@intel.com>
References: <0b15841b0bbbde75134a777c543dc51fe6187108.1366238380.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

There is an additional HSW CPU-id, 0x46,
which has C-states exactly like CPU-id 0x45.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 6f3214e..321e066 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1421,6 +1421,7 @@ int has_nehalem_turbo_ratio_limit(unsigned int family, unsigned int model)
 	case 0x3C:	/* HSW */
 	case 0x3F:	/* HSW */
 	case 0x45:	/* HSW */
+	case 0x46:	/* HSW */
 		return 1;
 	case 0x2E:	/* Nehalem-EX Xeon - Beckton */
 	case 0x2F:	/* Westmere-EX Xeon - Eagleton */
@@ -1515,6 +1516,7 @@ void rapl_probe(unsigned int family, unsigned int model)
 	case 0x3C:	/* HSW */
 	case 0x3F:	/* HSW */
 	case 0x45:	/* HSW */
+	case 0x46:	/* HSW */
 		do_rapl = RAPL_PKG | RAPL_CORES | RAPL_GFX;
 		break;
 	case 0x2D:
@@ -1754,6 +1756,7 @@ int is_snb(unsigned int family, unsigned int model)
 	case 0x3C:	/* HSW */
 	case 0x3F:	/* HSW */
 	case 0x45:	/* HSW */
+	case 0x46:	/* HSW */
 		return 1;
 	}
 	return 0;
@@ -2276,7 +2279,7 @@ int main(int argc, char **argv)
 	cmdline(argc, argv);
 
 	if (verbose)
-		fprintf(stderr, "turbostat v3.2 February 11, 2013"
+		fprintf(stderr, "turbostat v3.3 March 15, 2013"
 			" - Len Brown <lenb@kernel.org>\n");
 
 	turbostat_init();
-- 
1.8.2.1.422.gdcd8c09

