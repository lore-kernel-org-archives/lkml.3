Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaGJVzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:55:21 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:62077 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaGJVzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:16 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 37/83] hsa/radeon: Print ISR info only in debug mode
Date: Fri, 11 Jul 2014 00:53:53 +0300
Message-Id: <1405029279-6894-9-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_sched_cik_static.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
index 5bfde5c..7573d25 100644
--- a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
+++ b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
@@ -899,7 +899,7 @@ cik_static_interrupt_isr(struct kfd_scheduler *scheduler, const void *ih_ring_en
 	if (!int_compute_pipe(priv, ihre, &pipe_id))
 		return false;
 
-	dev_info(radeon_kfd_chardev(), "INT(ISR): src=%02x, data=0x%x, pipe=%u, vmid=%u, pasid=%u\n",
+	dev_dbg(radeon_kfd_chardev(), "INT(ISR): src=%02x, data=0x%x, pipe=%u, vmid=%u, pasid=%u\n",
 		 ihre->source_id, ihre->data, pipe_id, ihre->vmid, ihre->pasid);
 
 	switch (source_id) {
-- 
1.9.1

