Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3CSGsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:48:40 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:38313 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3CSGsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:48:39 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org, patches@linaro.org,
        Patrice Chotard <patrice.chotard@stericsson.com>
Subject: [PATCH 4/5] pinctrl: ab8540: Staticize some symbols
Date: Tue, 19 Mar 2013 12:01:20 +0530
Message-Id: <1363674681-4015-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
References: <1363674681-4015-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences the following warnings:
drivers/pinctrl/pinctrl-ab8540.c:302:28: warning:
symbol 'ab8540_alternate_functions' was not declared. Should it be static?
drivers/pinctrl/pinctrl-ab8540.c:379:32: warning:
symbol 'ab8540_gpio_irq_cluster' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Patrice Chotard <patrice.chotard@stericsson.com>
---
 drivers/pinctrl/pinctrl-ab8540.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ab8540.c b/drivers/pinctrl/pinctrl-ab8540.c
index 8ee1e8d..9867535 100644
--- a/drivers/pinctrl/pinctrl-ab8540.c
+++ b/drivers/pinctrl/pinctrl-ab8540.c
@@ -299,7 +299,8 @@ static const struct abx500_function ab8540_functions[] = {
  *
  */
 
-struct alternate_functions ab8540_alternate_functions[AB8540_GPIO_MAX_NUMBER + 1] = {
+static struct
+alternate_functions ab8540_alternate_functions[AB8540_GPIO_MAX_NUMBER + 1] = {
 	/* GPIOSEL1 - bit 4-7 reserved */
 	ALTERNATE_FUNCTIONS(0, UNUSED, UNUSED, UNUSED, 0, 0, 0), /* no GPIO0 */
 	ALTERNATE_FUNCTIONS(1,	    0, UNUSED, UNUSED, 0, 0, 0), /* GPIO1, altA controlled by bit 0 */
@@ -376,7 +377,7 @@ static struct pullud ab8540_pullud = {
  *	GPIO43 to GPIO44
  *	GPIO51 to GPIO54
  */
-struct abx500_gpio_irq_cluster ab8540_gpio_irq_cluster[] = {
+static struct abx500_gpio_irq_cluster ab8540_gpio_irq_cluster[] = {
 	GPIO_IRQ_CLUSTER(43, 43, AB8540_INT_GPIO43F),
 	GPIO_IRQ_CLUSTER(44, 44, AB8540_INT_GPIO44F),
 	GPIO_IRQ_CLUSTER(51, 54, AB9540_INT_GPIO51R),
-- 
1.7.4.1

