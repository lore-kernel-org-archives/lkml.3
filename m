Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934536AbaDJCZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 22:25:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60619 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933251AbaDJCZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 22:25:56 -0400
Message-ID: <5346012A.50901@fb.com>
Date: Wed, 9 Apr 2014 20:25:46 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Brian J King <bjking1@us.ibm.com>
Subject: Re: [BUG] kernel BUG at /.../block/cfq-iosched.c:3145!
References: <1397018647.3671.123.camel@pasglop> <53454CBC.9060905@fb.com>	 <1397087273.3671.150.camel@pasglop> <1397088144.3671.155.camel@pasglop>	 <5345F476.2000602@fb.com> <1397093815.3671.156.camel@pasglop>
In-Reply-To: <1397093815.3671.156.camel@pasglop>
Content-Type: multipart/mixed;
	boundary="------------000300080501040500070004"
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-09_05:2014-04-09,2014-04-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=5.8201264735473
 compositescore=0.307752384302029 urlsuspect_oldscore=0.307752384302029
 suspectscore=2 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.307752384302029 spamscore=0
 recipient_to_sender_domain_totalscore=16 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404100032
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000300080501040500070004
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-04-09 19:36, Benjamin Herrenschmidt wrote:
> On Wed, 2014-04-09 at 19:31 -0600, Jens Axboe wrote:
>> OK, I think we're seeing different symptoms of the same bug. Stay
>> tuned, will have something for you to test shortly, I hope.
>
> Ah thanks. I'll defer the bisection then (it's painful on that machine
> for various reasons....)

Can you try with these two patches applied?

-- 
Jens Axboe


--------------000300080501040500070004
Content-Type: text/x-patch; name="scsi-flags.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="scsi-flags.patch"

Received: from mx0a-00082601.pphosted.com (192.168.57.29) by
 PRN-CHUB10.TheFacebook.com (192.168.16.20) with Microsoft SMTP Server id
 14.3.174.1; Wed, 9 Apr 2014 19:21:04 -0700
Received: from pps.filterd (m0044010 [127.0.0.1])	by
 mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s3A2Jc5c012431	for
 <axboe@fb.com>; Wed, 9 Apr 2014 19:21:04 -0700
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])	by
 mx0a-00082601.pphosted.com with ESMTP id 1k5bk5s73q-1	(version=TLSv1/SSLv3
 cipher=AES256-SHA bits=256 verify=OK)	for <axboe@fb.com>; Wed, 09 Apr 2014
 19:21:03 -0700
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id
 s3A2L16N026501	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256
 verify=OK);	Thu, 10 Apr 2014 02:21:02 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])	by
 acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s3A2L07X021509
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);	Thu, 10
 Apr 2014 02:21:01 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])	by
 userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s3A2KxkX007968;	Thu,
 10 Apr 2014 02:21:00 GMT
Received: from mojo.mkp.net (/141.144.6.237)	by default (Oracle Beehive
 Gateway v4.0)	with ESMTP ; Wed, 09 Apr 2014 19:20:59 -0700
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: <linux-scsi@vger.kernel.org>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe
	<axboe@fb.com>, Jan Kara <jack@suse.cz>, Frederic Weisbecker
	<fweisbec@gmail.com>
Subject: [PATCH] scsi: Make sure cmd_flags are 64-bit
Date: Wed, 9 Apr 2014 22:20:48 -0400
Message-ID: <1397096448-22073-1-git-send-email-martin.petersen@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-09_05:2014-04-09,2014-04-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.4432899320127e-15 kscore.compositescore=0
 circleOfTrustscore=216.016 compositescore=0.0999826334628526
 urlsuspect_oldscore=0.999826334628526 suspectscore=1
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=27002
 rbsscore=0.0999826334628526 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404100031
X-FB-Internal: deliver
Content-Type: text/plain
Return-Path: martin.petersen@oracle.com
X-MS-Exchange-Organization-AuthSource: PRN-CHUB10.TheFacebook.com
X-MS-Exchange-Organization-AuthAs: Anonymous
MIME-Version: 1.0

From: "Martin K. Petersen" <martin.petersen@oracle.com>

cmd_flags in struct request is now 64 bits wide but the scsi_execute
functions truncated arguments passed to int leading to errors. Make sure
the flags parameters are u64.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>
CC: Jan Kara <jack@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/scsi/scsi_lib.c    | 4 ++--
 include/scsi/scsi_device.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5681c05ac506..65a123d9c676 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -184,7 +184,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  */
 int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, int timeout, int retries, int flags,
+		 unsigned char *sense, int timeout, int retries, u64 flags,
 		 int *resid)
 {
 	struct request *req;
@@ -235,7 +235,7 @@ EXPORT_SYMBOL(scsi_execute);
 int scsi_execute_req_flags(struct scsi_device *sdev, const unsigned char *cmd,
 		     int data_direction, void *buffer, unsigned bufflen,
 		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
-		     int *resid, int flags)
+		     int *resid, u64 flags)
 {
 	char *sense = NULL;
 	int result;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 4e845b80efd3..5853c913d2b0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -423,11 +423,11 @@ extern int scsi_is_target_device(const struct device *);
 extern int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, int timeout, int retries,
-			int flag, int *resid);
+			u64 flags, int *resid);
 extern int scsi_execute_req_flags(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid, int flags);
+	int retries, int *resid, u64 flags);
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-- 
1.8.3.1


--------------000300080501040500070004
Content-Type: text/x-patch; name="blk-ipi-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="blk-ipi-v2.patch"

diff --git a/block/blk-core.c b/block/blk-core.c
index 7af4a4898dcb..0bc030aff0d0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1307,7 +1307,7 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 		struct request_list *rl = blk_rq_rl(req);
 
 		BUG_ON(!list_empty(&req->queuelist));
-		BUG_ON(!hlist_unhashed(&req->hash));
+		BUG_ON(ELV_ON_HASH(req));
 
 		blk_free_request(rl, req);
 		freed_request(rl, flags);
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index ebd6b6f1bdeb..53b1737e978d 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -30,8 +30,8 @@ static void blk_done_softirq(struct softirq_action *h)
 	while (!list_empty(&local_list)) {
 		struct request *rq;
 
-		rq = list_entry(local_list.next, struct request, queuelist);
-		list_del_init(&rq->queuelist);
+		rq = list_entry(local_list.next, struct request, ipi_list);
+		list_del_init(&rq->ipi_list);
 		rq->q->softirq_done_fn(rq);
 	}
 }
@@ -45,14 +45,9 @@ static void trigger_softirq(void *data)
 
 	local_irq_save(flags);
 	list = this_cpu_ptr(&blk_cpu_done);
-	/*
-	 * We reuse queuelist for a list of requests to process. Since the
-	 * queuelist is used by the block layer only for requests waiting to be
-	 * submitted to the device it is unused now.
-	 */
-	list_add_tail(&rq->queuelist, list);
+	list_add_tail(&rq->ipi_list, list);
 
-	if (list->next == &rq->queuelist)
+	if (list->next == &rq->ipi_list)
 		raise_softirq_irqoff(BLOCK_SOFTIRQ);
 
 	local_irq_restore(flags);
@@ -141,7 +136,7 @@ void __blk_complete_request(struct request *req)
 		struct list_head *list;
 do_local:
 		list = this_cpu_ptr(&blk_cpu_done);
-		list_add_tail(&req->queuelist, list);
+		list_add_tail(&req->ipi_list, list);
 
 		/*
 		 * if the list only contains our just added request,
@@ -149,7 +144,7 @@ do_local:
 		 * entries there, someone already raised the irq but it
 		 * hasn't run yet.
 		 */
-		if (list->next == &req->queuelist)
+		if (list->next == &req->ipi_list)
 			raise_softirq_irqoff(BLOCK_SOFTIRQ);
 	} else if (raise_blk_irq(ccpu, req))
 		goto do_local;
diff --git a/block/blk.h b/block/blk.h
index d23b415b8a28..1d880f1f957f 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -78,7 +78,7 @@ static inline void blk_clear_rq_complete(struct request *rq)
 /*
  * Internal elevator interface
  */
-#define ELV_ON_HASH(rq) hash_hashed(&(rq)->hash)
+#define ELV_ON_HASH(rq) ((rq)->cmd_flags & REQ_HASHED)
 
 void blk_insert_flush(struct request *rq);
 void blk_abort_flushes(struct request_queue *q);
diff --git a/block/elevator.c b/block/elevator.c
index 42c45a7d6714..1e01b66a0b92 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -247,6 +247,7 @@ EXPORT_SYMBOL(elevator_exit);
 static inline void __elv_rqhash_del(struct request *rq)
 {
 	hash_del(&rq->hash);
+	rq->cmd_flags &= ~REQ_HASHED;
 }
 
 static void elv_rqhash_del(struct request_queue *q, struct request *rq)
@@ -261,6 +262,7 @@ static void elv_rqhash_add(struct request_queue *q, struct request *rq)
 
 	BUG_ON(ELV_ON_HASH(rq));
 	hash_add(e->hash, &rq->hash, rq_hash_key(rq));
+	rq->cmd_flags |= REQ_HASHED;
 }
 
 static void elv_rqhash_reposition(struct request_queue *q, struct request *rq)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index bbc3a6c88fce..aa0eaa2d0bd8 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -189,6 +189,7 @@ enum rq_flag_bits {
 	__REQ_KERNEL, 		/* direct IO to kernel pages */
 	__REQ_PM,		/* runtime pm request */
 	__REQ_END,		/* last of chain of requests */
+	__REQ_HASHED,		/* on IO scheduler merge hash */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -241,5 +242,6 @@ enum rq_flag_bits {
 #define REQ_KERNEL		(1ULL << __REQ_KERNEL)
 #define REQ_PM			(1ULL << __REQ_PM)
 #define REQ_END			(1ULL << __REQ_END)
+#define REQ_HASHED		(1ULL << __REQ_HASHED)
 
 #endif /* __LINUX_BLK_TYPES_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5a31307c5ded..e402f8421c0c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -118,7 +118,18 @@ struct request {
 	struct bio *bio;
 	struct bio *biotail;
 
-	struct hlist_node hash;	/* merge hash */
+	/*
+	 * The hash is used inside the scheduler, and killed once the
+	 * request reaches the dispatch list. The ipi_list is only used
+	 * to queue the request for softirq completion, which is long
+	 * after the request has been unhashed (and even removed from
+	 * the dispatch list).
+	 */
+	union {
+		struct hlist_node hash;	/* merge hash */
+		struct list_head ipi_list;
+	};
+
 	/*
 	 * The rb_node is only used inside the io scheduler, requests
 	 * are pruned when moved to the dispatch queue. So let the

--------------000300080501040500070004--
