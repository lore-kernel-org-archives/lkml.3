Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892AbaGCJWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:22:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51691 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbaGCJWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 051/198] IB/ipath: Translate legacy diagpkt into newer extended diagpkt
Date: Thu,  3 Jul 2014 10:18:14 +0100
Message-Id: <1404379241-8590-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Dalessandro <dennis.dalessandro@intel.com>

commit 7e6d3e5c70f13874fb06e6b67696ed90ce79bd48 upstream.

This patch addresses an issue where the legacy diagpacket is sent in
from the user, but the driver operates on only the extended
diagpkt. This patch specifically initializes the extended diagpkt
based on the legacy packet.

Reported-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/hw/ipath/ipath_diag.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/ipath/ipath_diag.c b/drivers/infiniband/hw/ipath/ipath_diag.c
index e2f9a51f4a38..45802e97332e 100644
--- a/drivers/infiniband/hw/ipath/ipath_diag.c
+++ b/drivers/infiniband/hw/ipath/ipath_diag.c
@@ -346,6 +346,10 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
 			ret = -EFAULT;
 			goto bail;
 		}
+		dp.len = odp.len;
+		dp.unit = odp.unit;
+		dp.data = odp.data;
+		dp.pbc_wd = 0;
 	} else {
 		ret = -EINVAL;
 		goto bail;
-- 
1.9.1

