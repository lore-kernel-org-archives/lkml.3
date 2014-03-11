Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaCKJZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:25:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41970 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbaCKJXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:23:03 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9677984"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        nbd-general@lists.sourceforge.net,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/16] driver/block: Replace hardcoding of -20 with MIN_NICE.
Date: Tue, 11 Mar 2014 17:20:30 +0800
Message-Id: <bb84993f9b6b5668b6eefbc7cccd5b4372fb7465.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:19:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:20:13,
	Serialize complete at 2014/03/11 17:20:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: nbd-general@lists.sourceforge.net
cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
cc: Tejun Heo <tj@kernel.org>
---
 drivers/block/loop.c    | 2 +-
 drivers/block/nbd.c     | 2 +-
 drivers/block/pktcdvd.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 66e8c3b..c8bf270 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -548,7 +548,7 @@ static int loop_thread(void *data)
 	struct loop_device *lo = data;
 	struct bio *bio;
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 
 	while (!kthread_should_stop() || !bio_list_empty(&lo->lo_bio_list)) {
 
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 55298db..2a1f26b 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -533,7 +533,7 @@ static int nbd_thread(void *data)
 	struct nbd_device *nbd = data;
 	struct request *req;
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 	while (!kthread_should_stop() || !list_empty(&nbd->waiting_queue)) {
 		/* wait for something to do */
 		wait_event_interruptible(nbd->waiting_wq,
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index a2af73d..ef166ad 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1463,7 +1463,7 @@ static int kcdrwd(void *foobar)
 	struct packet_data *pkt;
 	long min_sleep_time, residue;
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 	set_freezable();
 
 	for (;;) {
-- 
1.8.2.1

