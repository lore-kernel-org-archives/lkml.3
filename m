Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaBNOPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:15:25 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:10902 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaBNOPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:15:23 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Emelyanov <xemul@parallels.com>,
        Aditya Kali <adityakali@google.com>
Subject: [PATCH 3/3] prctl: allow to use PR_MM_SET_* which affect only a current task
Date: Fri, 14 Feb 2014 18:13:29 +0400
Message-Id: <1392387209-330-4-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392387209-330-1-git-send-email-avagin@openvz.org>
References: <1392387209-330-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are PR_SET_MM_*_CODE, PR_SET_MM_ARG_*, PR_SET_MM_ENV_*,
PR_SET_MM_AUXV.

Looks like all these parameters can break only the current task and
can not affect other tasks or limits.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Aditya Kali <adityakali@google.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 kernel/sys.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 2f0925d..154cf47 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1719,8 +1719,7 @@ static int prctl_set_mm(int opt, unsigned long addr,
 			if (!issecure(SECURE_SET_EXE_FILE))
 				return -EPERM;
 			break;
-		default:
-			return -EPERM;
+		/* Other options don't require special capabilities */
 		}
 	}
 
-- 
1.8.5.3

