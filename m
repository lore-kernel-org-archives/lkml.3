Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbaD3Izu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:55:50 -0400
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:11746 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758177AbaD3Izr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:55:47 -0400
From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "ldv-project@linuxtesting.org" <ldv-project@linuxtesting.org>
Subject: RE: [PATCH v2] [SCSI] bfa: allocate memory with GFP_ATOMIC in
 spinlock context
Thread-Topic: [PATCH v2] [SCSI] bfa: allocate memory with GFP_ATOMIC in
 spinlock context
Thread-Index: AQHPWtwQ2OF5nVH2Bk2uSx3T954hL5sp7fzg
Date: Wed, 30 Apr 2014 08:55:21 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59F84A96@avmb2.qlogic.org>
References: <1397807922-21722-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1397807922-21722-1-git-send-email-khoroshilov@ispras.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7423 signatures=670425
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1404300145
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch.
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: Alexey Khoroshilov [mailto:khoroshilov@ispras.ru]
Sent: 18 April 2014 13:29
To: Anil Gurumurthy; Sudarsana Kalluru
Cc: Alexey Khoroshilov; James E.J. Bottomley; linux-scsi; linux-kernel; ldv-project@linuxtesting.org
Subject: [PATCH v2] [SCSI] bfa: allocate memory with GFP_ATOMIC in spinlock context

bfa_fcb_pbc_vport_create() is called only from bfa_fcs_pbc_vport_init(), that is called only from bfad_drv_start() with bfad_lock spinlock held.
So the patch replaces GFP_KERNEL with GFP_ATOMIC to avoid sleeping in atomic spinlock context.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/bfa/bfad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index cc0fbcdc5192..7593b7c1d336 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -507,7 +507,7 @@ bfa_fcb_pbc_vport_create(struct bfad_s *bfad, struct bfi_pbc_vport_s pbc_vport)
        struct bfad_vport_s   *vport;
        int rc;

-       vport = kzalloc(sizeof(struct bfad_vport_s), GFP_KERNEL);
+       vport = kzalloc(sizeof(struct bfad_vport_s), GFP_ATOMIC);
        if (!vport) {
                bfa_trc(bfad, 0);
                return;
--
1.8.3.2


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
