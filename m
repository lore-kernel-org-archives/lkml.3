Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaEDPmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:42:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbaEDPmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3.14 145/158] clk: s2mps11: Fix possible NULL pointer dereference
Date: Sun,  4 May 2014 11:40:54 -0400
Message-Id: <20140504154049.737859516@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 238e14055da87d0d012257788e39fe0df3a82226 upstream.

If parent device does not have of_node set the s2mps11_clk_parse_dt()
returned NULL. This NULL was later passed to of_clk_add_provider() which
dereferenced it in pr_debug() call.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk-s2mps11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -130,7 +130,7 @@ static struct device_node *s2mps11_clk_p
 	int i;
 
 	if (!iodev->dev->of_node)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	clk_np = of_find_node_by_name(iodev->dev->of_node, "clocks");
 	if (!clk_np) {


