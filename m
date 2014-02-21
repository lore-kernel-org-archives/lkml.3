Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbaBUMuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:50:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46875 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbaBUMuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 037/121] tile: remove compat_sys_lookup_dcookie declaration to fix compile error
Date: Fri, 21 Feb 2014 12:47:41 +0000
Message-Id: <1392986945-9693-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 5a5e75f4714a592f31e57f248b8f5c866f278b8d upstream.

With commit d8d14bd09cdd ("fs/compat: fix lookup_dcookie() parameter
handling") I changed the type of the len parameter of the
lookup_dcookie() syscall.

However I missed that there was still a stale declaration in
arch/tile/..  which now causes a compile error on tile:

  In file included from fs/dcookies.c:28:0:
  include/linux/compat.h:425:17: error: conflicting types for 'compat_sys_lookup_dcookie'
  fs/dcookies.c:207:1: error: conflicting types for 'compat_sys_lookup_dcookie'

Simply remove the declaration in the tile architecture, which is only a
leftover from before the different compat lookup_dcookie() versions have
been merged.  The correct declaration is now in include/linux/compat.h

The build error was reported by Fenguang's build bot.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/tile/include/asm/compat.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index 78f1f2d..ffd4493 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -281,7 +281,6 @@ long compat_sys_pread64(unsigned int fd, char __user *ubuf, size_t count,
 			u32 dummy, u32 low, u32 high);
 long compat_sys_pwrite64(unsigned int fd, char __user *ubuf, size_t count,
 			 u32 dummy, u32 low, u32 high);
-long compat_sys_lookup_dcookie(u32 low, u32 high, char __user *buf, size_t len);
 long compat_sys_sync_file_range2(int fd, unsigned int flags,
 				 u32 offset_lo, u32 offset_hi,
 				 u32 nbytes_lo, u32 nbytes_hi);
-- 
1.9.0

