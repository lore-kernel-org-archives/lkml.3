Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaDLR6K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 13:58:10 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.94]:42535 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaDLR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 13:58:08 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: len.brown@intel.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] intel_idle: fix IVT idle state table setting
Date: Sat, 12 Apr 2014 19:57:30 +0200
Message-Id: <1397325450-28919-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.9.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivy Town idle state table will not be set as intended. Fix it.

Picked up by Coverity - CID 1201420/1201421.

Fixes: 0138d8f075 ("intel_idle: fine-tune IVT residency targets")
Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 drivers/idle/intel_idle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index a43220c..4d140bb 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -750,9 +750,10 @@ void intel_idle_state_table_update(void)
 			if (package_num + 1 > num_sockets) {
 				num_sockets = package_num + 1;
 
-				if (num_sockets > 4)
+				if (num_sockets > 4) {
 					cpuidle_state_table = ivt_cstates_8s;
 					return;
+				}
 			}
 		}
 
-- 
1.9.0

