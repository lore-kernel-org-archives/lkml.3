Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab3HGNni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:43:38 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:44091 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933144Ab3HGNnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:43:37 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 1/2] hexagon: fix return type of ffs()
Date: Wed,  7 Aug 2013 22:42:38 +0900
Message-Id: <1375882959-26853-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return type of ffs() is 'int' on all architectures except cris and
hexagon.  This unifies the return type to 'int'.

The problem I'm seeing is that the following line generates a warning
on cris and hexagon because of the mismatch between format '%u' and
return type of ffs().

	printk("bits in OOB size: %u\n",	ffs(ns->geom.oobsz) - 1);

But removing this warning by casting to 'int' looks odd, so I suggest
unifying the return type of ffs() on all architectures.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org
Cc: linux-arch@vger.kernel.org
---
This patch is not compile tested yet, because I couldn't find cross
compiler for hexagon.

 arch/hexagon/include/asm/bitops.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/include/asm/bitops.h b/arch/hexagon/include/asm/bitops.h
index 9b1e4af..80e34a6 100644
--- a/arch/hexagon/include/asm/bitops.h
+++ b/arch/hexagon/include/asm/bitops.h
@@ -234,7 +234,7 @@ static inline long fls(int x)
  * the libc and compiler builtin ffs routines, therefore
  * differs in spirit from the above ffz (man ffs).
  */
-static inline long ffs(int x)
+static inline int ffs(int x)
 {
 	int r;
 
-- 
1.8.3.1

