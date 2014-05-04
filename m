Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaEDPlw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaEDPls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 093/158] Target/sbc: Initialize COMPARE_AND_WRITE write_sg scatterlist
Date: Sun,  4 May 2014 11:40:02 -0400
Message-Id: <20140504154042.577278992@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Svec <martin.svec@zoner.cz>

commit a1e1774c6dfa3a524dd8df51ca95185fe5ef3247 upstream.

When compiled with CONFIG_DEBUG_SG set, uninitialized SGL leads
to BUG() in compare_and_write_callback().

Signed-off-by: Martin Svec <martin.svec@zoner.cz>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_sbc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -425,13 +425,14 @@ static sense_reason_t compare_and_write_
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


