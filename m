Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030385AbaEQSYa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 14:24:30 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61307 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030236AbaEQSY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 14:24:27 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Cox <alan@linux.intel.com>, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] cpupower: Remove redundant error check
Date: Sat, 17 May 2014 20:22:58 +0200
Message-Id: <1400350980-30455-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove double checks, and move the call to print_error to the
first check.  The simplified version of the coccinelle semantic
patch that fixes this issue is as follows:

// <smpl>
@@
expression E; identifier pr; expression list es;
@@
for(...;...;...){
...
-	if (E) break;
+	if (E){
+		pr(es);
+		break;
+	}
...
}
- if(E) pr(es);
// </smpl>

Untested.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 tools/power/cpupower/utils/cpufreq-set.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/power/cpupower/utils/cpufreq-set.c b/tools/power/cpupower/utils/cpufreq-set.c
index a416de8..4e2f35a 100644
--- a/tools/power/cpupower/utils/cpufreq-set.c
+++ b/tools/power/cpupower/utils/cpufreq-set.c
@@ -320,12 +320,11 @@ int cmd_freq_set(int argc, char **argv)
 
 		printf(_("Setting cpu: %d\n"), cpu);
 		ret = do_one_cpu(cpu, &new_pol, freq, policychange);
-		if (ret)
+		if (ret) {
+			print_error();
 			break;
+		}
 	}
 
-	if (ret)
-		print_error();
-
 	return ret;
 }

