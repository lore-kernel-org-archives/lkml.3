Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaGBFQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:16:27 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:17788 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbaGBFQ0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:16:26 -0400
From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/1] [SCSI] bfa: use ARRAY_SIZE instead of
 sizeof/sizeof[0]
Thread-Topic: [PATCH 1/1] [SCSI] bfa: use ARRAY_SIZE instead of
 sizeof/sizeof[0]
Thread-Index: AQHPlIrsWYlPXIpLpU6wTn6//9sr35uMQEHw
Date: Wed, 2 Jul 2014 05:16:15 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59F9B24F@avmb2.qlogic.org>
References: <1404150162-7973-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1404150162-7973-1-git-send-email-fabf@skynet.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7486 signatures=670476
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1407020070
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>


-----Original Message-----
From: Fabian Frederick [mailto:fabf@skynet.be]
Sent: 30 June 2014 23:13
To: linux-kernel
Cc: Fabian Frederick; Anil Gurumurthy; Sudarsana Kalluru; James E.J. Bottomley; linux-scsi
Subject: [PATCH 1/1] [SCSI] bfa: use ARRAY_SIZE instead of sizeof/sizeof[0]

Use macro definition

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/bfa/bfa_fcs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c index a3ab5cc..0f19455 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -81,7 +81,7 @@ bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
        bfa->fcs = BFA_TRUE;
        fcbuild_init();

-       for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
+       for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
                mod = &fcs_modules[i];
                if (mod->attach)
                        mod->attach(fcs);
@@ -97,7 +97,7 @@ bfa_fcs_init(struct bfa_fcs_s *fcs)
        int     i;
        struct bfa_fcs_mod_s  *mod;

-       for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
+       for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
                mod = &fcs_modules[i];
                if (mod->modinit)
                        mod->modinit(fcs);
@@ -184,7 +184,7 @@ bfa_fcs_exit(struct bfa_fcs_s *fcs)

        bfa_wc_init(&fcs->wc, bfa_fcs_exit_comp, fcs);

-       nmods = sizeof(fcs_modules) / sizeof(fcs_modules[0]);
+       nmods = ARRAY_SIZE(fcs_modules);

        for (i = 0; i < nmods; i++) {

--
1.8.4.5


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
