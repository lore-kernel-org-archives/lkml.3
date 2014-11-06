Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaKFXSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:18:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58556 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaKFWjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:39:08 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jason Baron <jbaron@akamai.com>, Borislav Petkov <bp@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 125/162] cpc925_edac: Report UE events properly
Date: Thu,  6 Nov 2014 14:36:29 -0800
Message-Id: <1415313426-9622-126-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Baron <jbaron@akamai.com>

commit fa19ac4b92bc2b5024af3e868f41f81fa738567a upstream.

Fix UE event being reported as HW_EVENT_ERR_CORRECTED.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: http://lkml.kernel.org/r/8beb13803500076fef827eab33d523e355d83759.1413405053.git.jbaron@akamai.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/edac/cpc925_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index df6575f..682288c 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -562,7 +562,7 @@ static void cpc925_mc_check(struct mem_ctl_info *mci)
 
 	if (apiexcp & UECC_EXCP_DETECTED) {
 		cpc925_mc_printk(mci, KERN_INFO, "DRAM UECC Fault\n");
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     pfn, offset, 0,
 				     csrow, -1, -1,
 				     mci->ctl_name, "");
-- 
1.9.1

