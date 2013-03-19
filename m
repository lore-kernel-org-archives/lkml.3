Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab3CSGnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:43:20 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:38898 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab3CSGma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:42:30 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org, patches@linaro.org,
        Patrice Chotard <patrice.chotard@stericsson.com>
Subject: [PATCH 3/5] pinctrl: ab9540: Staticize some symbols
Date: Tue, 19 Mar 2013 12:01:19 +0530
Message-Id: <1363674681-4015-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following warnings:
drivers/pinctrl/pinctrl-ab9540.c:382:28: warning:
symbol 'ab9540alternate_functions' was not declared. Should it be static?
drivers/pinctrl/pinctrl-ab9540.c:457:32: warning:
symbol 'ab9540_gpio_irq_cluster' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Patrice Chotard <patrice.chotard@stericsson.com>
---
 drivers/pinctrl/pinctrl-ab9540.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ab9540.c b/drivers/pinctrl/pinctrl-ab9540.c
index 7610bd0..27835ce 100644
--- a/drivers/pinctrl/pinctrl-ab9540.c
+++ b/drivers/pinctrl/pinctrl-ab9540.c
@@ -379,7 +379,8 @@ static const struct abx500_function ab9540_functions[] = {
  *	alt_A	|       1       |          0          |          0
  */
 
-struct alternate_functions ab9540alternate_functions[AB9540_GPIO_MAX_NUMBER + 1] = {
+static struct
+alternate_functions ab9540alternate_functions[AB9540_GPIO_MAX_NUMBER + 1] = {
 	/* GPIOSEL1 - bits 4-7 are reserved */
 	ALTERNATE_FUNCTIONS(0, UNUSED, UNUSED, UNUSED, 0, 0, 0), /* no GPIO0 */
 	ALTERNATE_FUNCTIONS(1,	    0, UNUSED, UNUSED, 0, 0, 0), /* GPIO1, altA controlled by bit 0 */
@@ -454,7 +455,7 @@ struct alternate_functions ab9540alternate_functions[AB9540_GPIO_MAX_NUMBER + 1]
 	ALTERNATE_FUNCTIONS(54,	     5, UNUSED, UNUSED, 0, 0, 0), /* GPIO54 = GPIO60, altA controlled by bit 5 */
 };
 
-struct abx500_gpio_irq_cluster ab9540_gpio_irq_cluster[] = {
+static struct abx500_gpio_irq_cluster ab9540_gpio_irq_cluster[] = {
 	GPIO_IRQ_CLUSTER(10, 13, AB8500_INT_GPIO10R),
 	GPIO_IRQ_CLUSTER(24, 25, AB8500_INT_GPIO24R),
 	GPIO_IRQ_CLUSTER(40, 41, AB8500_INT_GPIO40R),
-- 
1.7.4.1

