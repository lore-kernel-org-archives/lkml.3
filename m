Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaKROXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:23:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbaKROKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:19 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Borislav Petkov <bp@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 179/206] cpc925_edac: Report UE events properly
Date: Tue, 18 Nov 2014 15:08:54 +0100
Message-Id: <de351259edc887ab6cc08b74e27ea748ad532f4f.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fa19ac4b92bc2b5024af3e868f41f81fa738567a upstream.

Fix UE event being reported as HW_EVENT_ERR_CORRECTED.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: http://lkml.kernel.org/r/8beb13803500076fef827eab33d523e355d83759.1413405053.git.jbaron@akamai.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/edac/cpc925_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index df6575f1430d..682288ced4ac 100644
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
2.1.3

