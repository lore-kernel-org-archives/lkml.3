Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab3CSGmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:42:32 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:62798 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab3CSGm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:42:27 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org, patches@linaro.org,
        Patrice Chotard <patrice.chotard@stericsson.com>
Subject: [PATCH 2/5] pinctrl: ab8500: Staticize some symbols
Date: Tue, 19 Mar 2013 12:01:18 +0530
Message-Id: <1363674681-4015-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These symbols are used only in this file. Silences the following
warnings:
drivers/pinctrl/pinctrl-ab8500.c:392:28: warning:
symbol 'ab8500_alternate_functions' was not declared. Should it be static?
drivers/pinctrl/pinctrl-ab8500.c:458:32: warning:
symbol 'ab8500_gpio_irq_cluster' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Patrice Chotard <patrice.chotard@stericsson.com>
---
 drivers/pinctrl/pinctrl-ab8500.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ab8500.c b/drivers/pinctrl/pinctrl-ab8500.c
index 3b471d8..2ac2d0a 100644
--- a/drivers/pinctrl/pinctrl-ab8500.c
+++ b/drivers/pinctrl/pinctrl-ab8500.c
@@ -389,7 +389,8 @@ static const struct abx500_function ab8500_functions[] = {
  *	alt_A	|       1       |          0          |          0
  */
 
-struct alternate_functions ab8500_alternate_functions[AB8500_GPIO_MAX_NUMBER + 1] = {
+static struct
+alternate_functions ab8500_alternate_functions[AB8500_GPIO_MAX_NUMBER + 1] = {
 	ALTERNATE_FUNCTIONS(0, UNUSED, UNUSED, UNUSED, 0, 0, 0), /* no GPIO0 */
 	ALTERNATE_FUNCTIONS(1,	    0, UNUSED, UNUSED, 0, 0, 0), /* GPIO1, altA controlled by bit 0 */
 	ALTERNATE_FUNCTIONS(2,      1, UNUSED, UNUSED, 0, 0, 0), /* GPIO2, altA controlled by bit 1 */
@@ -455,7 +456,7 @@ struct alternate_functions ab8500_alternate_functions[AB8500_GPIO_MAX_NUMBER + 1
  *	GPIO24 and GPIO25
  *	GPIO36 to GPIO41
  */
-struct abx500_gpio_irq_cluster ab8500_gpio_irq_cluster[] = {
+static struct abx500_gpio_irq_cluster ab8500_gpio_irq_cluster[] = {
 	GPIO_IRQ_CLUSTER(6,  13, AB8500_INT_GPIO6R),
 	GPIO_IRQ_CLUSTER(24, 25, AB8500_INT_GPIO24R),
 	GPIO_IRQ_CLUSTER(36, 41, AB8500_INT_GPIO36R),
-- 
1.7.4.1

