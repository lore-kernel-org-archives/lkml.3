Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaADCnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:43:24 -0500
Received: from mout.gmx.net ([212.227.17.22]:54440 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbaADCmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:42:55 -0500
From: Peter Huewe <peterhuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Cc: Ashley Lai <ashley@ashleylai.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Peter Huewe <PeterHuewe@gmx.de>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 04/15] tpm/tpm_ibmvtpm: fix unreachable code warning (smatch warning)
Date: Sat,  4 Jan 2014 03:44:38 +0100
Message-Id: <1388803489-13258-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
References: <201401040335.04980.PeterHuewe@gmx.de>
 <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:IUaDpycrplfHvN1SDCbzRF6tkD/wZNMzkQE90WQK2CjxmP1uJcK
 4FcS7GMtDMiUPTN48k0FA0AeIJA68mFSBlrGSX+4zjnv538DHA7mAVMk1NUgT6wGkjje/iL
 Kd7L8YTRvqEMNkHAAPqhFOSfFopdumvyaTTPLXd/uwKukFhJCDY1C4GRA2rT1HVN1yW0y8z
 7p8hJwLf+7J0WmtpaIQhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <PeterHuewe@gmx.de>

smatch complains:
drivers/char/tpm/tpm_ibmvtpm.c:510
ibmvtpm_crq_process() info: ignoring unreachable code.

-> The return is not necessary here, remove it

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_ibmvtpm.c | 1 -
 1 file changed, 1 deletion(-)

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
1.8.1.5

