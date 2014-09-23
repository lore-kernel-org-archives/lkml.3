Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbaIWSpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:45:05 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58931 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbaIWSo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:44:59 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, tomasz.figa@gmail.com,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v13 9/9] clk: Add docs about calling clk_put after clk_get_parent
Date: Tue, 23 Sep 2014 20:44:17 +0200
Message-Id: <1411497857-24726-7-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411497857-24726-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1411497613-24049-1-git-send-email-tomeu.vizoso@collabora.com>
 <1411497857-24726-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As otherwise the per-user clk will be leaked.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/clk.c   | 3 ++-
 include/linux/clk.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index c507548..2c7baea 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1828,7 +1828,8 @@ EXPORT_SYMBOL_GPL(clk_provider_get_parent);
  * clk_get_parent - return the parent of a clk
  * @clk_user: the clk whose parent gets returned
  *
- * Simply returns clk->parent.  Returns NULL if clk is NULL.
+ * Simply returns clk->parent.  Returns NULL if clk is NULL. Caller must call
+ * clk_put() to release the returned struct clk.
  */
 struct clk *clk_get_parent(struct clk *clk_user)
 {
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 066b100..4f54952 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -306,7 +306,8 @@ int clk_set_parent(struct clk *clk, struct clk *parent);
  * @clk: clock source
  *
  * Returns struct clk corresponding to parent clock source, or
- * valid IS_ERR() condition containing errno.
+ * valid IS_ERR() condition containing errno. Caller must call
+ * clk_put() to release the returned struct clk.
  */
 struct clk *clk_get_parent(struct clk *clk);
 
-- 
1.9.3

