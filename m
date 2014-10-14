Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbaJNNi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:38:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:41779 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276AbaJNNi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:38:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,717,1406617200"; 
   d="scan'208";a="618395396"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: JBottomley@parallels.com
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] scsi: Resolve some missing-field-initializers warnings
Date: Tue, 14 Oct 2014 06:38:53 -0700
Message-Id: <1413293933-31164-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve some missing-field-initializers warnings by using
designated initialization.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index db8c449..4d59256 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -47,7 +47,7 @@ struct scsi_host_sg_pool {
 	mempool_t	*pool;
 };
 
-#define SP(x) { x, "sgpool-" __stringify(x) }
+#define SP(x) { .size = x, "sgpool-" __stringify(x) }
 #if (SCSI_MAX_SG_SEGMENTS < 32)
 #error SCSI_MAX_SG_SEGMENTS is too small (must be 32 or greater)
 #endif
-- 
1.9.3

