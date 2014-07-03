Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030403AbaGCJYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:24:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52326 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030336AbaGCJYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 143/198] net: filter: fix typo in sparc BPF JIT
Date: Thu,  3 Jul 2014 10:19:46 +0100
Message-Id: <1404379241-8590-144-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@plumgrid.com>

commit 569810d1e3278907264f5b115281fca3f0038d53 upstream.

fix typo in sparc codegen for SKF_AD_IFINDEX and SKF_AD_HATYPE
classic BPF extensions

Fixes: 2809a2087cc4 ("net: filter: Just In Time compiler for sparc")
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/net/bpf_jit_comp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/net/bpf_jit_comp.c b/arch/sparc/net/bpf_jit_comp.c
index dface38a2415..f90ea700a4b8 100644
--- a/arch/sparc/net/bpf_jit_comp.c
+++ b/arch/sparc/net/bpf_jit_comp.c
@@ -83,9 +83,9 @@ static void bpf_flush_icache(void *start_, void *end_)
 #define BNE		(F2(0, 2) | CONDNE)
 
 #ifdef CONFIG_SPARC64
-#define BNE_PTR		(F2(0, 1) | CONDNE | (2 << 20))
+#define BE_PTR		(F2(0, 1) | CONDE | (2 << 20))
 #else
-#define BNE_PTR		BNE
+#define BE_PTR		BNE
 #endif
 
 #define SETHI(K, REG)	\
@@ -600,7 +600,7 @@ void bpf_jit_compile(struct sk_filter *fp)
 			case BPF_S_ANC_IFINDEX:
 				emit_skb_loadptr(dev, r_A);
 				emit_cmpi(r_A, 0);
-				emit_branch(BNE_PTR, cleanup_addr + 4);
+				emit_branch(BE_PTR, cleanup_addr + 4);
 				emit_nop();
 				emit_load32(r_A, struct net_device, ifindex, r_A);
 				break;
@@ -613,7 +613,7 @@ void bpf_jit_compile(struct sk_filter *fp)
 			case BPF_S_ANC_HATYPE:
 				emit_skb_loadptr(dev, r_A);
 				emit_cmpi(r_A, 0);
-				emit_branch(BNE_PTR, cleanup_addr + 4);
+				emit_branch(BE_PTR, cleanup_addr + 4);
 				emit_nop();
 				emit_load16(r_A, struct net_device, type, r_A);
 				break;
-- 
1.9.1

