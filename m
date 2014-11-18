Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaKROXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:23:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbaKROKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:19 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Borislav Petkov <bp@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 177/206] i3200_edac: Report CE events properly
Date: Tue, 18 Nov 2014 15:08:52 +0100
Message-Id: <d13055e4024ecb76a8b3cfd29cf1b2272bac7fec.1416319692.git.jslaby@suse.cz>
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

commit 8a3f075d6c9b3612b4a5fb2af8db82b38b20caf0 upstream.

Fix CE event being reported as HW_EVENT_ERR_UNCORRECTED.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: http://lkml.kernel.org/r/d02465b4f30314b390c12c061502eda5e9d29c52.1413405053.git.jbaron@akamai.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/edac/i3200_edac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index be10a74b16ea..7d5b3697f4b5 100644
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
2.1.3

