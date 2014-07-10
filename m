Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaGJVyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:54:54 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:54570 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaGJVyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:54:50 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 29/83] hsa/radeon: Fix memory size allocated for HPD
Date: Fri, 11 Jul 2014 00:53:45 +0300
Message-Id: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_sched_cik_static.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
index 3c3e7d6..5bfde5c 100644
--- a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
+++ b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
@@ -433,7 +433,7 @@ static int cik_static_create(struct kfd_dev *dev, struct kfd_scheduler **schedul
 	 * are no active queues.
 	 */
 	err = radeon_kfd_vidmem_alloc(dev,
-				      CIK_HPD_SIZE * priv->num_pipes * 2,
+				      CIK_HPD_SIZE * priv->num_pipes,
 				      PAGE_SIZE,
 				      KFD_MEMPOOL_SYSTEM_WRITECOMBINE,
 				      &priv->hpd_mem);
-- 
1.9.1

