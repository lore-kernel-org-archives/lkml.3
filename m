Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaI3QjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:39:17 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35779 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaI3QjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:39:15 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-mips@linux-mips.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] next: mips: bpf: Fix build failure
Date: Tue, 30 Sep 2014 09:39:00 -0700
Message-Id: <1412095140-10953-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:

arch/mips/net/bpf_jit.c: In function 'build_body':
arch/mips/net/bpf_jit.c:762:6: error: unused variable 'tmp'
cc1: all warnings being treated as errors
make[2]: *** [arch/mips/net/bpf_jit.o] Error 1

Seen when building mips:allmodconfig in -next since next-20140924.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/mips/net/bpf_jit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/net/bpf_jit.c b/arch/mips/net/bpf_jit.c
index 7561833..9b55143 100644
--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -759,7 +759,6 @@ static int build_body(struct jit_ctx *ctx)
 	const struct sock_filter *inst;
 	unsigned int i, off, load_order, condt;
 	u32 k, b_off __maybe_unused;
-	int tmp;
 
 	for (i = 0; i < prog->len; i++) {
 		u16 code;
-- 
1.9.1

