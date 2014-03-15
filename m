Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbaCOUDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 16:03:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbaCOUDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 16:03:46 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests 1/2] emulator: movaps
Date: Sat, 15 Mar 2014 21:03:37 +0100
Message-Id: <1394913818-6616-2-git-send-email-imammedo@redhat.com>
In-Reply-To: <1394913818-6616-1-git-send-email-imammedo@redhat.com>
References: <1394913818-6616-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 x86/emulator.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index 2e25dd8..1296a99 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -645,6 +645,13 @@ static void test_sse(sse_union *mem)
     mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
     asm("movdqu %1, %0" : "=x"(v.sse) : "m"(*mem));
     report("movdqu (write)", sseeq(mem, &v));
+
+    v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
+    asm("movaps %1, %0" : "=m"(*mem) : "x"(v.sse));
+    report("movaps (read)", sseeq(mem, &v));
+    mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+    asm("movaps %1, %0" : "=x"(v.sse) : "m"(*mem));
+    report("movaps (write)", sseeq(&v, mem));
 }
 
 static void test_mmx(uint64_t *mem)
-- 
1.8.5.3

