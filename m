Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaEHO5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:57:12 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:56158 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbaEHO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:57:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] clk/versatile: export symbols for impd1
Date: Thu,  8 May 2014 16:56:16 +0200
Message-Id: <1399560990-1402858-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:d4/vdC7jw6VDUC4iZ/0RejajF7UCrSSEsyJlD6IeBl6
 AQYHW6r2buOhCZcn5OxGLwruRVK8nGbXiv+Z8SakktvFYHfedu
 vB7MW5QAG3t1dhRa9nPq0qOJ3IVp5rxvztksl7tDMSssC6kCfo
 ys4oT4BZ45lRQ29cMllz0olyFG3JU+Z73KLwib51VrDZGYi6t0
 EcFnjNDYIWIQYyfb6DxKwHAIiI4kzdECByMKgxiUlGCxaq9UpF
 Yo5ynHgMtj+l6Kc+lBqjX99ye9jZHyWANzksA4UF6k9bd90XTS
 SOSVQQ5SqrXaZp2crQNWUUTvMUwvt5i3vzxhqm6l++EstavamJ
 0F8TliqOmpCHUwzIYL0/OursII1FH5KrpcVIT83Ij
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The impd1 code on mach-integrator can be a loadable module,
so we have to export icst_clk_register, integrator_impd1_clk_init
and integrator_impd1_clk_exit.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/clk/versatile/clk-icst.c  | 1 +
 drivers/clk/versatile/clk-impd1.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/clk/versatile/clk-icst.c b/drivers/clk/versatile/clk-icst.c
index a820b0c..7f3868a 100644
--- a/drivers/clk/versatile/clk-icst.c
+++ b/drivers/clk/versatile/clk-icst.c
@@ -160,3 +160,4 @@ struct clk *icst_clk_register(struct device *dev,
 
 	return clk;
 }
+EXPORT_SYMBOL_GPL(icst_clk_register);
diff --git a/drivers/clk/versatile/clk-impd1.c b/drivers/clk/versatile/clk-impd1.c
index 31b44f0..264d8d5 100644
--- a/drivers/clk/versatile/clk-impd1.c
+++ b/drivers/clk/versatile/clk-impd1.c
@@ -133,6 +133,7 @@ void integrator_impd1_clk_init(void __iomem *base, unsigned int id)
 	for (i = 0; i < ARRAY_SIZE(imc->clks); i++)
 		clkdev_add(imc->clks[i]);
 }
+EXPORT_SYMBOL_GPL(integrator_impd1_clk_init);
 
 void integrator_impd1_clk_exit(unsigned int id)
 {
@@ -155,3 +156,4 @@ void integrator_impd1_clk_exit(unsigned int id)
 	kfree(imc->vco2name);
 	kfree(imc->vco1name);
 }
+EXPORT_SYMBOL_GPL(integrator_impd1_clk_exit);
-- 
1.8.3.2

