Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030787AbaGCJtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:49:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52176 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030185AbaGCJXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 120/198] powerpc: Make logical to real cpu mapping code endian safe
Date: Thu,  3 Jul 2014 10:19:23 +0100
Message-Id: <1404379241-8590-121-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit ac13282dff13cd0f4da0f0ccb134bc29bfa10255 upstream.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/setup-common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 63d051f5b7a5..ee0e0553ae0e 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -436,7 +436,7 @@ void __init smp_setup_cpu_maps(void)
 	DBG("smp_setup_cpu_maps()\n");
 
 	while ((dn = of_find_node_by_type(dn, "cpu")) && cpu < nr_cpu_ids) {
-		const int *intserv;
+		const __be32 *intserv;
 		int j, len;
 
 		DBG("  * %s...\n", dn->full_name);
@@ -456,9 +456,9 @@ void __init smp_setup_cpu_maps(void)
 
 		for (j = 0; j < nthreads && cpu < nr_cpu_ids; j++) {
 			DBG("    thread %d -> cpu %d (hard id %d)\n",
-			    j, cpu, intserv[j]);
+			    j, cpu, be32_to_cpu(intserv[j]));
 			set_cpu_present(cpu, true);
-			set_hard_smp_processor_id(cpu, intserv[j]);
+			set_hard_smp_processor_id(cpu, be32_to_cpu(intserv[j]));
 			set_cpu_possible(cpu, true);
 			cpu++;
 		}
-- 
1.9.1

