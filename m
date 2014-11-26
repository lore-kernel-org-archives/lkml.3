Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaKZJOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:14:52 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:43601 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaKZJOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:14:49 -0500
From: Quentin Lambert <lambert.quentin@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Quentin Lambert <lambert.quentin@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: bpf_jit_comp: simplify trivial boolean return
Date: Wed, 26 Nov 2014 10:18:17 +0100
Message-Id: <1416993497-27225-1-git-send-email-lambert.quentin@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove if then else statements preceding
boolean return. Occurences were found using
Coccinelle.

The semantic patch used was:

@@
expression expr;
@@


- if ( expr )
-	return true;
- else
-	return false;
+ return expr;

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>

---
 arch/x86/net/bpf_jit_comp.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 3f62734..1542f39 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -135,11 +135,9 @@ static const int reg2hex[] = {
  */
 static inline bool is_ereg(u32 reg)
 {
-	if (reg == BPF_REG_5 || reg == AUX_REG ||
-	    (reg >= BPF_REG_7 && reg <= BPF_REG_9))
-		return true;
-	else
-		return false;
+	return (reg == BPF_REG_5 ||
+		reg == AUX_REG ||
+		(reg >= BPF_REG_7 && reg <= BPF_REG_9));
 }
 
 /* add modifiers if 'reg' maps to x64 registers r8..r15 */

