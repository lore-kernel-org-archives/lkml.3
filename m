Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbaBUNCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:02:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47862 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337AbaBUNCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 56/60] IB/qib: Add missing serdes init sequence
Date: Fri, 21 Feb 2014 13:01:23 +0000
Message-Id: <1392987687-15367-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 2f75e12c4457a9b3d042c0a0d748fa198dc2ffaf upstream.

Research has shown that commit a77fcf895046 ("IB/qib: Use a single
txselect module parameter for serdes tuning") missed a key serdes init
sequence.

This patch add that sequence.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/hw/qib/qib_iba7322.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index c881e74..a7bbde9 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2279,6 +2279,11 @@ static int qib_7322_bringup_serdes(struct qib_pportdata *ppd)
 	qib_write_kreg_port(ppd, krp_ibcctrl_a, ppd->cpspec->ibcctrl_a);
 	qib_write_kreg(dd, kr_scratch, 0ULL);
 
+	/* ensure previous Tx parameters are not still forced */
+	qib_write_kreg_port(ppd, krp_tx_deemph_override,
+		SYM_MASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+		reset_tx_deemphasis_override));
+
 	if (qib_compat_ddr_negotiate) {
 		ppd->cpspec->ibdeltainprog = 1;
 		ppd->cpspec->ibsymsnap = read_7322_creg32_port(ppd,
-- 
1.9.0

