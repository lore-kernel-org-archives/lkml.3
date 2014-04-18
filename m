Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaDRNYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:24:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaDRNH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:07:58 -0400
Date: Fri, 18 Apr 2014 06:06:46 -0700
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-8698a745d800c59cd5a576398bdeccd578ac66f1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tj@kernel.org, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <ff13819fd09b7a5dba5ab5ae797f2e7019bdfa17.1394532288.git.yangds.fnst@cn.fujitsu.com>
References: <ff13819fd09b7a5dba5ab5ae797f2e7019bdfa17.1394532288.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, treewide:
  Replace hardcoded nice values with MIN_NICE/MAX_NICE
Git-Commit-ID: 8698a745d800c59cd5a576398bdeccd578ac66f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8698a745d800c59cd5a576398bdeccd578ac66f1
Gitweb:     http://git.kernel.org/tip/8698a745d800c59cd5a576398bdeccd578ac66f1
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Mar 2014 18:09:12 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 12:07:24 +0200

sched, treewide: Replace hardcoded nice values with MIN_NICE/MAX_NICE

Replace various -20/+19 hardcoded nice values with MIN_NICE/MAX_NICE.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/ff13819fd09b7a5dba5ab5ae797f2e7019bdfa17.1394532288.git.yangds.fnst@cn.fujitsu.com
Cc: devel@driverdev.osuosl.org
Cc: devicetree@vger.kernel.org
Cc: fcoe-devel@open-fcoe.org
Cc: linux390@de.ibm.com
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-s390@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: nbd-general@lists.sourceforge.net
Cc: ocfs2-devel@oss.oracle.com
Cc: openipmi-developer@lists.sourceforge.net
Cc: qla2xxx-upstream@qlogic.com
Cc: linux-arch@vger.kernel.org
[ Consolidated the patches, twiddled the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/block/loop.c                        | 2 +-
 drivers/block/nbd.c                         | 2 +-
 drivers/block/pktcdvd.c                     | 2 +-
 drivers/char/ipmi/ipmi_si_intf.c            | 2 +-
 drivers/s390/crypto/ap_bus.c                | 2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           | 4 ++--
 drivers/scsi/bnx2i/bnx2i_hwi.c              | 2 +-
 drivers/scsi/fcoe/fcoe.c                    | 2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              | 2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            | 2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c            | 2 +-
 drivers/scsi/qla2xxx/qla_os.c               | 2 +-
 drivers/staging/android/binder.c            | 2 +-
 drivers/staging/lustre/lustre/llite/lloop.c | 2 +-
 fs/ocfs2/cluster/heartbeat.c                | 2 +-
 kernel/locking/locktorture.c                | 2 +-
 kernel/workqueue.c                          | 6 +++---
 mm/huge_memory.c                            | 2 +-
 18 files changed, 21 insertions(+), 21 deletions(-)

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
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index b7efd3c..0f20d36 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -998,7 +998,7 @@ static int ipmi_thread(void *data)
 	struct timespec busy_until;
 
 	ipmi_si_set_not_busy(&busy_until);
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 	while (!kthread_should_stop()) {
 		int busy_wait;
 
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index ab3baa7..8eec165 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -1803,7 +1803,7 @@ static int ap_poll_thread(void *data)
 	int requests;
 	struct ap_device *ap_dev;
 
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 	while (1) {
 		if (ap_suspend_flag)
 			return 0;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 6287f6a..3455cc5 100644
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
index b5ffd28..d6d491c 100644
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
index 59b51c5..294c072 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -731,7 +731,7 @@ lpfc_do_work(void *p)
 	struct lpfc_hba *phba = p;
 	int rc;
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 	current->flags |= PF_NOFREEZE;
 	phba->data_flags = 0;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 19e99cc..afc8481 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4828,7 +4828,7 @@ qla2x00_do_dpc(void *data)
 	ha = (struct qla_hw_data *)data;
 	base_vha = pci_get_drvdata(ha->pdev);
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index cfe4bc8..179b21b 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -441,7 +441,7 @@ static void binder_set_nice(long nice)
 		     "%d: nice value %ld not allowed use %ld instead\n",
 		      current->pid, nice, min_nice);
 	set_user_nice(current, min_nice);
-	if (min_nice < 20)
+	if (min_nice <= MAX_NICE)
 		return;
 	binder_user_error("%d RLIMIT_NICE not set\n", current->pid);
 }
diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index f78eda2..d4c2cd9 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -407,7 +407,7 @@ static int loop_thread(void *data)
 	int refcheck;
 	int ret = 0;
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 
 	lo->lo_state = LLOOP_BOUND;
 
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
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index f26b1a1..23343be 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -216,7 +216,7 @@ static int lock_torture_writer(void *arg)
 	static DEFINE_TORTURE_RANDOM(rand);
 
 	VERBOSE_TOROUT_STRING("lock_torture_writer task started");
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 
 	do {
 		schedule_timeout_uninterruptible(1);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0ee63af..c30c01b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -100,10 +100,10 @@ enum {
 
 	/*
 	 * Rescue workers are used only on emergencies and shared by
-	 * all cpus.  Give -20.
+	 * all cpus.  Give MIN_NICE.
 	 */
-	RESCUER_NICE_LEVEL	= -20,
-	HIGHPRI_NICE_LEVEL	= -20,
+	RESCUER_NICE_LEVEL	= MIN_NICE,
+	HIGHPRI_NICE_LEVEL	= MIN_NICE,
 
 	WQ_NAME_LEN		= 24,
 };
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1546655..dcdb6f9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2803,7 +2803,7 @@ static int khugepaged(void *none)
 	struct mm_slot *mm_slot;
 
 	set_freezable();
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 
 	while (!kthread_should_stop()) {
 		khugepaged_do_scan();
