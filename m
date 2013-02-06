Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3BFIUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:20:00 -0500
Received: from ozlabs.org ([203.10.76.45]:43649 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab3BFIT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:19:26 -0500
From: Michael Ellerman <michael@ellerman.id.au>
To: <penberg@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] kvm tools: powerpc: Add cpu info entry for POWER8
Date: Wed,  6 Feb 2013 19:19:15 +1100
Message-Id: <1360138756-1991-5-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360138756-1991-1-git-send-email-michael@ellerman.id.au>
References: <1360138756-1991-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should hard-code less of this stuff, but for now this works.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/powerpc/cpu_info.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/kvm/powerpc/cpu_info.c b/tools/kvm/powerpc/cpu_info.c
index 11ca14e..a9dfe39 100644
--- a/tools/kvm/powerpc/cpu_info.c
+++ b/tools/kvm/powerpc/cpu_info.c
@@ -35,6 +35,20 @@ static struct cpu_info cpu_power7_info = {
 	},
 };
 
+/* POWER8 */
+
+static struct cpu_info cpu_power8_info = {
+	.name = "POWER8",
+	.tb_freq = 512000000,
+	.d_bsize = 128,
+	.i_bsize = 128,
+	.flags = CPUINFO_FLAG_DFP | CPUINFO_FLAG_VSX | CPUINFO_FLAG_VMX,
+	.mmu_info = {
+		.flags = KVM_PPC_PAGE_SIZES_REAL | KVM_PPC_1T_SEGMENTS,
+		.slb_size = 32,
+	},
+};
+
 /* PPC970/G5 */
 
 static struct cpu_info cpu_970_info = {
@@ -52,6 +66,7 @@ static struct pvr_info host_pvr_info[] = {
 	{ 0xffffffff, 0x0f000003, &cpu_power7_info },
 	{ 0xffff0000, 0x003f0000, &cpu_power7_info },
 	{ 0xffff0000, 0x004a0000, &cpu_power7_info },
+	{ 0xffff0000, 0x004b0000, &cpu_power8_info },
 	{ 0xffff0000, 0x00390000, &cpu_970_info },
 	{ 0xffff0000, 0x003c0000, &cpu_970_info },
         { 0xffff0000, 0x00440000, &cpu_970_info },
-- 
1.7.10.4

