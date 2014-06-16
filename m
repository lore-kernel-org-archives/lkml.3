Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaFPGby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 02:31:54 -0400
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:14482 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753808AbaFPGbx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 02:31:53 -0400
From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
To: Joe Perches <joe@perches.com>, linux-kernel <linux-kernel@vger.kernel.org>
CC: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH -next 15/26] bfa: Use dma_zalloc_coherent
Thread-Topic: [PATCH -next 15/26] bfa: Use dma_zalloc_coherent
Thread-Index: AQHPiNnSOzzJXOYI+UKmpk6pelJxuZtzRomA
Date: Mon, 16 Jun 2014 06:31:43 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59F98DD4@avmb2.qlogic.org>
References: <cover.1402863904.git.joe@perches.com>
 <bd5384bd59bf7eb9bf616832f5c51fdb96be9764.1402863905.git.joe@perches.com>
In-Reply-To: <bd5384bd59bf7eb9bf616832f5c51fdb96be9764.1402863905.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7470 signatures=670466
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1406160075
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch.
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: Joe Perches [mailto:joe@perches.com]
Sent: 16 June 2014 02:08
To: linux-kernel
Cc: Anil Gurumurthy; Sudarsana Kalluru; James E.J. Bottomley; linux-scsi
Subject: [PATCH -next 15/26] bfa: Use dma_zalloc_coherent

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bfa/bfad_bsg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c index 8994fb8..65f3e74 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3270,13 +3270,13 @@ bfad_fcxp_map_sg(struct bfad_s *bfad, void *payload_kbuf,
        /* Allocate dma coherent memory */
        buf_info = buf_base;
        buf_info->size = payload_len;
-       buf_info->virt = dma_alloc_coherent(&bfad->pcidev->dev, buf_info->size,
-                                       &buf_info->phys, GFP_KERNEL);
+       buf_info->virt = dma_zalloc_coherent(&bfad->pcidev->dev,
+                                            buf_info->size, &buf_info->phys,
+                                            GFP_KERNEL);
        if (!buf_info->virt)
                goto out_free_mem;

        /* copy the linear bsg buffer to buf_info */
-       memset(buf_info->virt, 0, buf_info->size);
        memcpy(buf_info->virt, payload_kbuf, buf_info->size);

        /*
--
1.8.1.2.459.gbcd45b4.dirty


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
