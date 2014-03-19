Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbaCSXzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:55:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604AbaCSXzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:55:07 -0400
Date: Wed, 19 Mar 2014 16:54:48 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-7a5917e9787dd73284f04e35c3cfdb39a67bf0d5@git.kernel.org>
Cc: ffusco@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dborkman@redhat.com, jbeulich@suse.com,
        davem@davemloft.net, tgraf@redhat.com, JBeulich@suse.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ffusco@redhat.com, dborkman@redhat.com, jbeulich@suse.com,
        davem@davemloft.net, tgraf@redhat.com, JBeulich@suse.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <530F09CE020000780011FBEF@nat28.tlf.novell.com>
References: <530F09CE020000780011FBEF@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/hash] x86, hash: Simplify switch, add __init annotation
Git-Commit-ID: 7a5917e9787dd73284f04e35c3cfdb39a67bf0d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a5917e9787dd73284f04e35c3cfdb39a67bf0d5
Gitweb:     http://git.kernel.org/tip/7a5917e9787dd73284f04e35c3cfdb39a67bf0d5
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 27 Feb 2014 08:47:58 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 Mar 2014 16:51:04 -0700

x86, hash: Simplify switch, add __init annotation

Minor cleanups:

- simplify switch statement
- add __init annotation to setup_arch_fast_hash()

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/530F09CE020000780011FBEF@nat28.tlf.novell.com
Cc: Francesco Fusco <ffusco@redhat.com>
Cc: Thomas Graf <tgraf@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/lib/hash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/lib/hash.c b/arch/x86/lib/hash.c
index ac628aa..ff4fa51 100644
--- a/arch/x86/lib/hash.c
+++ b/arch/x86/lib/hash.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/hash.h>
+#include <linux/init.h>
 
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
@@ -55,17 +56,16 @@ static u32 intel_crc4_2_hash(const void *data, u32 len, u32 seed)
 	for (i = 0; i < len / 4; i++)
 		seed = crc32_u32(seed, *p32++);
 
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
 		seed = crc32_u32(seed, tmp);
-	default:
 		break;
 	}
 
@@ -83,7 +83,7 @@ static u32 intel_crc4_2_hash2(const u32 *data, u32 len, u32 seed)
 	return seed;
 }
 
-void setup_arch_fast_hash(struct fast_hash_ops *ops)
+void __init setup_arch_fast_hash(struct fast_hash_ops *ops)
 {
 	if (cpu_has_xmm4_2) {
 		ops->hash  = intel_crc4_2_hash;
