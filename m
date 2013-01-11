Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3AKJBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:01:44 -0500
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:43670 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260Ab3AKJBm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:01:42 -0500
X-Greylist: delayed 1666 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2013 04:01:42 EST
From: Anil Gurumurthy <agurumur@Brocade.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Vijay Mohan Guvva <vmohan@Brocade.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Fri, 11 Jan 2013 01:33:39 -0700
Subject: RE: [patch] [SCSI] bfa: fix strncpy() limiter in bfad_start_ops()
Thread-Topic: [patch] [SCSI] bfa: fix strncpy() limiter in bfad_start_ops()
Thread-Index: Ac3vEd85NPaQJXt+R2KucfJY2n542gAw09kw
Message-ID: <4D34E914CE7A004D8570F4381FDE55490B6D93F914@BRM-EXCH-3.corp.brocade.com>
References: <20130110090620.GE23063@elgon.mountain>
In-Reply-To: <20130110090620.GE23063@elgon.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-01-11_04:2013-01-11,2013-01-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=8 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1211240000 definitions=main-1301110008
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dan Carpenter
Sent: Thursday, January 10, 2013 2:36 PM
To: Anil Gurumurthy
Cc: Vijay Mohan Guvva; James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] bfa: fix strncpy() limiter in bfad_start_ops()

The closing parenthesis is in the wrong place so it takes the sizeof a pointer instead of the sizeof the buffer minus one.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index e6bf126..a5f7690 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1034,7 +1034,7 @@ bfad_start_ops(struct bfad_s *bfad) {
 			sizeof(driver_info.host_os_patch) - 1);
 
 	strncpy(driver_info.os_device_name, bfad->pci_name,
-		sizeof(driver_info.os_device_name - 1));
+		sizeof(driver_info.os_device_name) - 1);
 
 	/* FCS driver info init */
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
--


Looks good. Thanks for the patch, Dan.

Acked-by: Anil Gurumurthy<agurumur@brocade.com>


To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
