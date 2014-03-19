Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbaCSXzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:55:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43000 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbaCSXyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:54:52 -0400
Date: Wed, 19 Mar 2014 16:54:37 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-c5cdfdf90901c51363441365997eecd58efd9374@git.kernel.org>
Cc: ffusco@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dborkman@redhat.com, jbeulich@suse.com,
        davem@davemloft.net, tgraf@redhat.com, JBeulich@suse.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ffusco@redhat.com, dborkman@redhat.com, jbeulich@suse.com,
        davem@davemloft.net, tgraf@redhat.com, JBeulich@suse.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <530F09B6020000780011FBEB@nat28.tlf.novell.com>
References: <530F09B6020000780011FBEB@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/hash] x86, hash: Swap arguments passed to crc32_u32()
Git-Commit-ID: c5cdfdf90901c51363441365997eecd58efd9374
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

Commit-ID:  c5cdfdf90901c51363441365997eecd58efd9374
Gitweb:     http://git.kernel.org/tip/c5cdfdf90901c51363441365997eecd58efd9374
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 27 Feb 2014 08:47:34 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 Mar 2014 16:51:04 -0700

x86, hash: Swap arguments passed to crc32_u32()

... to match the function's parameters. While reportedly commutative,
using the proper order allows for leveraging the instruction permitting
the source operand to be in memory.

[ hpa: This code originated in the dpdk toolkit.  This was a bug in dpdk
  which has recently been fixed in part due to an earlier version of
  this patch. ]

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/530F09B6020000780011FBEB@nat28.tlf.novell.com
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Francesco Fusco <ffusco@redhat.com>
Cc: Thomas Graf <tgraf@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/lib/hash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/hash.c b/arch/x86/lib/hash.c
index 060cc44..ac628aa 100644
--- a/arch/x86/lib/hash.c
+++ b/arch/x86/lib/hash.c
@@ -53,7 +53,7 @@ static u32 intel_crc4_2_hash(const void *data, u32 len, u32 seed)
 	u32 i, tmp = 0;
 
 	for (i = 0; i < len / 4; i++)
-		seed = crc32_u32(*p32++, seed);
+		seed = crc32_u32(seed, *p32++);
 
 	switch (3 - (len & 0x03)) {
 	case 0:
@@ -64,7 +64,7 @@ static u32 intel_crc4_2_hash(const void *data, u32 len, u32 seed)
 		/* fallthrough */
 	case 2:
 		tmp |= *((const u8 *) p32);
-		seed = crc32_u32(tmp, seed);
+		seed = crc32_u32(seed, tmp);
 	default:
 		break;
 	}
@@ -78,7 +78,7 @@ static u32 intel_crc4_2_hash2(const u32 *data, u32 len, u32 seed)
 	u32 i;
 
 	for (i = 0; i < len; i++)
-		seed = crc32_u32(*p32++, seed);
+		seed = crc32_u32(seed, *p32++);
 
 	return seed;
 }
