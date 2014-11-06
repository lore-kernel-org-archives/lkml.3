Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaKFWiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:38:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58474 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaKFWiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:38:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jason Baron <jbaron@akamai.com>, Borislav Petkov <bp@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 124/162] i82860_edac: Report CE events properly
Date: Thu,  6 Nov 2014 14:36:28 -0800
Message-Id: <1415313426-9622-125-git-send-email-kamal@canonical.com>
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

commit ab0543de6ff0877474f57a5aafbb51a61e88676f upstream.

Fix CE event being reported as HW_EVENT_ERR_UNCORRECTED.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: http://lkml.kernel.org/r/7aee8e244a32ff86b399a8f966c4aae70296aae0.1413405053.git.jbaron@akamai.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/edac/i82860_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 3e3e431..b93b0d0 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -124,7 +124,7 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 				     dimm->location[0], dimm->location[1], -1,
 				     "i82860 UE", "");
 	else
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     info->eap, 0, info->derrsyn,
 				     dimm->location[0], dimm->location[1], -1,
 				     "i82860 CE", "");
-- 
1.9.1

