Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab3HGNnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:43:41 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61760 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab3HGNnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:43:39 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 2/2] cris: fix return type of ffs()
Date: Wed,  7 Aug 2013 22:42:39 +0900
Message-Id: <1375882959-26853-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375882959-26853-1-git-send-email-akinobu.mita@gmail.com>
References: <1375882959-26853-1-git-send-email-akinobu.mita@gmail.com>
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
 arch/cris/include/arch-v10/arch/bitops.h | 2 +-
 arch/cris/include/arch-v32/arch/bitops.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/include/arch-v10/arch/bitops.h b/arch/cris/include/arch-v10/arch/bitops.h
index 03d9cfd..cc37a22 100644
--- a/arch/cris/include/arch-v10/arch/bitops.h
+++ b/arch/cris/include/arch-v10/arch/bitops.h
@@ -65,7 +65,7 @@ static inline unsigned long __ffs(unsigned long word)
  * differs in spirit from the above ffz (man ffs).
  */
 
-static inline unsigned long kernel_ffs(unsigned long w)
+static inline int kernel_ffs(unsigned long w)
 {
 	return w ? cris_swapwbrlz (w) + 1 : 0;
 }
diff --git a/arch/cris/include/arch-v32/arch/bitops.h b/arch/cris/include/arch-v32/arch/bitops.h
index 147689d6..a5d0963 100644
--- a/arch/cris/include/arch-v32/arch/bitops.h
+++ b/arch/cris/include/arch-v32/arch/bitops.h
@@ -55,7 +55,7 @@ __ffs(unsigned long w)
 /*
  * Find First Bit that is set.
  */
-static inline unsigned long
+static inline int
 kernel_ffs(unsigned long w)
 {
 	return w ? cris_swapwbrlz (w) + 1 : 0;
-- 
1.8.3.1

