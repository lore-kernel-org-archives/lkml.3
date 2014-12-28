Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaL1QpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:45:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36391 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaL1QpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:45:00 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: oded.gabbay@amd.com
Cc: airlied@linux.ie, alexander.deucher@amd.com, j.glisse@gmail.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John.Bridgman@amd.com, Andrew.Lewycky@amd.com, joro@8bytes.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] amdkfd: actually allocate longs for the pasid bitmask
Date: Sun, 28 Dec 2014 11:44:37 -0500
Message-Id: <1419785077-25800-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "amdkfd: use sizeof(long) granularity for the pasid bitmask" calculated
the number of longs it will need, but ended up allocating that number of
bytes rather than longs.

Fix that silly error and allocate the amount of data really required.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_pasid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c b/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
index 71699ad..4c25ef5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
@@ -32,7 +32,7 @@ int kfd_pasid_init(void)
 {
 	pasid_limit = max_num_of_processes;
 
-	pasid_bitmap = kzalloc(BITS_TO_LONGS(pasid_limit), GFP_KERNEL);
+	pasid_bitmap = kcalloc(BITS_TO_LONGS(pasid_limit), sizeof(long), GFP_KERNEL);
 	if (!pasid_bitmap)
 		return -ENOMEM;
 
-- 
1.7.10.4

