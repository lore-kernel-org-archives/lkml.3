Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaBKHgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:36:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6289 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbaBKHfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:35:10 -0500
X-IronPort-AV: E=Sophos;i="4.95,824,1384272000"; 
   d="scan'208";a="9505345"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Robin Holt <holt@sgi.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 7/9] sys: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.
Date: Tue, 11 Feb 2014 15:34:51 +0800
Message-Id: <0261f094b836f1acbcdf52e7166487c0c77323c8.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:08,
	Serialize complete at 2014/02/11 15:33:08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>
cc: Robin Holt <holt@sgi.com>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: Kees Cook <keescook@chromium.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>
---
 kernel/sys.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index c0a58be..adaeab6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -174,10 +174,10 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 
 	/* normalize: avoid signed division (rounding problems) */
 	error = -ESRCH;
-	if (niceval < -20)
-		niceval = -20;
-	if (niceval > 19)
-		niceval = 19;
+	if (niceval < MIN_NICE)
+		niceval = MIN_NICE;
+	if (niceval > MAX_NICE)
+		niceval = MAX_NICE;
 
 	rcu_read_lock();
 	read_lock(&tasklist_lock);
-- 
1.8.2.1

