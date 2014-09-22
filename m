Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaIVOMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:12:50 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45455 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbaIVOMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:12:47 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, tomasz.figa@gmail.com,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v12 01/10] clk: Export __clk_put and __clk_get so they can be used by modules
Date: Mon, 22 Sep 2014 16:12:03 +0200
Message-Id: <1411395124-2476-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411395124-2476-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1411395124-2476-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for the split between provider and user clk APIs, for clocks
that are implemented in modules.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index b76fa69..5db9710 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2197,6 +2197,7 @@ int __clk_get(struct clk *clk)
 	}
 	return 1;
 }
+EXPORT_SYMBOL(__clk_get);
 
 void __clk_put(struct clk *clk)
 {
@@ -2209,6 +2210,7 @@ void __clk_put(struct clk *clk)
 
 	module_put(clk->owner);
 }
+EXPORT_SYMBOL(__clk_put);
 
 /***        clk rate change notifiers        ***/
 
-- 
1.9.3

