Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaDPMMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:12:31 -0400
Received: from avcashub1.qlogic.com ([198.70.193.115]:22804 "EHLO
	avcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaDPMM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:12:29 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2014 08:12:29 EDT
From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Anil Gurumurthy <agurumur@brocade.com>,
        Vijaya Mohan Guvva <vmohan@brocade.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v2 RESEND 03/23] bfa: Cleanup bfad_setup_intr() function
Thread-Topic: [PATCH v2 RESEND 03/23] bfa: Cleanup bfad_setup_intr() function
Thread-Index: AQHPV7wwi26bmf1X8U+WXnJqkpGj9JsT9i+g
Date: Wed, 16 Apr 2014 09:04:18 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59F827EF@avmb2.qlogic.org>
References: <cover.1397461652.git.agordeev@redhat.com>
 <29a53def04235be5b589838a851df8f90788247a.1397461652.git.agordeev@redhat.com>
In-Reply-To: <29a53def04235be5b589838a851df8f90788247a.1397461652.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch look good.
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Alexander Gordeev
Sent: 14 April 2014 13:35
To: linux-kernel
Cc: Alexander Gordeev; Anil Gurumurthy; Vijaya Mohan Guvva; linux-scsi; linux-pci
Subject: [PATCH v2 RESEND 03/23] bfa: Cleanup bfad_setup_intr() function

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
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
