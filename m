Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaBINRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:17:35 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33485 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBINRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:17:34 -0500
Date: Sun, 9 Feb 2014 18:47:29 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joyce <xuejiufei@huawei.com>, Jie Liu <jeff.liu@oracle.com>,
        Sunil Mushran <sunil.mushran@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Dong Fang <yp.fangdong@gmail.com>, ocfs2-devel@oss.oracle.com,
        josh@joshtriplett.org
Subject: [PATCH 16/21] fs: Mark function as static in
 ocfs2/cluster/heartbeat.c
Message-ID: <105d09df399b657f59ede72e355e04a0080b6126.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in ocfs2/cluster/heartbeat.c because it is
not used outside this file.

This eliminates the following warning in ocfs2/cluster/heartbeat.c:
fs/ocfs2/cluster/heartbeat.c:2470:6: warning: no previous prototype for ‘o2hb_region_dec_user’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index bf482df..ca10dec 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2467,7 +2467,7 @@ unlock:
 	return ret;
 }
 
-void o2hb_region_dec_user(const char *region_uuid)
+static void o2hb_region_dec_user(const char *region_uuid)
 {
 	spin_lock(&o2hb_live_lock);
 
-- 
1.7.9.5

