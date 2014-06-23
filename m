Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaFWNVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:21:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36967 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbaFWNEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Pawel Moll <pawel.moll@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 46/93] clk: vexpress: NULL dereference on error path
Date: Mon, 23 Jun 2014 14:02:25 +0100
Message-Id: <1403528592-2163-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 6b4ed8b00e93bd31f24a25f59ed8d1b808d0cc00 upstream.

If the allocation fails then we dereference the NULL in the error path.
Just return directly.

Fixes: ed27ff1db869 ('clk: Versatile Express clock generators ("osc") driver')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

