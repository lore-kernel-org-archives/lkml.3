Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaKKLKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:10:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57661 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbaKKLKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jason Baron <jbaron@akamai.com>, Borislav Petkov <bp@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 112/170] i3200_edac: Report CE events properly
Date: Tue, 11 Nov 2014 11:07:51 +0000
Message-Id: <1415704129-12709-113-git-send-email-luis.henriques@canonical.com>
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

commit 8a3f075d6c9b3612b4a5fb2af8db82b38b20caf0 upstream.

Fix CE event being reported as HW_EVENT_ERR_UNCORRECTED.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: http://lkml.kernel.org/r/d02465b4f30314b390c12c061502eda5e9d29c52.1413405053.git.jbaron@akamai.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/edac/i3200_edac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index 022a70273ada..aa98b136f5d0 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -242,11 +242,11 @@ static void i3200_process_error_info(struct mem_ctl_info *mci,
 					     -1, -1,
 					     "i3000 UE", "");
 		} else if (log & I3200_ECCERRLOG_CE) {
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 					     0, 0, eccerrlog_syndrome(log),
 					     eccerrlog_row(channel, log),
 					     -1, -1,
-					     "i3000 UE", "");
+					     "i3000 CE", "");
 		}
 	}
 }
-- 
2.1.0

