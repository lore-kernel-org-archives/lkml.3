Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3JVRy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:54:28 -0400
Received: from mout.gmx.net ([212.227.15.18]:56234 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab3JVRyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:54:22 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 02/15] tpm: ibmvtpm: Use %zd formatting for size_t format arguments
Date: Tue, 22 Oct 2013 19:53:47 +0200
Message-Id: <1382464440-7579-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382464440-7579-1-git-send-email-peterhuewe@gmx.de>
References: <1382464440-7579-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:VggJv7crAr/lOcRQqVIAJobqhfHR6SOimRKV13l3s+NHI1s7Qqp
 32vDML83Nmfz8bqbmc9ePaP4OZapbBfzqmkyNPTMiGTjJoL+KWdAX6wK72otgKP4VecJvyh
 hrxwMYD3cH51hG7jbI3C/hq88barVH5FmvElUs1Pc33A0aMh5mCnhnYp2Yy55G4+XiHUx/K
 oV73+nt9e/B+9Qv0StDZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

This suppresses compile warnings on 32 bit builds.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Acked-by: Ashley Lai <adlai@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm_ibmvtpm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 56b07c3..838f043 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -98,7 +98,7 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	if (count < len) {
 		dev_err(ibmvtpm->dev,
-			"Invalid size in recv: count=%ld, crq_size=%d\n",
+			"Invalid size in recv: count=%zd, crq_size=%d\n",
 			count, len);
 		return -EIO;
 	}
@@ -136,7 +136,7 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	if (count > ibmvtpm->rtce_size) {
 		dev_err(ibmvtpm->dev,
-			"Invalid size in send: count=%ld, rtce_size=%d\n",
+			"Invalid size in send: count=%zd, rtce_size=%d\n",
 			count, ibmvtpm->rtce_size);
 		return -EIO;
 	}
-- 
1.7.5.4

