Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbbAPSW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:22:26 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41622 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbAPSWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:22:24 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH] drm/msm/mdp5: Fix negative SMP block allocation
Date: Fri, 16 Jan 2015 13:22:14 -0500
Message-Id: <1421432534-27808-1-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case we request a number of SMP blocks which is lower than
the already reserved blocks, we should not try to allocate a
negative number, but 0 blocks instead.

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c
index bf55188..1f795af89 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c
@@ -119,9 +119,10 @@ static int smp_request_block(struct mdp5_smp *smp,
 
 	spin_lock_irqsave(&smp->state_lock, flags);
 
-	nblks -= reserved;
-	if (reserved)
+	if (reserved) {
+		nblks = max(0, nblks - reserved);
 		DBG("%d MMBs allocated (%d reserved)", nblks, reserved);
+	}
 
 	avail = cnt - bitmap_weight(smp->state, cnt);
 	if (nblks > avail) {
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

