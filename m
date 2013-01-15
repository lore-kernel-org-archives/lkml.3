Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab3AOSwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:52:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:34074 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757696Ab3AOSwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:52:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gabor Juhos <juhosg@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 011/221] powerpc: Add missing NULL terminator to avoid boot panic on PPC40x
Date: Tue, 15 Jan 2013 10:48:58 -0800
Message-Id: <20130115184958.869455727@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/40x/ppc40x_simple.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/40x/ppc40x_simple.c
+++ b/arch/powerpc/platforms/40x/ppc40x_simple.c
@@ -57,7 +57,8 @@ static const char * const board[] __init
 	"amcc,makalu",
 	"apm,klondike",
 	"est,hotfoot",
-	"plathome,obs600"
+	"plathome,obs600",
+	NULL
 };
 
 static int __init ppc40x_probe(void)


