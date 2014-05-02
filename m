Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaEBPlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:41:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbaEBPjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 138/151] Target/sbc: Initialize COMPARE_AND_WRITE write_sg scatterlist
Date: Fri,  2 May 2014 08:38:46 -0700
Message-Id: <1399045139-4531-139-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Svec <martin.svec@zoner.cz>

commit a1e1774c6dfa3a524dd8df51ca95185fe5ef3247 upstream.

When compiled with CONFIG_DEBUG_SG set, uninitialized SGL leads
to BUG() in compare_and_write_callback().

Signed-off-by: Martin Svec <martin.svec@zoner.cz>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/target_core_sbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 52ae54e..baa8bf4 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -419,13 +419,14 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd)
 		goto out;
 	}
 
-	write_sg = kzalloc(sizeof(struct scatterlist) * cmd->t_data_nents,
+	write_sg = kmalloc(sizeof(struct scatterlist) * cmd->t_data_nents,
 			   GFP_KERNEL);
 	if (!write_sg) {
 		pr_err("Unable to allocate compare_and_write sg\n");
 		ret = TCM_OUT_OF_RESOURCES;
 		goto out;
 	}
+	sg_init_table(write_sg, cmd->t_data_nents);
 	/*
 	 * Setup verify and write data payloads from total NumberLBAs.
 	 */
-- 
1.9.1

