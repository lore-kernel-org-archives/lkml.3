Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbaIOXwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:52:03 -0400
Received: from mail-pd0-f201.google.com ([209.85.192.201]:39489 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185AbaIOXvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:51:38 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/24] MIPS: smp-cps: Enable all hardware interrupts on secondary CPUs
Date: Mon, 15 Sep 2014 16:51:10 -0700
Message-Id: <1410825087-5497-8-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently interrupt vectors 2 and 5 are left disabled on secondary CPUs.
Since systems using CPS must also have a GIC, which is responsible for
routing all external interrupts and can map them to any hardware interrupt
vector, enable the remaining vectors.  The two software interrupt vectors
are left disabled since they are not used with CPS.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/kernel/smp-cps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/smp-cps.c b/arch/mips/kernel/smp-cps.c
index e6e16a1..cd20aca 100644
--- a/arch/mips/kernel/smp-cps.c
+++ b/arch/mips/kernel/smp-cps.c
@@ -273,8 +273,8 @@ static void cps_init_secondary(void)
 	if (cpu_has_mipsmt)
 		dmt();
 
-	change_c0_status(ST0_IM, STATUSF_IP3 | STATUSF_IP4 |
-				 STATUSF_IP6 | STATUSF_IP7);
+	change_c0_status(ST0_IM, STATUSF_IP2 | STATUSF_IP3 | STATUSF_IP4 |
+				 STATUSF_IP5 | STATUSF_IP6 | STATUSF_IP7);
 }
 
 static void cps_smp_finish(void)
-- 
2.1.0.rc2.206.gedb03e5

