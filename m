Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbaGWCrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:47:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:30838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbaGWCd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:33:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="547516139"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RFC PATCH v1 21/70] powerpc, powermac, smp: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:58:57 -0400
Message-Id: <1406080786-3938-22-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from powermac/smp.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 arch/powerpc/platforms/powermac/smp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index 5cbd4d6..980605f 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -861,9 +861,8 @@ static int smp_core99_cpu_notify(struct notifier_block *self,
 {
 	int rc;
 
-	switch(action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		/* Open i2c bus if it was used for tb sync */
 		if (pmac_tb_clock_chip_host) {
 			rc = pmac_i2c_open(pmac_tb_clock_chip_host, 1);
@@ -875,9 +874,11 @@ static int smp_core99_cpu_notify(struct notifier_block *self,
 		break;
 	case CPU_ONLINE:
 	case CPU_UP_CANCELED:
-		/* Close i2c bus if it was used for tb sync */
-		if (pmac_tb_clock_chip_host)
-			pmac_i2c_close(pmac_tb_clock_chip_host);
+		if (!(action & CPU_TASKS_FROZEN)) {
+			/* Close i2c bus if it was used for tb sync */
+			if (pmac_tb_clock_chip_host)
+				pmac_i2c_close(pmac_tb_clock_chip_host);
+		}
 		break;
 	default:
 		break;
-- 
2.0.0.rc2

