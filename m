Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbaKUEUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 23:20:22 -0500
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:23079 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756947AbaKUEUV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 23:20:21 -0500
From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        "James E. J. Bottomley" <JBottomley@parallels.com>,
        Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Julia Lawall" <julia.lawall@lip6.fr>
Subject: RE: [PATCH 1/1] SCSI-bfa: Deletion of an unnecessary check before
 the function call "vfree"
Thread-Topic: [PATCH 1/1] SCSI-bfa: Deletion of an unnecessary check before
 the function call "vfree"
Thread-Index: AQHQBRP0WF+YcLm2oE+SZI+ObmOVRJxqeqXg
Date: Fri, 21 Nov 2014 04:20:04 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59FD4B5D@avmb2.qlogic.org>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <546E6F5C.6050604@users.sourceforge.net>
In-Reply-To: <546E6F5C.6050604@users.sourceforge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7628 signatures=670578
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1411210037
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch looks good. 
Thanks!
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: SF Markus Elfring [mailto:elfring@users.sourceforge.net] 
Sent: 21 November 2014 04:17
To: Anil Gurumurthy; James E. J. Bottomley; Sudarsana Kalluru; linux-scsi
Cc: linux-kernel; kernel-janitors@vger.kernel.org; Julia Lawall
Subject: [PATCH 1/1] SCSI-bfa: Deletion of an unnecessary check before the function call "vfree"

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 23:43:17 +0100

The vfree() function performs also input parameter validation. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/bfa/bfad_debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c index 8e83d04..a72170f 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -399,8 +399,7 @@ bfad_debugfs_release_fwtrc(struct inode *inode, struct file *file)
 	if (!fw_debug)
 		return 0;
 
-	if (fw_debug->debug_buffer)
-		vfree(fw_debug->debug_buffer);
+	vfree(fw_debug->debug_buffer);
 
 	file->private_data = NULL;
 	kfree(fw_debug);
--
2.1.3

