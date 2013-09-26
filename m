Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab3IZMZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:25:30 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13939 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab3IZMZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:25:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 26 Sep 2013 05:25:27 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] pinctrl: palmas: do not abort pin configuration for BIAS_DEFAULT
Date: Thu, 26 Sep 2013 18:18:03 +0530
Message-ID: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent movement of all configurations of pin in the single call of
pin_config_set(), it is aborting configuration if BIAS_PULL_PIN_DEFAULT
is selected as return of configuration.

The original idea was to just avoid any update on register for pull up/down
configuration if this option is selected.

Fixing this by just bypassing any register update for BIAS_PULL_PIN_DEFAULT
and continuing the remaining configuration.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/pinctrl/pinctrl-palmas.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-palmas.c b/drivers/pinctrl/pinctrl-palmas.c
index 82638fa..30c4d35 100644
--- a/drivers/pinctrl/pinctrl-palmas.c
+++ b/drivers/pinctrl/pinctrl-palmas.c
@@ -891,9 +891,10 @@ static int palmas_pinconf_set(struct pinctrl_dev *pctldev,
 		param = pinconf_to_config_param(configs[i]);
 		param_val = pinconf_to_config_argument(configs[i]);
 
+		if (param == PIN_CONFIG_BIAS_PULL_PIN_DEFAULT)
+			continue;
+
 		switch (param) {
-		case PIN_CONFIG_BIAS_PULL_PIN_DEFAULT:
-			return 0;
 		case PIN_CONFIG_BIAS_DISABLE:
 		case PIN_CONFIG_BIAS_PULL_UP:
 		case PIN_CONFIG_BIAS_PULL_DOWN:
-- 
1.7.1.1

