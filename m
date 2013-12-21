Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3LUAJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 19:09:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3LUAJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 19:09:51 -0500
Date: Fri, 20 Dec 2013 16:09:36 -0800
From: "tip-bot for H.J. Lu" <tipbot@zytor.com>
Message-ID: <tip-79dbbc60493f357912d5f1da5a23147ba0c01c7a@git.kernel.org>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, tglx@linutronix.de, hpa@linux.intel.com,
        hjl.tools@gmail.com
In-Reply-To: <CAMe9rOrcppHvC5g8U9n7D+pxVGdu1G598pge3Erfw7Pr-iEpAQ@mail.gmail.com>
References: <CAMe9rOrcppHvC5g8U9n7D+pxVGdu1G598pge3Erfw7Pr-iEpAQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x86, x32: Use __kernel_long_t for __statfs_word
Git-Commit-ID: 79dbbc60493f357912d5f1da5a23147ba0c01c7a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 20 Dec 2013 16:09:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79dbbc60493f357912d5f1da5a23147ba0c01c7a
Gitweb:     http://git.kernel.org/tip/79dbbc60493f357912d5f1da5a23147ba0c01c7a
Author:     H.J. Lu <hjl.tools@gmail.com>
AuthorDate: Mon, 16 Dec 2013 16:12:57 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 20 Dec 2013 16:06:21 -0800

x86, x32: Use __kernel_long_t for __statfs_word

x32 statfs system call is the same as x86-64 statfs system call, which
uses 64-bit integer for __statfs_word.  This patch defines __statfs_word
as __kernel_long_t instead of long.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/CAMe9rOrcppHvC5g8U9n7D%2BpxVGdu1G598pge3Erfw7Pr-iEpAQ@mail.gmail.com
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/uapi/asm-generic/statfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/asm-generic/statfs.h b/include/uapi/asm-generic/statfs.h
index 0999647..cb89cc7 100644
--- a/include/uapi/asm-generic/statfs.h
+++ b/include/uapi/asm-generic/statfs.h
@@ -13,7 +13,7 @@
  */
 #ifndef __statfs_word
 #if __BITS_PER_LONG == 64
-#define __statfs_word long
+#define __statfs_word __kernel_long_t
 #else
 #define __statfs_word __u32
 #endif
