Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbaKROXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:23:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbaKROKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:19 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Borislav Petkov <bp@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 176/206] i82860_edac: Report CE events properly
Date: Tue, 18 Nov 2014 15:08:51 +0100
Message-Id: <fad5bfc99e55787c2b924350eeb1a20a2bb1b516.1416319692.git.jslaby@suse.cz>
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

commit ab0543de6ff0877474f57a5aafbb51a61e88676f upstream.

Fix CE event being reported as HW_EVENT_ERR_UNCORRECTED.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: http://lkml.kernel.org/r/7aee8e244a32ff86b399a8f966c4aae70296aae0.1413405053.git.jbaron@akamai.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/edac/i82860_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 3e3e431c8301..b93b0d006ebb 100644
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
2.1.3

