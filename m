Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaEBPph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:45:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaEBPpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:45:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 088/151] clk: s2mps11: Fix possible NULL pointer dereference
Date: Fri,  2 May 2014 08:37:56 -0700
Message-Id: <1399045139-4531-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 238e14055da87d0d012257788e39fe0df3a82226 upstream.

If parent device does not have of_node set the s2mps11_clk_parse_dt()
returned NULL. This NULL was later passed to of_clk_add_provider() which
dereferenced it in pr_debug() call.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/clk/clk-s2mps11.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 00a3abe..27c83e4 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -130,7 +130,7 @@ static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
 	int i;
 
 	if (!iodev->dev->of_node)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	clk_np = of_find_node_by_name(iodev->dev->of_node, "clocks");
 	if (!clk_np) {
-- 
1.9.1

