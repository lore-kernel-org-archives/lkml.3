Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097Ab3L1VAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 16:00:52 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:45039 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3L1VAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 16:00:50 -0500
From: Olof Johansson <olof@lixom.net>
To: benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        anton@samba.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH] powerpc: Fix alignment of secondary cpu spin vars
Date: Sat, 28 Dec 2013 13:01:47 -0800
Message-Id: <1388264507-5100-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5c0484e25ec0 ('powerpc: Endian safe trampoline') resulted in
losing proper alignment of the spinlock variables used when booting
secondary CPUs, causing some quite odd issues with failing to boot on
PA Semi-based systems.

This showed itself on ppc64_defconfig, but not on pasemi_defconfig,
so it had gone unnoticed when I initially tested the LE patch set.

Fix is to add explicit alignment instead of relying on good luck. :)

Fixes: 5c0484e25ec0 ('powerpc: Endian safe trampoline')
Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=67811
Signed-off-by: Olof Johansson <olof@lixom.net>
---
 arch/powerpc/kernel/head_64.S |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 2ae41ab..4d94477 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -80,6 +80,7 @@ END_FTR_SECTION(0, 1)
 	 * of the function that the cpu should jump to to continue
 	 * initialization.
 	 */
+	.balign 8
 	.globl  __secondary_hold_spinloop
 __secondary_hold_spinloop:
 	.llong	0x0
-- 
1.7.10.4

