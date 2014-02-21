Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaBUKeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:34:03 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:45235 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaBUKeA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 21 Feb 2014 05:34:00 -0500
Message-Id: <530739A5020000780011E2E4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 21 Feb 2014 10:33:57 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <davem@davemloft.net>, <dborkman@redhat.com>, <ffusco@redhat.com>,
        <tgraf@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86/hash: cleanup
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- simplify switch statement
- add __init annotation to setup_arch_fast_hash()

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Francesco Fusco <ffusco@redhat.com>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Thomas Graf <tgraf@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/x86/lib/hash.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- 3.14-rc3-x86-hash-crc32.orig/arch/x86/lib/hash.c
+++ 3.14-rc3-x86-hash-crc32/arch/x86/lib/hash.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/hash.h>
+#include <linux/init.h>
 
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
@@ -55,17 +56,16 @@ static u32 intel_crc4_2_hash(const void 
 	for (i = 0; i < len / 4; i++)
 		seed = crc32_u32(*p32++, seed);
 
-	switch (3 - (len & 0x03)) {
-	case 0:
+	switch (len & 3) {
+	case 3:
 		tmp |= *((const u8 *) p32 + 2) << 16;
 		/* fallthrough */
-	case 1:
+	case 2:
 		tmp |= *((const u8 *) p32 + 1) << 8;
 		/* fallthrough */
-	case 2:
+	case 1:
 		tmp |= *((const u8 *) p32);
 		seed = crc32_u32(tmp, seed);
-	default:
 		break;
 	}
 
@@ -83,7 +83,7 @@ static u32 intel_crc4_2_hash2(const u32 
 	return seed;
 }
 
-void setup_arch_fast_hash(struct fast_hash_ops *ops)
+void __init setup_arch_fast_hash(struct fast_hash_ops *ops)
 {
 	if (cpu_has_xmm4_2) {
 		ops->hash  = intel_crc4_2_hash;



