Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162943Ab3LFXzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:55:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48356 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759044Ab3LFXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:33 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roel Kluin <roel.kluin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 012/152] pinctrl: dove: unset twsi option3 for gconfig as well
Date: Fri,  6 Dec 2013 15:08:56 -0800
Message-Id: <1386371476-2477-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit 6d0a4ed2b90a12e1403d3e7d9d8c2cc7fdc301b5 upstream.

This fixes a typo which left twsi config3 option enabled.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 428ea96..e29e6d8 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -323,7 +323,7 @@ static int dove_twsi_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
 
 	gcfg1 &= ~DOVE_TWSI_ENABLE_OPTION1;
-	gcfg2 &= ~(DOVE_TWSI_ENABLE_OPTION2 | DOVE_TWSI_ENABLE_OPTION2);
+	gcfg2 &= ~(DOVE_TWSI_ENABLE_OPTION2 | DOVE_TWSI_ENABLE_OPTION3);
 
 	switch (config) {
 	case 1:
-- 
1.8.3.2

