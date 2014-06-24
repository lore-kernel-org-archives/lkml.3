Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965428AbaFXQI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:08:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaFXPzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:55:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 11/61] net: filter: fix typo in sparc BPF JIT
Date: Tue, 24 Jun 2014 11:50:54 -0400
Message-Id: <20140624154953.290821071@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@plumgrid.com>

[ Upstream commit 569810d1e3278907264f5b115281fca3f0038d53 ]

fix typo in sparc codegen for SKF_AD_IFINDEX and SKF_AD_HATYPE
classic BPF extensions

Fixes: 2809a2087cc4 ("net: filter: Just In Time compiler for sparc")
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/net/bpf_jit_comp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/sparc/net/bpf_jit_comp.c
+++ b/arch/sparc/net/bpf_jit_comp.c
@@ -83,9 +83,9 @@ static void bpf_flush_icache(void *start
 #define BNE		(F2(0, 2) | CONDNE)
 
 #ifdef CONFIG_SPARC64
-#define BNE_PTR		(F2(0, 1) | CONDNE | (2 << 20))
+#define BE_PTR		(F2(0, 1) | CONDE | (2 << 20))
 #else
-#define BNE_PTR		BNE
+#define BE_PTR		BNE
 #endif
 
 #define SETHI(K, REG)	\
@@ -600,7 +600,7 @@ void bpf_jit_compile(struct sk_filter *f
 			case BPF_S_ANC_IFINDEX:
 				emit_skb_loadptr(dev, r_A);
 				emit_cmpi(r_A, 0);
-				emit_branch(BNE_PTR, cleanup_addr + 4);
+				emit_branch(BE_PTR, cleanup_addr + 4);
 				emit_nop();
 				emit_load32(r_A, struct net_device, ifindex, r_A);
 				break;
@@ -613,7 +613,7 @@ void bpf_jit_compile(struct sk_filter *f
 			case BPF_S_ANC_HATYPE:
 				emit_skb_loadptr(dev, r_A);
 				emit_cmpi(r_A, 0);
-				emit_branch(BNE_PTR, cleanup_addr + 4);
+				emit_branch(BE_PTR, cleanup_addr + 4);
 				emit_nop();
 				emit_load16(r_A, struct net_device, type, r_A);
 				break;


