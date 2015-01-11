Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbbAKOBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 09:01:38 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62926 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbbAKOBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 09:01:37 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mike Marciniszyn <infinipath@intel.com>, Roland Dreier <roland@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] IB: qib: qib_iba7322: Remove unused function
Date: Sun, 11 Jan 2015 15:04:42 +0100
Message-Id: <1420985082-17977-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function qib_read_ureg() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index a7eb325..a57b1a2 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -783,28 +783,6 @@ static inline u32 qib_read_ureg32(const struct qib_devdata *dd,
 }
 
 /**
- * qib_read_ureg - read virtualized per-context register
- * @dd: device
- * @regno: register number
- * @ctxt: context number
- *
- * Return the contents of a register that is virtualized to be per context.
- * Returns -1 on errors (not distinguishable from valid contents at
- * runtime; we may add a separate error variable at some point).
- */
-static inline u64 qib_read_ureg(const struct qib_devdata *dd,
-				enum qib_ureg regno, int ctxt)
-{
-
-	if (!dd->kregbase || !(dd->flags & QIB_PRESENT))
-		return 0;
-	return readq(regno + (u64 __iomem *)(
-		(dd->ureg_align * ctxt) + (dd->userbase ?
-		 (char __iomem *)dd->userbase :
-		 (char __iomem *)dd->kregbase + dd->uregbase)));
-}
-
-/**
  * qib_write_ureg - write virtualized per-context register
  * @dd: device
  * @regno: register number
-- 
1.7.10.4

