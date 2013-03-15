Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab3COEr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 00:47:58 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:32959 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3COEr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 00:47:57 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: plagnioj@jcrosoft.com, linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 1/2] pinctrl: at91: Remove duplicate const
Date: Fri, 15 Mar 2013 10:07:02 +0530
Message-Id: <1363322223-19850-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

const declared twice. Fixes the following sparse warning:
drivers/pinctrl/pinctrl-at91.c:815:21: warning: duplicate const
drivers/pinctrl/pinctrl-at91.c:849:21: warning: duplicate const

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-at91.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index e50fa5f..353c7bf 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -812,7 +812,7 @@ static int at91_pinctrl_mux_mask(struct at91_pinctrl *info,
 {
 	int ret = 0;
 	int size;
-	const const __be32 *list;
+	const __be32 *list;
 
 	list = of_get_property(np, "atmel,mux-mask", &size);
 	if (!list) {
@@ -846,7 +846,7 @@ static int at91_pinctrl_parse_groups(struct device_node *np,
 {
 	struct at91_pmx_pin *pin;
 	int size;
-	const const __be32 *list;
+	const __be32 *list;
 	int i, j;
 
 	dev_dbg(info->dev, "group(%d): %s\n", index, np->name);
-- 
1.7.4.1

