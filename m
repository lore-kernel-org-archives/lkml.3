Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaBUKda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:33:30 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:45218 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbaBUKd3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 21 Feb 2014 05:33:29 -0500
Message-Id: <53073986020000780011E2E1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 21 Feb 2014 10:33:26 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <davem@davemloft.net>, <dborkman@redhat.com>, <ffusco@redhat.com>,
        <tgraf@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86/hash: swap parameters of crc32_u32()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... to match its two callers (i.e. the alternative would have been to
swap the arguments at the call sites).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Francesco Fusco <ffusco@redhat.com>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Thomas Graf <tgraf@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/x86/lib/hash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.14-rc3-x86-hash-crc32.orig/arch/x86/lib/hash.c
+++ 3.14-rc3-x86-hash-crc32/arch/x86/lib/hash.c
@@ -37,7 +37,7 @@
 #include <asm/cpufeature.h>
 #include <asm/hash.h>
 
-static inline u32 crc32_u32(u32 crc, u32 val)
+static inline u32 crc32_u32(u32 val, u32 crc)
 {
 #ifdef CONFIG_AS_CRC32
 	asm ("crc32l %1,%0\n" : "+r" (crc) : "rm" (val));



