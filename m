Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab3IZMZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:25:29 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2735 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab3IZMZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:25:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Sep 2013 05:21:48 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] pinctrl: palmas: remove non-require function
Date: Thu, 26 Sep 2013 18:18:04 +0530
Message-ID: <1380199684-20126-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com>
References: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas pinmux and pin configuration support the single pin level
configuration in place of pin group.

Hence it is only require to pin_config_{set|get} and do not require
pin_config_group_{set|get}. As core framework already check for
require APIs availability, it is not require to implement as dummy
for non-require ops and so removing it.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/pinctrl/pinctrl-palmas.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-palmas.c b/drivers/pinctrl/pinctrl-palmas.c
index 30c4d35..6164381 100644
--- a/drivers/pinctrl/pinctrl-palmas.c
+++ b/drivers/pinctrl/pinctrl-palmas.c
@@ -962,26 +962,9 @@ static int palmas_pinconf_set(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
-static int palmas_pinconf_group_get(struct pinctrl_dev *pctldev,
-				unsigned group, unsigned long *config)
-{
-	dev_err(pctldev->dev, "palmas_pinconf_group_get op not supported\n");
-	return -ENOTSUPP;
-}
-
-static int palmas_pinconf_group_set(struct pinctrl_dev *pctldev,
-				unsigned group, unsigned long *configs,
-				unsigned num_configs)
-{
-	dev_err(pctldev->dev, "palmas_pinconf_group_set op not supported\n");
-	return -ENOTSUPP;
-}
-
 static const struct pinconf_ops palmas_pinconf_ops = {
 	.pin_config_get = palmas_pinconf_get,
 	.pin_config_set = palmas_pinconf_set,
-	.pin_config_group_get = palmas_pinconf_group_get,
-	.pin_config_group_set = palmas_pinconf_group_set,
 };
 
 static struct pinctrl_desc palmas_pinctrl_desc = {
-- 
1.7.1.1

