Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab3AURS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:18:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56991 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab3AURRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:17:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <s.hauer@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 06/15] clk: export __clk_get_name
Date: Mon, 21 Jan 2013 17:15:59 +0000
Message-Id: <1358788568-11137-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:nPuXb1qozlm61jfxlHWBhUVdvNgge9C/7CIayRxxisU
 r5Mjc4WEHbVrTn0pjESmG109yyWxNtNZt4Z9sKrjogpXGppCL2
 NzLFxvhSg7jZiaYAFnbBXK7BdXJi/rUsRCmBqYZl3s+4FQ1IyW
 auooAc+GjujNAK47duMXaKz3qKeYqET9LLKQj1JPgVfXPOKcuj
 C5W0bm2QZ+4dijI2uEC0V21un9kOrGD7UBwmuMCZwpfDx5J6SF
 8qghv986eQa5YxgxUUVuqYAbQLhXl5IFZU23Q8DC31IsVyp2tb
 lUEyZEFigxnpyf+N/0Rw5EpQl7FKJDP+/exIftVaybhDg11C8U
 xQEr1HWR6WdDzBXgeAtCy1unUCxCcq7VnW7WauJ0V
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __clk_get_name is used by drivers that provide their
own clocks, which have traditionally all been built-in.
The new imx drm driver however provides clocks but can
be built as a module, so we need to export __clk_get_name.

While this is only a staging driver, it's likely that
there will be others like it in the future.

Without this patch, building ARM allmodconfig results in:

ERROR: "__clk_get_name" [drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/clk.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 251e45d..13b793e 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -263,6 +263,7 @@ inline const char *__clk_get_name(struct clk *clk)
 {
 	return !clk ? NULL : clk->name;
 }
+EXPORT_SYMBOL_GPL(__clk_get_name);
 
 inline struct clk_hw *__clk_get_hw(struct clk *clk)
 {
-- 
1.7.10.4

