Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3KBRZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 13:25:53 -0400
Received: from mout.gmx.net ([212.227.17.21]:53780 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab3KBRZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 13:25:15 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Peter Huewe <PeterHuewe@gmx.de>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 4/6] tpm/tpm_ibmvtpm: fix unreachable code warning (smatch warning)
Date: Sat,  2 Nov 2013 18:24:59 +0100
Message-Id: <1383413101-10975-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1383413101-10975-1-git-send-email-peterhuewe@gmx.de>
References: <trinity-0ea948ed-45da-4711-91da-0d251d630d89-1383412993117@3capp-gmx-bs02>
 <1383413101-10975-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:Kz84nLMKSgkSrQs3wdnbqMGQPjRC3i2TqGbJKv2Pl8vD+dVMy1n
 YTR4eXwkxiwyeLfsEiIUaPX0YbNm3L9YD+fQ60mWuGTw+NX4GONBhiXnxs4fVbgkltCfdJM
 rv1xgNos8itLXSOHajkec7OVau91t26AxJr3xVuhoK0DVrmTq87t1fufdkhBqksbIpUtWuW
 P/NI8IwTlIwJWrQqX7myw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <PeterHuewe@gmx.de>

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
1.7.5.4

