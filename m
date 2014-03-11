Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaCKJYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:24:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41970 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbaCKJXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:23:06 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9677989"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, fcoe-devel@open-fcoe.org,
        James Smart <james.smart@emulex.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/16] driver/scsi: Replace hardcoding of -20 with MIN_NICE.
Date: Tue, 11 Mar 2014 17:20:36 +0800
Message-Id: <eb802448e98d161bc3b66d151a12bdb6e68a8f04.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:19:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:20:19,
	Serialize complete at 2014/03/11 17:20:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: fcoe-devel@open-fcoe.org
cc: James Smart <james.smart@emulex.com>
cc: Robert Jennings <rcj@linux.vnet.ibm.com>
cc: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 4 ++--
 drivers/scsi/bnx2i/bnx2i_hwi.c    | 2 +-
 drivers/scsi/fcoe/fcoe.c          | 2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c    | 2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c  | 2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c  | 2 +-
 drivers/scsi/qla2xxx/qla_os.c     | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 9b94850..d24067a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -464,7 +464,7 @@ static int bnx2fc_l2_rcv_thread(void *arg)
 	struct fcoe_percpu_s *bg = arg;
 	struct sk_buff *skb;
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
 		schedule();
@@ -602,7 +602,7 @@ int bnx2fc_percpu_io_thread(void *arg)
 	struct bnx2fc_work *work, *tmp;
 	LIST_HEAD(work_list);
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
 		schedule();
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index e4cf23d..9aaa325 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1870,7 +1870,7 @@ int bnx2i_percpu_io_thread(void *arg)
 	struct bnx2i_work *work, *tmp;
 	LIST_HEAD(work_list);
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 
 	while (!kthread_should_stop()) {
 		spin_lock_bh(&p->p_work_lock);
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index f317000..843a679 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1872,7 +1872,7 @@ static int fcoe_percpu_receive_thread(void *arg)
 
 	skb_queue_head_init(&tmp);
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 
 retry:
 	while (!kthread_should_stop()) {
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 23f5ba5..8dd4768 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4515,7 +4515,7 @@ static int ibmvfc_work(void *data)
 	struct ibmvfc_host *vhost = data;
 	int rc;
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 
 	while (1) {
 		rc = wait_event_interruptible(vhost->work_wait_q,
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index fa76440..2ebfb2b 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2213,7 +2213,7 @@ static int ibmvscsi_work(void *data)
 	struct ibmvscsi_host_data *hostdata = data;
 	int rc;
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 
 	while (1) {
 		rc = wait_event_interruptible(hostdata->work_wait_q,
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 883ea2d..1f8f4a7 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -733,7 +733,7 @@ lpfc_do_work(void *p)
 	struct lpfc_hba *phba = p;
 	int rc;
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 	current->flags |= PF_NOFREEZE;
 	phba->data_flags = 0;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 89a5300..0e45568 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4756,7 +4756,7 @@ qla2x00_do_dpc(void *data)
 	ha = (struct qla_hw_data *)data;
 	base_vha = pci_get_drvdata(ha->pdev);
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
-- 
1.8.2.1

