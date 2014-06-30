Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaF3Max (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:30:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbaF3Mat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jorge Daniel Sequeira Matias <jdsm@tecnico.ulisboa.pt>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 157/181] target: Explicitly clear ramdisk_mcp backend pages
Date: Mon, 30 Jun 2014 13:52:58 +0200
Message-Id: <675739cd78efd1d6e32199add0cdc64f8cb0ac96.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[Note that a different patch to address the same issue went in during
v3.15-rc1 (commit 4442dc8a), but includes a bunch of other changes that
don't strictly apply to fixing the bug]

This patch changes rd_allocate_sgl_table() to explicitly clear
ramdisk_mcp backend memory pages by passing __GFP_ZERO into
alloc_pages().

This addresses a potential security issue where reading from a
ramdisk_mcp could return sensitive information, and follows what
>= v3.15 does to explicitly clear ramdisk_mcp memory at backend
device initialization time.

Reported-by: Jorge Daniel Sequeira Matias <jdsm@tecnico.ulisboa.pt>
Cc: Jorge Daniel Sequeira Matias <jdsm@tecnico.ulisboa.pt>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_rd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 131327ac7f5b..9f6bedecda6e 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -179,7 +179,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 						- 1;
 
 		for (j = 0; j < sg_per_table; j++) {
-			pg = alloc_pages(GFP_KERNEL, 0);
+			pg = alloc_pages(GFP_KERNEL | __GFP_ZERO, 0);
 			if (!pg) {
 				pr_err("Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");
-- 
2.0.0

