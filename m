Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaBND7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:59:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47881 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaBND7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:59:38 -0500
Date: Thu, 13 Feb 2014 19:59:27 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-a7330c997d0f74d909a7d3553b1d550d8be2b61a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391845930-28580-10-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-10-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage]
  asmlinkage Make __stack_chk_failed and memcmp visible
Git-Commit-ID: a7330c997d0f74d909a7d3553b1d550d8be2b61a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 19:59:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7330c997d0f74d909a7d3553b1d550d8be2b61a
Gitweb:     http://git.kernel.org/tip/a7330c997d0f74d909a7d3553b1d550d8be2b61a
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:52:06 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:13:43 -0800

asmlinkage Make __stack_chk_failed and memcmp visible

In LTO symbols implicitely referenced by the compiler need
to be visible. Earlier these symbols were visible implicitely
from being exported, but we disabled implicit visibility fo
 EXPORTs when modules are disabled to improve code size. So
now these symbols have to be marked visible explicitely.

Do this for __stack_chk_fail (with stack protector)
and memcmp.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-10-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/panic.c | 2 +-
 lib/string.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 6d63003..3eb0ffb 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -459,7 +459,7 @@ EXPORT_SYMBOL(warn_slowpath_null);
  * Called when gcc's -fstack-protector feature is used, and
  * gcc detects corruption of the on-stack canary value
  */
-void __stack_chk_fail(void)
+__visible void __stack_chk_fail(void)
 {
 	panic("stack-protector: Kernel stack is corrupted in: %p\n",
 		__builtin_return_address(0));
diff --git a/lib/string.c b/lib/string.c
index e5878de..9b1f906 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -648,7 +648,7 @@ EXPORT_SYMBOL(memmove);
  * @count: The size of the area.
  */
 #undef memcmp
-int memcmp(const void *cs, const void *ct, size_t count)
+__visible int memcmp(const void *cs, const void *ct, size_t count)
 {
 	const unsigned char *su1, *su2;
 	int res = 0;
