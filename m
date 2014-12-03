Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaLCPUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:20:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45065 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaLCPUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:20:01 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: oded.gabbay@amd.com
Cc: airlied@linux.ie, alexander.deucher@amd.com, j.glisse@gmail.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John.Bridgman@amd.com, Andrew.Lewycky@amd.com, joro@8bytes.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] amdkfd: use atomic allocations within srcu callbacks
Date: Wed,  3 Dec 2014 10:19:36 -0500
Message-Id: <1417619976-8498-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

srcu callbacks are running in atomic context, we can't allocate using
__GFP_WAIT.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index b4f49ac..b85eb0b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -196,7 +196,7 @@ static void kfd_process_destroy_delayed(struct rcu_head *rcu)
 	mmdrop(p->mm);
 
 	work = (struct kfd_process_release_work *)
-		kmalloc(sizeof(struct kfd_process_release_work), GFP_KERNEL);
+		kmalloc(sizeof(struct kfd_process_release_work), GFP_ATOMIC);
 
 	if (work) {
 		INIT_WORK((struct work_struct *) work, kfd_process_wq_release);
-- 
2.1.0

