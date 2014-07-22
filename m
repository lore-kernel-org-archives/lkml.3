Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbaGVWgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:36:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44789 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933348AbaGVW0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 035/116] IB/ipath: Translate legacy diagpkt into newer extended diagpkt
Date: Tue, 22 Jul 2014 15:20:46 -0700
Message-Id: <1406067727-19683-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/hw/ipath/ipath_diag.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/ipath/ipath_diag.c b/drivers/infiniband/hw/ipath/ipath_diag.c
index e2f9a51..45802e9 100644
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

