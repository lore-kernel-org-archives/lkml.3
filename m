Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaFWIkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:40:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55601 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 102/111] net: filter: fix typo in sparc BPF JIT
Date: Mon, 23 Jun 2014 10:32:17 +0200
Message-Id: <eadac3f2480b4cf83a5a26f1f7795762777d4411.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 569810d1e3278907264f5b115281fca3f0038d53 ]

fix typo in sparc codegen for SKF_AD_IFINDEX and SKF_AD_HATYPE
classic BPF extensions

Fixes: 2809a2087cc4 ("net: filter: Just In Time compiler for sparc")
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/net/bpf_jit_comp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/net/bpf_jit_comp.c b/arch/sparc/net/bpf_jit_comp.c
index 01fe9946d388..649828fe094c 100644
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
2.0.0

