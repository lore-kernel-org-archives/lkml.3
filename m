Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966911AbaFROVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:21:10 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:9694 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaFROUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:20:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFeRBRVxmIQscbhV4XhWKJEwcWhC0EijmnJw
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFeRBRVxmIQscbhV4XhWKJEwcWhC0EijmnJw
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034696"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests 5/5] x86: Test monitor and mwait on real-mode
Date: Wed, 18 Jun 2014 17:19:54 +0300
Message-Id: <1403101194-23707-6-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101194-23707-1-git-send-email-namit@cs.technion.ac.il>
References: <1403101194-23707-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

monitor and mwait are now considered to behave as nop.  New patch enables
monitor and mwait in realmode as well.  This test checks whether they are
handled as nop in realmode as well.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 x86/realmode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/x86/realmode.c b/x86/realmode.c
index 10c3e03..0a62b5d 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -1671,6 +1671,16 @@ void test_xadd(void)
 	report("xadd", R_AX, outregs.eax == inregs.eax * 2);
 }
 
+void test_monitor_mwait(void)
+{
+	MK_INSN(monitor, "monitor\n\t"
+			 "mwait\n\t");
+	inregs.ecx = 0;
+	inregs.eax = 0;
+	exec_in_big_real_mode(&insn_monitor);
+	report("monitor", 0, 1);
+}
+ 
 
 void realmode_start(void)
 {
@@ -1721,6 +1731,7 @@ void realmode_start(void)
 	test_smsw();
 	test_nopl();
 	test_xadd();
+	test_monitor_mwait();
 	test_perf_loop();
 	test_perf_mov();
 	test_perf_arith();
-- 
1.9.1

