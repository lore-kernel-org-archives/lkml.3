Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaFIJFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:05:10 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58527 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201AbaFIIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pawel Moll <pawel.moll@arm.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 087/146] clk: vexpress: NULL dereference on error path
Date: Mon,  9 Jun 2014 10:50:22 +0200
Message-Id: <2cd99e6b78cfb93971ccbe7b1d2b11ff1a311eed.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6b4ed8b00e93bd31f24a25f59ed8d1b808d0cc00 upstream.

If the allocation fails then we dereference the NULL in the error path.
Just return directly.

Fixes: ed27ff1db869 ('clk: Versatile Express clock generators ("osc") driver')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/clk/versatile/clk-vexpress-osc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/versatile/clk-vexpress-osc.c b/drivers/clk/versatile/clk-vexpress-osc.c
index 2dc8b41a339d..a535c7bf8574 100644
--- a/drivers/clk/versatile/clk-vexpress-osc.c
+++ b/drivers/clk/versatile/clk-vexpress-osc.c
@@ -102,7 +102,7 @@ void __init vexpress_osc_of_setup(struct device_node *node)
 
 	osc = kzalloc(sizeof(*osc), GFP_KERNEL);
 	if (!osc)
-		goto error;
+		return;
 
 	osc->func = vexpress_config_func_get_by_node(node);
 	if (!osc->func) {
-- 
1.9.3

