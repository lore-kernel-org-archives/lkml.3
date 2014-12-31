Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaLaMlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 07:41:51 -0500
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:4212 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbaLaMlu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 07:41:50 -0500
From: Nilesh Javali <nilesh.javali@qlogic.com>
To: Nicholas Mc Guire <der.herr@hofr.at>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dept-Eng QLogic Storage Upstream 
	<QLogic-Storage-Upstream@qlogic.com>
Subject: RE: [PATCH] scsi: unnecessary double init_completion removed
Thread-Topic: [PATCH] scsi: unnecessary double init_completion removed
Thread-Index: AQHQHttspjaHrMwNVEiOMKa/zlqPmZyprrQQ
Date: Wed, 31 Dec 2014 12:40:50 +0000
Message-ID: <058691E078642A44B7C96BB0B1DB4F2481C52A55@avmb2.qlogic.org>
References: <1419357628-23050-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1419357628-23050-1-git-send-email-der.herr@hofr.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7667 signatures=670598
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1412310124
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Nilesh Javali <nilesh.javali@qlogic.com>

I will send the maintainer list update patch.

Thanks,
Nilesh

-----Original Message-----
From: Nicholas Mc Guire [mailto:der.herr@hofr.at] 
Sent: Tuesday, December 23, 2014 11:30 PM
To: James E.J. Bottomley
Cc: Dept-Eng iSCSI Driver; linux-scsi; linux-kernel; Nicholas Mc Guire
Subject: [PATCH] scsi: unnecessary double init_completion removed

The double call to init_completion(&ha->disable_acb_comp); looks like an editing mistake only - dropped.

patch is against 3.18.0 linux-next

scripts/get_maintainer.pl -f drivers/scsi/qla4xxx/ql4_os.c returned Vikas Chaudhary <vikas.chaudhary@qlogic.com> (supporter:QLOGIC QLA4XXX iS...) but that no longer seems to be a valid e-mail address.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/scsi/qla4xxx/ql4_os.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c index 6d25879..0c1da76 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -8672,7 +8672,6 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 	init_completion(&ha->disable_acb_comp);
 	init_completion(&ha->idc_comp);
 	init_completion(&ha->link_up_comp);
-	init_completion(&ha->disable_acb_comp);

 	spin_lock_init(&ha->hardware_lock);
 	spin_lock_init(&ha->work_lock);
--
1.7.10.4

