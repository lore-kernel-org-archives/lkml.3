Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaBLSCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:02:31 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47993 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbaBLSBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:01:39 -0500
From: dirk.brandewie@gmail.com
To: linux-pm@vger.kernel.org, rjw@rjwysocki.net
Cc: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 5/5] intel_pstate: Add support for Baytrail turbo P states
Date: Wed, 12 Feb 2014 10:01:07 -0800
Message-Id: <1392228067-14817-6-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

A documentation update exposed the existance of the turbo ratio
register. Update baytrail support to use the turbo range.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index ff45ce1..ea58eb6 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -34,8 +34,10 @@
 
 #define SAMPLE_COUNT		3
 
-#define BYT_RATIOS	0x66a
-#define BYT_VIDS        0x66b
+#define BYT_RATIOS		0x66a
+#define BYT_VIDS		0x66b
+#define BYT_TURBO_RATIOS	0x66c
+
 
 #define FRAC_BITS 8
 #define int_tofp(X) ((int64_t)(X) << FRAC_BITS)
@@ -366,6 +368,13 @@ static int byt_get_max_pstate(void)
 	return (value >> 16) & 0xFF;
 }
 
+static int byt_get_turbo_pstate(void)
+{
+	u64 value;
+	rdmsrl(BYT_TURBO_RATIOS, value);
+	return value & 0x3F;
+}
+
 static void byt_set_pstate(struct cpudata *cpudata, int pstate)
 {
 	u64 val;
@@ -468,7 +477,7 @@ static struct cpu_defaults byt_params = {
 	.funcs = {
 		.get_max = byt_get_max_pstate,
 		.get_min = byt_get_min_pstate,
-		.get_turbo = byt_get_max_pstate,
+		.get_turbo = byt_get_turbo_pstate,
 		.set = byt_set_pstate,
 		.get_vid = byt_get_vid,
 	},
-- 
1.8.3.1

