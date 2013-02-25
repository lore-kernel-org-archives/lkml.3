Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab3BYW0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:26:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab3BYWUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, davej@redhat.com, keescook@chromium.org,
        ebiederm@xmission.com
Subject: [ 32/58] futex: Revert "futex: Mark get_robust_list as deprecated"
Date: Mon, 25 Feb 2013 14:19:28 -0800
Message-Id: <20130225221643.088652301@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit fe2b05f7ca9f906be61dced5489f63b8b4d7c770 upstream.

This reverts commit ec0c4274e33c0373e476b73e01995c53128f1257.

get_robust_list() is in use and a removal would break existing user
space. With the permission checks in place it's not longer a security
hole. Remove the deprecation warnings.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org
Cc: paul.gortmaker@windriver.com
Cc: davej@redhat.com
Cc: keescook@chromium.org
Cc: ebiederm@xmission.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c        |    2 --
 kernel/futex_compat.c |    2 --
 2 files changed, 4 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2471,8 +2471,6 @@ SYSCALL_DEFINE3(get_robust_list, int, pi
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
-
 	rcu_read_lock();
 
 	ret = -ESRCH;
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -142,8 +142,6 @@ compat_sys_get_robust_list(int pid, comp
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
-
 	rcu_read_lock();
 
 	ret = -ESRCH;


