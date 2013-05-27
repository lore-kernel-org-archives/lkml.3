Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab3E0Nz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:55:59 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:35155 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932366Ab3E0Nz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:55:58 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH] pinctrl: pinconf: take the right mutex
Date: Mon, 27 May 2013 15:55:20 +0200
Message-ID: <1369662920-31339-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The pinconf_dgb_config_print() takes the per-pincontroller
mutex, when what it wants to take is actually the pin maps
mutex.

Reported-by: James Hogan <james.hogan@imgtec.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinconf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index c67c37e..694c3ac 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -610,7 +610,7 @@ static int pinconf_dbg_config_print(struct seq_file *s, void *d)
 	bool found = false;
 	unsigned long config;
 
-	mutex_lock(&pctldev->mutex);
+	mutex_lock(&pinctrl_maps_mutex);
 
 	/* Parse the pinctrl map and look for the elected pin/state */
 	for_each_maps(maps_node, i, map) {
@@ -659,7 +659,7 @@ static int pinconf_dbg_config_print(struct seq_file *s, void *d)
 		confops->pin_config_config_dbg_show(pctldev, s, config);
 
 exit:
-	mutex_unlock(&pctldev->mutex);
+	mutex_unlock(&pinctrl_maps_mutex);
 
 	return 0;
 }
-- 
1.7.11.3

