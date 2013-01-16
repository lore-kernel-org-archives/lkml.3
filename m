Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab3APQKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:10:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476Ab3APQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:10:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Grant Likely <grant.likely@secretlab.ca>, Gabor Juhos <juhosg@openwrt.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 201/222] powerpc: Add missing NULL terminator to avoid boot panic on PPC40x
Date: Wed, 16 Jan 2013 13:56:41 -0200
Message-Id: <1358351822-7675-202-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

commit e6449c9b2d90c1bd9a5985bf05ddebfd1631cd6b upstream.

The missing NULL terminator can cause a panic on
PPC405 boards during boot:

  Linux/PowerPC load: console=ttyS0,115200 root=/dev/mtdblock1 rootfstype=squashfs,jffs2 noinitrd init=/etc/preinit
  Finalizing device tree... flat tree at 0x6a5160
  bootconsole [udbg0] enabled
  Page fault in user mode with in_atomic() = 1 mm = (null)
  NIP = c0275f50  MSR = fffffffe
  Oops: Weird page fault, sig: 11 [#1]
  PowerPC 40x Platform
  Modules linked in:
  NIP: c0275f50 LR: c0275f60 CTR: c0280000
  REGS: c0275eb0 TRAP: 636f7265   Not tainted  (3.7.1)
  MSR: fffffffe <VEC,VSX,EE,PR,FP,ME,SE,BE,IR,DR,PMM,RI> CR: c06a6190  XER: 00000001
  TASK = c02662a8[0] 'swapper' THREAD: c0274000
  GPR00: c0275ec0 c000c658 c027c4bf 00000000 c0275ee0 c000a0ec c020a1a8 c020a1f0
  GPR08: c020f631 c020f404 c025f078 c025f080 c0275f10
   Call Trace:
   ---[ end trace 31fd0ba7d8756001 ]---

  Kernel panic - not syncing: Attempted to kill the idle task!

The panic happens since commit 9597abe00c1bab2aedce6b49866bf6d1e81c9eed
(sections: fix section conflicts in arch/powerpc), however the root
cause of this is that the NULL terminator were not added in commit
a4f740cf33f7f6c164bbde3c0cdbcc77b0c4997c (of/flattree: Add of_flat_dt_match()
helper function).

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/powerpc/platforms/40x/ppc40x_simple.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/40x/ppc40x_simple.c b/arch/powerpc/platforms/40x/ppc40x_simple.c
index 9761206..f0eee75 100644
--- a/arch/powerpc/platforms/40x/ppc40x_simple.c
+++ b/arch/powerpc/platforms/40x/ppc40x_simple.c
@@ -57,7 +57,8 @@ static const char *board[] __initdata = {
 	"amcc,makalu",
 	"apm,klondike",
 	"est,hotfoot",
-	"plathome,obs600"
+	"plathome,obs600",
+	NULL
 };
 
 static int __init ppc40x_probe(void)
-- 
1.7.9.5

