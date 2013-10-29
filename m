Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3J2A4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 20:56:35 -0400
Received: from mout.gmx.net ([212.227.15.18]:65026 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab3J2A4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 20:56:33 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: Ashley Lai <ashley@ashleylai.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] tpm/tpm_ibmvtpm: fix unreachable code warning (smatch warning)
Date: Tue, 29 Oct 2013 01:59:57 +0100
Message-Id: <1383008397-28505-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Provags-ID: V03:K0:2F/nl4dcP5nWwP/mfoh1KVNLJiWcMhpd+I0KH91Cmm9ZsGXNsaN
 33+ALp6jWzeCy27lpfQBWf5foclcT8EmOQqiDgyqgyEudZ8Pgwl9PhNi0kSLIpaw20n2Zb8
 2IneBbKxCVCSisn5C9EduYQaozGRR7VMqc5X4dSSeKSYTM0PKP/RSH8Bz5qLZxwL403wn/4
 RUGMp+SbAYSZeBml3+WyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smatch complains:
/data/data-old/linux-2.6/drivers/char/tpm/tpm_ibmvtpm.c:510
ibmvtpm_crq_process() info: ignoring unreachable code.

-> The return is not necessary here, remove it

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_ibmvtpm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 2783a42..cab8d09 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -507,7 +507,6 @@ static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
 			dev_err(ibmvtpm->dev, "Unknown crq message type: %d\n", crq->msg);
 			return;
 		}
-		return;
 	case IBMVTPM_VALID_CMD:
 		switch (crq->msg) {
 		case VTPM_GET_RTCE_BUFFER_SIZE_RES:
-- 
1.7.8.6

