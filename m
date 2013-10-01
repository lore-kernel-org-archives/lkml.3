Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3JAMqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 08:46:13 -0400
Received: from smtp2.stec-inc.com ([68.225.24.15]:48753 "EHLO
	smtp2.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3JAMqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 08:46:11 -0400
X-Greylist: delayed 1154 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Oct 2013 08:46:11 EDT
X-ASG-Debug-ID: 1380631731-486f64f00001-xx1T2L
X-Barracuda-Envelope-From: osengineering@stec-inc.com
From: OS Engineering <osengineering@stec-inc.com>
X-Barracuda-Apparent-Source-IP: fe80::30dd:fd5:3d97:5f13
To: "axboe@kernel.dk" <axboe@kernel.dk>
CC: Akhil Bhansali <Akhil.Bhansali@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>
Subject: [PATCH 2/2] skd: Restricted pr_debug() lines to 80 characters
Thread-Topic: [PATCH 2/2] skd: Restricted pr_debug() lines to 80 characters
X-ASG-Orig-Subj: [PATCH 2/2] skd: Restricted pr_debug() lines to 80 characters
Thread-Index: Ac6+odK2MHzWnSfoQY+RdUd0+7bKnA==
Date: Tue, 1 Oct 2013 12:29:07 +0000
Message-ID: <26D762E250385C4D8E9D6EC3C8E47DC11E70588B@sambx4.stec-inc.ad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.125.250]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: sacas02.stec-inc.ad[172.17.3.1]
X-Barracuda-Start-Time: 1380631731
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://saspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.141083
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 6ff5102b3cd8047bb4bfb4d0165f289249e23bbe Mon Sep 17 00:00:00 2001
From: rchinthekindi <rchinthekindi@stec-inc.com>
Date: Tue, 1 Oct 2013 17:49:58 +0530
Subject: [PATCH 2/2] skd: Restricted pr_debug() lines to 80 characters

Restricted pr_debug() lines to 80 characters

Signed-off-by: Ramprasad C <ramprasad.chinthekindi@hgst.com>

---
 drivers/block/skd_main.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 9646dcf..30bc45e 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -864,7 +864,8 @@ static void skd_request_fn(struct request_queue *q)
 			skmsg = skdev->skmsg_free_list;
 			if (skmsg == NULL) {
 				pr_debug("%s:%s:%d Out of msg skdev=%p\n",
-					 skdev->name, __func__, __LINE__, skdev);
+					 skdev->name, __func__, __LINE__,
+					 skdev);
 				break;
 			}
 			SKD_ASSERT(skmsg->state == SKD_MSG_STATE_IDLE);
@@ -1858,7 +1859,8 @@ static int skd_sg_io_obtain_skspcl(struct skd_device *skdev,
 			break;
 		}
 
-		pr_debug("%s:%s:%d blocking\n", skdev->name, __func__, __LINE__);
+		pr_debug("%s:%s:%d blocking\n",
+			 skdev->name, __func__, __LINE__);
 
 		rc = wait_event_interruptible_timeout(
 				skdev->waitq,
@@ -2370,9 +2372,10 @@ static void skd_complete_internal(struct skd_device *skdev,
 			skd_send_internal_skspcl(skdev, skspcl, WRITE_BUFFER);
 		else {
 			if (skdev->state == SKD_DRVR_STATE_STOPPING) {
-				pr_debug("%s:%s:%d TUR failed, don't send anymore"
-					 "state 0x%x\n",
-					 skdev->name, __func__, __LINE__, skdev->state);
+				pr_debug("%s:%s:%d TUR failed, don't send"
+					 " anymore state 0x%x\n",
+					 skdev->name, __func__, __LINE__,
+					 skdev->state);
 				return;
 			}
 			pr_debug("%s:%s:%d **** TUR failed, retry skerr\n",
@@ -2386,9 +2389,10 @@ static void skd_complete_internal(struct skd_device *skdev,
 			skd_send_internal_skspcl(skdev, skspcl, READ_BUFFER);
 		else {
 			if (skdev->state == SKD_DRVR_STATE_STOPPING) {
-				pr_debug("%s:%s:%d write buffer failed, don't send"
-					 " anymore state 0x%x\n",
-					 skdev->name, __func__, __LINE__, skdev->state);
+				pr_debug("%s:%s:%d write buffer failed,"
+					 " don't send anymore state 0x%x\n",
+					 skdev->name, __func__, __LINE__,
+					 skdev->state);
 				return;
 			}
 			pr_debug("%s:%s:%d "
@@ -3700,11 +3704,13 @@ static void skd_recover_requests(struct skd_device *skdev, int requeue)
 		if (skspcl->req.state == SKD_REQ_STATE_BUSY) {
 			if (skspcl->orphaned) {
 				pr_debug("%s:%s:%d orphaned %p\n",
-					 skdev->name, __func__, __LINE__, skspcl);
+					 skdev->name, __func__, __LINE__,
+					 skspcl);
 				skd_release_special(skdev, skspcl);
 			} else {
 				pr_debug("%s:%s:%d not orphaned %p\n",
-					 skdev->name, __func__, __LINE__, skspcl);
+					 skdev->name, __func__, __LINE__,
+					 skspcl);
 				skspcl->req.state = SKD_REQ_STATE_ABORTED;
 			}
 		}
@@ -4615,7 +4621,8 @@ static struct skd_device *skd_construct(struct pci_dev *pdev)
 	return skdev;
 
 err_out:
-	pr_debug("%s:%s:%d construct failed\n", skdev->name, __func__, __LINE__);
+	pr_debug("%s:%s:%d construct failed\n",
+		 skdev->name, __func__, __LINE__);
 	skd_destruct(skdev);
 	return NULL;
 }
-- 
1.7.5.4
