Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaAaGun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 01:50:43 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:43430 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaAaGum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 01:50:42 -0500
Date: Fri, 31 Jan 2014 07:50:36 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tile: remove compat_sys_lookup_dcookie declaration to fix
 compile error
Message-ID: <20140131065036.GB4114@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14013106-8372-0000-0000-0000087C7FC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With d8d14bd09cdd "fs/compat: fix lookup_dcookie() parameter handling" I
changed the type of the len parameter of the lookup_dcookie() syscall.

However I missed that there was still a stale declaration in arch/tile/..
which now causes a compile error on tile:

In file included from fs/dcookies.c:28:0:
include/linux/compat.h:425:17: error: conflicting types for 'compat_sys_lookup_dcookie'
fs/dcookies.c:207:1: error: conflicting types for 'compat_sys_lookup_dcookie'

Simply remove the declaration in the tile architecture, which is only a
leftover from before the different compat lookup_dcookie() versions have
been merged.
The declaration is now in include/linux/compat.h

The build error was reported by Fenguang's build bot.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/tile/include/asm/compat.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index 78f1f2ded86c..ffd4493efc78 100644
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
1.8.4.5

