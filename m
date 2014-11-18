Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbaKROWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:22:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbaKROKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:20 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Borislav Petkov <bp@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 178/206] e7xxx_edac: Report CE events properly
Date: Tue, 18 Nov 2014 15:08:53 +0100
Message-Id: <1b01c44de1695ec86b737d51bb365609e7c350ca.1416319692.git.jslaby@suse.cz>
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

commit 8030122a9ccf939186f8db96c318dbb99b5463f6 upstream.

Fix CE event being reported as HW_EVENT_ERR_UNCORRECTED.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: http://lkml.kernel.org/r/e6dd616f2cd51583a7e77af6f639b86313c74144.1413405053.git.jbaron@akamai.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/edac/e7xxx_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 1c4056a50383..2697deae3ab7 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -226,7 +226,7 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 static void process_ce_no_info(struct mem_ctl_info *mci)
 {
 	edac_dbg(3, "\n");
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0, -1, -1, -1,
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1, 0, 0, 0, -1, -1, -1,
 			     "e7xxx CE log register overflow", "");
 }
 
-- 
2.1.3

