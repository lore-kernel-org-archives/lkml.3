Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaFFXIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:08:05 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44744 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaFFXID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:08:03 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mike Marciniszyn <infinipath@intel.com>, Roland Dreier <roland@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] infiniband: hw: ipath: ipath_diag.c:  Cleaning up code that is not handled properly.
Date: Sat,  7 Jun 2014 01:08:56 +0200
Message-Id: <1402096136-9919-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of the code is adapted to handle a struct ipath_diag_pkt.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/infiniband/hw/ipath/ipath_diag.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_diag.c b/drivers/infiniband/hw/ipath/ipath_diag.c
index e2f9a51..39ba797 100644
--- a/drivers/infiniband/hw/ipath/ipath_diag.c
+++ b/drivers/infiniband/hw/ipath/ipath_diag.c
@@ -327,7 +327,6 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
 {
 	u32 __iomem *piobuf;
 	u32 plen, pbufn, maxlen_reserve;
-	struct ipath_diag_pkt odp;
 	struct ipath_diag_xpkt dp;
 	u32 *tmpbuf = NULL;
 	struct ipath_devdata *dd;
@@ -341,11 +340,6 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
 			ret = -EFAULT;
 			goto bail;
 		}
-	} else if (count == sizeof(odp)) {
-		if (copy_from_user(&odp, data, sizeof(odp))) {
-			ret = -EFAULT;
-			goto bail;
-		}
 	} else {
 		ret = -EINVAL;
 		goto bail;
-- 
1.7.10.4

