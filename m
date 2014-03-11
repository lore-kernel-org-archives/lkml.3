Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbaCKKOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:14:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41222 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbaCKKLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:11:33 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9678281"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        ocfs2-devel@oss.oracle.com, Dong Fang <yp.fangdong@gmail.com>
Subject: [PATCH 09/17] fs/hearbeat: Replace hardcoding of -20 with MIN_NICE.
Date: Tue, 11 Mar 2014 18:09:17 +0800
Message-Id: <cd740e155ed224cabb6554e87d22cf94855ff6c2.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:38,
	Serialize complete at 2014/03/11 18:08:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: ocfs2-devel@oss.oracle.com
cc: Dong Fang <yp.fangdong@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index bf482df..7303929 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1107,7 +1107,7 @@ static int o2hb_thread(void *data)
 
 	mlog(ML_HEARTBEAT|ML_KTHREAD, "hb thread running\n");
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 
 	/* Pin node */
 	o2nm_depend_this_node();
-- 
1.8.2.1

