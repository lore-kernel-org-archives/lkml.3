Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbaBKVEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:04:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaBKTFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.13 032/120] tile: remove compat_sys_lookup_dcookie declaration to fix compile error
Date: Tue, 11 Feb 2014 11:04:33 -0800
Message-Id: <20140211184824.481862106@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/tile/include/asm/compat.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -281,7 +281,6 @@ long compat_sys_pread64(unsigned int fd,
 			u32 dummy, u32 low, u32 high);
 long compat_sys_pwrite64(unsigned int fd, char __user *ubuf, size_t count,
 			 u32 dummy, u32 low, u32 high);
-long compat_sys_lookup_dcookie(u32 low, u32 high, char __user *buf, size_t len);
 long compat_sys_sync_file_range2(int fd, unsigned int flags,
 				 u32 offset_lo, u32 offset_hi,
 				 u32 nbytes_lo, u32 nbytes_hi);


