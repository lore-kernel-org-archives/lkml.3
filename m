Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaLAKYC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:24:02 -0500
Received: from mout.web.de ([212.227.17.12]:56803 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbaLAKYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:24:00 -0500
Message-ID: <547C41B7.1060604@users.sourceforge.net>
Date: Mon, 01 Dec 2014 11:23:51 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alex Elder <elder@kernel.org>, Sage Weil <sage@inktank.com>,
        Yehuda Sadeh <yehuda@inktank.com>, Ceph <ceph-devel@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] block-rbd: Delete a check before ceph_put_snap_context()
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:1zjwxdxvDxuyePHHQ2jXsA2fofoMIgf8x8PQxIbcrL3WSwfdRPz
 mbiO5FDpsinBh9a1u5v6zr37U7+QBPXSGODex9xGySIjMTFCmmQL8WLgTvM3KuL/3ggJUxb
 f5ayq4Inm5hmTErH2Nhk08PMIqBfb6neD1WXZztxlmYU/fMfm0gctvTCa4mRD/b/SfBFrJ2
 fCWVSGnuKs2cvhnTBU7zQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 1 Dec 2014 11:18:21 +0100

The ceph_put_snap_context() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/block/rbd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 27b71a0..3c34ab5 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3405,8 +3405,7 @@ err_rq:
 	if (result)
 		rbd_warn(rbd_dev, "%s %llx at %llx result %d",
 			 obj_op_name(op_type), length, offset, result);
-	if (snapc)
-		ceph_put_snap_context(snapc);
+	ceph_put_snap_context(snapc);
 	blk_end_request_all(rq, result);
 }
 
-- 
2.1.3

