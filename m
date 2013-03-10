Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3CJCQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 21:16:20 -0500
Received: from intranet.asianux.com ([58.214.24.6]:22215 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3CJCQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 21:16:19 -0500
X-Spam-Score: -100.8
Message-ID: <513BECDA.3030803@asianux.com>
Date: Sun, 10 Mar 2013 10:15:54 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>, mgherzan@gmail.com,
        nschichan@freebox.fr, daniel.borkmann@tik.ee.ethz.ch
CC: David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM:net: an issue for k which is u32, never < 0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  k is u32 which never < 0, need type cast, or cause issue.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm/net/bpf_jit_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index 6828ef6..a0bd8a7 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -576,7 +576,7 @@ load_ind:
 			/* x = ((*(frame + k)) & 0xf) << 2; */
 			ctx->seen |= SEEN_X | SEEN_DATA | SEEN_CALL;
 			/* the interpreter should deal with the negative K */
-			if (k < 0)
+			if ((int)k < 0)
 				return -1;
 			/* offset in r1: we might have to take the slow path */
 			emit_mov_i(r_off, k, ctx);
-- 
1.7.7.6
