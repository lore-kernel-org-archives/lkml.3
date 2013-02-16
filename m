Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3BPENv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 23:13:51 -0500
Received: from intranet.asianux.com ([58.214.24.6]:5935 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3BPENu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 23:13:50 -0500
X-Spam-Score: -100.8
Message-ID: <511F0775.6030008@asianux.com>
Date: Sat, 16 Feb 2013 12:13:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kernel: arg2 is unsigned long which is never < 0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  arg2 will never < 0, for its type is 'unsigned long'

  so need beautify the relative source code (better to use macros).

Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/sys.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 24d1ef5..eebaf8d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -47,6 +47,7 @@
 #include <linux/syscalls.h>
 #include <linux/kprobes.h>
 #include <linux/user_namespace.h>
+#include <linux/binfmts.h>
 
 #include <linux/kmsg_dump.h>
 /* Move somewhere else to avoid recompiling? */
@@ -2027,7 +2028,8 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			error = get_dumpable(me->mm);
 			break;
 		case PR_SET_DUMPABLE:
-			if (arg2 < 0 || arg2 > 1) {
+			if (arg2 != SUID_DUMP_DISABLE &&
+			    arg2 != SUID_DUMP_USER) {
 				error = -EINVAL;
 				break;
 			}
-- 
1.7.7.6
