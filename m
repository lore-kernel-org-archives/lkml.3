Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab3CSGm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:42:26 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51842 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3CSGmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:42:24 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org, patches@linaro.org,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH 1/5] pinctrl: abx500: Staticize some symbols
Date: Tue, 19 Mar 2013 12:01:17 +0530
Message-Id: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These symbols are used only in this file. Without this patch
we get the following warnings:
drivers/pinctrl/pinctrl-abx500.c:520:5: warning:
symbol 'abx500_gpio_request' was not declared. Should it be static?
drivers/pinctrl/pinctrl-abx500.c:527:6: warning:
symbol 'abx500_gpio_free' was not declared. Should it be static?
drivers/pinctrl/pinctrl-abx500.c:614:5: warning:
symbol 'abx500_gpio_request_enable' was not declared. Should it be static?
drivers/pinctrl/pinctrl-abx500.c:714:5: warning:
symbol 'abx500_pin_config_get' was not declared. Should it be static?
drivers/pinctrl/pinctrl-abx500.c:721:5: warning:
symbol 'abx500_pin_config_set' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Patrice Chotard <patrice.chotard@st.com>
---
This series is compile tested against linux-next tree (20130319).
---
 drivers/pinctrl/pinctrl-abx500.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 0cf3fa4..9b8db91 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -517,14 +517,14 @@ static inline void abx500_gpio_dbg_show_one(struct seq_file *s,
 #define abx500_gpio_dbg_show	NULL
 #endif
 
-int abx500_gpio_request(struct gpio_chip *chip, unsigned offset)
+static int abx500_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
 	int gpio = chip->base + offset;
 
 	return pinctrl_request_gpio(gpio);
 }
 
-void abx500_gpio_free(struct gpio_chip *chip, unsigned offset)
+static void abx500_gpio_free(struct gpio_chip *chip, unsigned offset)
 {
 	int gpio = chip->base + offset;
 
@@ -611,7 +611,7 @@ static void abx500_pmx_disable(struct pinctrl_dev *pctldev,
 	dev_dbg(pct->dev, "disable group %s, %u pins\n", g->name, g->npins);
 }
 
-int abx500_gpio_request_enable(struct pinctrl_dev *pctldev,
+static int abx500_gpio_request_enable(struct pinctrl_dev *pctldev,
 			       struct pinctrl_gpio_range *range,
 			       unsigned offset)
 {
@@ -711,14 +711,14 @@ static const struct pinctrl_ops abx500_pinctrl_ops = {
 	.pin_dbg_show = abx500_pin_dbg_show,
 };
 
-int abx500_pin_config_get(struct pinctrl_dev *pctldev,
+static int abx500_pin_config_get(struct pinctrl_dev *pctldev,
 			  unsigned pin,
 			  unsigned long *config)
 {
 	return -ENOSYS;
 }
 
-int abx500_pin_config_set(struct pinctrl_dev *pctldev,
+static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 			  unsigned pin,
 			  unsigned long config)
 {
-- 
1.7.4.1

