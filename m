Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbaFJLYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:24:55 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:25663 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbaFJLYy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:24:54 -0400
From: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>,
        Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/11] drivers/scsi/bfa/bfad_bsg.c: Remove useless return
 variables
Thread-Topic: [PATCH 5/11] drivers/scsi/bfa/bfad_bsg.c: Remove useless
 return variables
Thread-Index: AQHPfNLOOzBy0epErECQOzz3CjNwbptqQ1rA
Date: Tue, 10 Jun 2014 11:24:46 +0000
Message-ID: <C08020CBD5BE83488A998B4818797E8414288A@avmb3.qlogic.org>
References: <1401542051-3174-5-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1401542051-3174-5-git-send-email-peter.senna@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7464 signatures=670465
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1406100134
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch.
Acked-by: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Peter Senna Tschudin
Sent: 31 May 2014 18:44
To: Anil Gurumurthy
Cc: kernel-janitors@vger.kernel.org; Sudarsana Kalluru; James E.J. Bottomley; linux-scsi; linux-kernel
Subject: [PATCH 5/11] drivers/scsi/bfa/bfad_bsg.c: Remove useless return variables

This patch remove variables that are initialized with a constant, are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret = C;
... when != ret
    when strict
return
- ret
+ C
;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/scsi/bfa/bfad_bsg.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c index 8994fb8..a6ee1cf 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -26,7 +26,6 @@ int
 bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)  {
        struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
-       int     rc = 0;
        unsigned long   flags;

        spin_lock_irqsave(&bfad->bfad_lock, flags); @@ -34,7 +33,7 @@ bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
        if (!bfa_ioc_is_disabled(&bfad->bfa.ioc)) {
                spin_unlock_irqrestore(&bfad->bfad_lock, flags);
                iocmd->status = BFA_STATUS_OK;
-               return rc;
+               return 0;
        }

        init_completion(&bfad->enable_comp);
@@ -43,21 +42,20 @@ bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
        spin_unlock_irqrestore(&bfad->bfad_lock, flags);
        wait_for_completion(&bfad->enable_comp);

-       return rc;
+       return 0;
 }

 int
 bfad_iocmd_ioc_disable(struct bfad_s *bfad, void *cmd)  {
        struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
-       int     rc = 0;
        unsigned long   flags;

        spin_lock_irqsave(&bfad->bfad_lock, flags);
        if (bfa_ioc_is_disabled(&bfad->bfa.ioc)) {
                spin_unlock_irqrestore(&bfad->bfad_lock, flags);
                iocmd->status = BFA_STATUS_OK;
-               return rc;
+               return 0;
        }

        if (bfad->disable_active) {
@@ -74,7 +72,7 @@ bfad_iocmd_ioc_disable(struct bfad_s *bfad, void *cmd)
        bfad->disable_active = BFA_FALSE;
        iocmd->status = BFA_STATUS_OK;

-       return rc;
+       return 0;
 }

 static int

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
