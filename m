Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbaEMJpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:45:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60855 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760089AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 076/182] Target/sbc: Initialize COMPARE_AND_WRITE write_sg scatterlist
Date: Tue, 13 May 2014 11:27:08 +0200
Message-Id: <19ab8fec186d4f6219122e3d90ab59fa45292f1b.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Svec <martin.svec@zoner.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a1e1774c6dfa3a524dd8df51ca95185fe5ef3247 upstream.

When compiled with CONFIG_DEBUG_SG set, uninitialized SGL leads
to BUG() in compare_and_write_callback().

Signed-off-by: Martin Svec <martin.svec@zoner.cz>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_sbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index d9b92b2c524d..e84149895af2 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -409,13 +409,14 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd)
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
1.9.3

