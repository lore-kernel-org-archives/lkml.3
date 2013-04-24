Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3DXOZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:25:49 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:43869 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754230Ab3DXOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:25:48 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Laurent Meunier <laurent.meunier@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/pinconfig: fix misplaced goto
Date: Wed, 24 Apr 2013 16:25:34 +0200
Message-ID: <1366813534-2460-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Meunier <laurent.meunier@st.com>

This update contains a basic fix that went unseen through
test and review.

Signed-off-by: Laurent Meunier <laurent.meunier@st.com>
Reviewed-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 3578667..c67c37e 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -771,8 +771,8 @@ static int pinconf_dbg_config_write(struct file *file,
 	}
 
 	if (!found) {
-		goto exit;
 		count = -EINVAL;
+		goto exit;
 	}
 
 	if (pctldev)
-- 
1.7.11.3

