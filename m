Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaB0IrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:47:23 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:41489 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaB0IrW convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Thu, 27 Feb 2014 03:47:22 -0500
Message-Id: <530F09B6020000780011FBEB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 27 Feb 2014 08:47:34 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, "Jan Beulich" <JBeulich@suse.com>,
        <hpa@zytor.com>
Cc: <davem@davemloft.net>, <dborkman@redhat.com>, <ffusco@redhat.com>,
        <tgraf@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] x86/hash: swap arguments passed to crc32_u32()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... to match the function's parameters. While reportedly commutative,
using the proper order allows for leveraging the instruction permitting
the source operand to be in memory.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Francesco Fusco <ffusco@redhat.com>
Cc: Thomas Graf <tgraf@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
---
v2: now swapping arguments rather than parameters, as requested by hpa
---
 arch/x86/lib/hash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 3.14-rc4-x86-hash-crc32.orig/arch/x86/lib/hash.c
+++ 3.14-rc4-x86-hash-crc32/arch/x86/lib/hash.c
@@ -53,7 +53,7 @@ static u32 intel_crc4_2_hash(const void 
 	u32 i, tmp = 0;
 
 	for (i = 0; i < len / 4; i++)
-		seed = crc32_u32(*p32++, seed);
+		seed = crc32_u32(seed, *p32++);
 
 	switch (3 - (len & 0x03)) {
 	case 0:
@@ -64,7 +64,7 @@ static u32 intel_crc4_2_hash(const void 
 		/* fallthrough */
 	case 2:
 		tmp |= *((const u8 *) p32);
-		seed = crc32_u32(tmp, seed);
+		seed = crc32_u32(seed, tmp);
 	default:
 		break;
 	}
@@ -78,7 +78,7 @@ static u32 intel_crc4_2_hash2(const u32 
 	u32 i;
 
 	for (i = 0; i < len; i++)
-		seed = crc32_u32(*p32++, seed);
+		seed = crc32_u32(seed, *p32++);
 
 	return seed;
 }



