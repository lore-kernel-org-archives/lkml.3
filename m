Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab3ICJbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:31:01 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:35396 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab3ICJa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:30:58 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] m68k/m68knommu: Implement __get_user_unaligned/__put_user_unaligned()
Date: Tue,  3 Sep 2013 11:30:34 +0200
Message-Id: <1378200634-24716-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/btrfs/ioctl.c: In function ‘btrfs_ioctl_file_extent_same’:
fs/btrfs/ioctl.c:2802: error: implicit declaration of function ‘__put_user_unaligned’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/9455452/

Btrfs is the first user of __put_user_unaligned() outside the compat code,
hence now all 32-bit architectures should make sure to implement this, too.

 arch/m68k/include/asm/uaccess.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/m68k/include/asm/uaccess.h b/arch/m68k/include/asm/uaccess.h
index 639c731..3fadc4a 100644
--- a/arch/m68k/include/asm/uaccess.h
+++ b/arch/m68k/include/asm/uaccess.h
@@ -3,3 +3,10 @@
 #else
 #include <asm/uaccess_mm.h>
 #endif
+
+#ifdef CONFIG_CPU_HAS_NO_UNALIGNED
+#include <asm-generic/uaccess-unaligned.h>
+#else
+#define __get_user_unaligned(x, ptr)	__get_user((x), (ptr))
+#define __put_user_unaligned(x, ptr)	__put_user((x), (ptr))
+#endif
-- 
1.7.9.5

