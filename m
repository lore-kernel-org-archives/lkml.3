Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaCBICa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 03:02:30 -0500
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:27936 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720AbaCBIC2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 03:02:28 -0500
From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v2 03/23] bfa: Cleanup bfad_setup_intr() function
Thread-Topic: [PATCH v2 03/23] bfa: Cleanup bfad_setup_intr() function
Thread-Index: AQHPMTjeWejTxJ3+OUeYmwYz3OvlWprNeO8g
Date: Sun, 2 Mar 2014 08:02:24 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59F7A207@avmb2.qlogic.org>
References: <cover.1393191330.git.agordeev@redhat.com>
 <c3fb3d552113a7c180741cf9f577081fc690366f.1393191330.git.agordeev@redhat.com>
In-Reply-To: <c3fb3d552113a7c180741cf9f577081fc690366f.1393191330.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7364 signatures=668951
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1403010266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch look good.
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Alexander Gordeev
Sent: 24 February 2014 13:32
To: linux-kernel
Cc: Alexander Gordeev; Anil Gurumurthy; Vijaya Mohan Guvva; linux-scsi; linux-pci
Subject: [PATCH v2 03/23] bfa: Cleanup bfad_setup_intr() function

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/bfa/bfad.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index 972ff8d..e7e4774 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1219,7 +1219,7 @@ bfad_install_msix_handler(struct bfad_s *bfad)  int  bfad_setup_intr(struct bfad_s *bfad)  {
-       int error = 0;
+       int error;
        u32 mask = 0, i, num_bit = 0, max_bit = 0;
        struct msix_entry msix_entries[MAX_MSIX_ENTRY];
        struct pci_dev *pdev = bfad->pcidev;
@@ -1279,20 +1279,18 @@ bfad_setup_intr(struct bfad_s *bfad)

                bfad->bfad_flags |= BFAD_MSIX_ON;

-               return error;
+               return 0;
        }

 line_based:
-       error = 0;
-       if (request_irq
-           (bfad->pcidev->irq, (irq_handler_t) bfad_intx, BFAD_IRQ_FLAGS,
-            BFAD_DRIVER_NAME, bfad) != 0) {
-               /* Enable interrupt handler failed */
-               return 1;
-       }
+       error = request_irq(bfad->pcidev->irq, (irq_handler_t)bfad_intx,
+                           BFAD_IRQ_FLAGS, BFAD_DRIVER_NAME, bfad);
+       if (error)
+               return error;
+
        bfad->bfad_flags |= BFAD_INTX_ON;

-       return error;
+       return 0;
 }

 void
--
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
