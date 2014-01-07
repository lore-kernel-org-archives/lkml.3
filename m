Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaAGIs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:48:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:24786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbaAGIs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:48:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="462791457"
Subject: [PATCH 2/3] xfs: Calling destroy_work_on_stack() to pair with
 INIT_WORK_ONSTACK()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: dchinner@fromorbit.com, bpm@sgi.com
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1389084605.3650.66.camel@cliu38-desktop-build>
References: <1389084605.3650.66.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jan 2014 16:53:34 +0800
Message-ID: <1389084814.3650.70.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
call destroy_work_on_stack() which frees the debug object to pair
with INIT_WORK_ONSTACK().

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 fs/xfs/xfs_bmap_util.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1394106..82e0dab 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -287,6 +287,7 @@ xfs_bmapi_allocate(
 	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
 	queue_work(xfs_alloc_wq, &args->work);
 	wait_for_completion(&done);
+	destroy_work_on_stack(&args->work);
 	return args->result;
 }
 
-- 
1.7.9.5



