Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab3FYWym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 18:54:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49232 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab3FYWyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 18:54:40 -0400
Date: Tue, 25 Jun 2013 15:54:30 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-nbca8p7cg6jyjoit7klh3o91@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] linux/const.h: Add _BITUL() and _BITULL()
Git-Commit-ID: 2fc016c5bd8aad2e201cdf71b9fb4573f94775bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 25 Jun 2013 15:54:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fc016c5bd8aad2e201cdf71b9fb4573f94775bd
Gitweb:     http://git.kernel.org/tip/2fc016c5bd8aad2e201cdf71b9fb4573f94775bd
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sat, 27 Apr 2013 16:07:49 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 25 Jun 2013 15:50:04 -0700

linux/const.h: Add _BITUL() and _BITULL()

Add macros for single bit definitions of a specific type.  These are
similar to the BIT() macro that already exists, but with a few
exceptions:

1. The namespace is such that they can be used in uapi definitions.
2. The type is set with the _AC() macro to allow it to be used in
   assembly.
3. The type is explicitly specified to be UL or ULL.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-nbca8p7cg6jyjoit7klh3o91@git.kernel.org
---
 include/uapi/linux/const.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/const.h b/include/uapi/linux/const.h
index c22c707..c872bfd 100644
--- a/include/uapi/linux/const.h
+++ b/include/uapi/linux/const.h
@@ -21,4 +21,7 @@
 #define _AT(T,X)	((T)(X))
 #endif
 
+#define _BITUL(x)	(_AC(1,UL) << (x))
+#define _BITULL(x)	(_AC(1,ULL) << (x))
+
 #endif /* !(_LINUX_CONST_H) */
