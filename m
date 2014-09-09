Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbaIIOHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:07:30 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35223 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359AbaIIOH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:07:27 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, tomasz.figa@gmail.com,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v10 7/9] clk: Take the prepare lock when updating the list of per-user clks
Date: Tue,  9 Sep 2014 16:06:50 +0200
Message-Id: <1410271612-27389-5-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410271612-27389-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1410271329-26637-1-git-send-email-tomeu.vizoso@collabora.com>
 <1410271612-27389-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 3018f37..f283dcc 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -560,7 +560,9 @@ struct clk *__clk_create_clk(struct clk_core *clk_core, const char *dev,
 	clk->dev_id = dev;
 	clk->con_id = con;
 
+	clk_prepare_lock();
 	hlist_add_head(&clk->child_node, &clk_core->per_user_clks);
+	clk_prepare_unlock();
 
 	return clk;
 }
-- 
1.9.3

