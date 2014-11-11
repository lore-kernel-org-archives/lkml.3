Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaKKLeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:34:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57674 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbaKKLKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jason Baron <jbaron@akamai.com>, Borislav Petkov <bp@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 115/170] e7xxx_edac: Report CE events properly
Date: Tue, 11 Nov 2014 11:07:54 +0000
Message-Id: <1415704129-12709-116-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Baron <jbaron@akamai.com>

commit 8030122a9ccf939186f8db96c318dbb99b5463f6 upstream.

Fix CE event being reported as HW_EVENT_ERR_UNCORRECTED.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: http://lkml.kernel.org/r/e6dd616f2cd51583a7e77af6f639b86313c74144.1413405053.git.jbaron@akamai.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/edac/e7xxx_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 3cda79bc8b00..ece3aef16bb1 100644
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
2.1.0

