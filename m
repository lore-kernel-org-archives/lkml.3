Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963Ab3CSGmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:42:38 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:45734 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933944Ab3CSGmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:42:36 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org, patches@linaro.org,
        Patrice Chotard <patrice.chotard@stericsson.com>
Subject: [PATCH 5/5] pinctrl: ab8505: Staticize some symbols
Date: Tue, 19 Mar 2013 12:01:21 +0530
Message-Id: <1363674681-4015-5-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences the following warnings:
drivers/pinctrl/pinctrl-ab8505.c:274:28: warning:
symbol 'ab8505_alternate_functions' was not declared. Should it be static?
drivers/pinctrl/pinctrl-ab8505.c:351:32: warning:
symbol 'ab8505_gpio_irq_cluster' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Patrice Chotard <patrice.chotard@stericsson.com>
---
 drivers/pinctrl/pinctrl-ab8505.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ab8505.c b/drivers/pinctrl/pinctrl-ab8505.c
index 3a4238e..2841db7 100644
--- a/drivers/pinctrl/pinctrl-ab8505.c
+++ b/drivers/pinctrl/pinctrl-ab8505.c
@@ -271,7 +271,8 @@ static const struct abx500_function ab8505_functions[] = {
  *	alt_A	|       1       |          0          |          0
  */
 
-struct alternate_functions ab8505_alternate_functions[AB8505_GPIO_MAX_NUMBER + 1] = {
+static struct
+alternate_functions ab8505_alternate_functions[AB8505_GPIO_MAX_NUMBER + 1] = {
 	ALTERNATE_FUNCTIONS(0, UNUSED, UNUSED, UNUSED, 0, 0, 0), /* no GPIO0 */
 	ALTERNATE_FUNCTIONS(1,      0, UNUSED, UNUSED, 0, 0, 0), /* GPIO1, altA controlled by bit 0 */
 	ALTERNATE_FUNCTIONS(2,      1, UNUSED, UNUSED, 0, 0, 0), /* GPIO2, altA controlled by bit 1 */
@@ -348,7 +349,7 @@ struct alternate_functions ab8505_alternate_functions[AB8505_GPIO_MAX_NUMBER + 1
  *	GPIO50
  *	GPIO52 to GPIO53
  */
-struct abx500_gpio_irq_cluster ab8505_gpio_irq_cluster[] = {
+static struct abx500_gpio_irq_cluster ab8505_gpio_irq_cluster[] = {
 	GPIO_IRQ_CLUSTER(10, 11, AB8500_INT_GPIO10R),
 	GPIO_IRQ_CLUSTER(13, 13, AB8500_INT_GPIO13R),
 	GPIO_IRQ_CLUSTER(40, 41, AB8500_INT_GPIO40R),
-- 
1.7.4.1

