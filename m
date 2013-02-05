Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3BETv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:51:29 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:35387 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756280Ab3BETt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:49:26 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 09/14] pinctrl/abx500: use direct IRQ defines
Date: Tue, 5 Feb 2013 20:48:30 +0100
Message-ID: <1360093715-6348-10-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Make it harder to do mistakes by introducing the actual
defined ABx500 IRQ number into the IRQ cluster definitions.
Deduct cluster offset from the GPIO offset to make each
cluster coherent.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-ab8500.c |  6 +++---
 drivers/pinctrl/pinctrl-ab8505.c | 10 +++++-----
 drivers/pinctrl/pinctrl-ab8540.c |  6 +++---
 drivers/pinctrl/pinctrl-ab9540.c |  8 ++++----
 drivers/pinctrl/pinctrl-abx500.c |  3 +--
 5 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ab8500.c b/drivers/pinctrl/pinctrl-ab8500.c
index 42675ee..3b471d8 100644
--- a/drivers/pinctrl/pinctrl-ab8500.c
+++ b/drivers/pinctrl/pinctrl-ab8500.c
@@ -456,9 +456,9 @@ struct alternate_functions ab8500_alternate_functions[AB8500_GPIO_MAX_NUMBER + 1
  *	GPIO36 to GPIO41
  */
 struct abx500_gpio_irq_cluster ab8500_gpio_irq_cluster[] = {
-	GPIO_IRQ_CLUSTER(6,  13, 34),
-	GPIO_IRQ_CLUSTER(24, 25, 24),
-	GPIO_IRQ_CLUSTER(36, 41, 14),
+	GPIO_IRQ_CLUSTER(6,  13, AB8500_INT_GPIO6R),
+	GPIO_IRQ_CLUSTER(24, 25, AB8500_INT_GPIO24R),
+	GPIO_IRQ_CLUSTER(36, 41, AB8500_INT_GPIO36R),
 };
 
 static struct abx500_pinctrl_soc_data ab8500_soc = {
diff --git a/drivers/pinctrl/pinctrl-ab8505.c b/drivers/pinctrl/pinctrl-ab8505.c
index f8075c6..3a4238e 100644
--- a/drivers/pinctrl/pinctrl-ab8505.c
+++ b/drivers/pinctrl/pinctrl-ab8505.c
@@ -349,11 +349,11 @@ struct alternate_functions ab8505_alternate_functions[AB8505_GPIO_MAX_NUMBER + 1
  *	GPIO52 to GPIO53
  */
 struct abx500_gpio_irq_cluster ab8505_gpio_irq_cluster[] = {
-	GPIO_IRQ_CLUSTER(10, 11, 34),
-	GPIO_IRQ_CLUSTER(13, 13, 34),
-	GPIO_IRQ_CLUSTER(40, 41, 14),
-	GPIO_IRQ_CLUSTER(50, 50, 63),
-	GPIO_IRQ_CLUSTER(52, 53, 63),
+	GPIO_IRQ_CLUSTER(10, 11, AB8500_INT_GPIO10R),
+	GPIO_IRQ_CLUSTER(13, 13, AB8500_INT_GPIO13R),
+	GPIO_IRQ_CLUSTER(40, 41, AB8500_INT_GPIO40R),
+	GPIO_IRQ_CLUSTER(50, 50, AB9540_INT_GPIO50R),
+	GPIO_IRQ_CLUSTER(52, 53, AB9540_INT_GPIO52R),
 };
 
 static struct abx500_pinctrl_soc_data ab8505_soc = {
diff --git a/drivers/pinctrl/pinctrl-ab8540.c b/drivers/pinctrl/pinctrl-ab8540.c
index ac2e135..8ee1e8d 100644
--- a/drivers/pinctrl/pinctrl-ab8540.c
+++ b/drivers/pinctrl/pinctrl-ab8540.c
@@ -377,9 +377,9 @@ static struct pullud ab8540_pullud = {
  *	GPIO51 to GPIO54
  */
 struct abx500_gpio_irq_cluster ab8540_gpio_irq_cluster[] = {
-	GPIO_IRQ_CLUSTER(43, 43, 126),
-	GPIO_IRQ_CLUSTER(44, 44, 127),
-	GPIO_IRQ_CLUSTER(51, 54, 63),
+	GPIO_IRQ_CLUSTER(43, 43, AB8540_INT_GPIO43F),
+	GPIO_IRQ_CLUSTER(44, 44, AB8540_INT_GPIO44F),
+	GPIO_IRQ_CLUSTER(51, 54, AB9540_INT_GPIO51R),
 };
 
 static struct abx500_pinctrl_soc_data ab8540_soc = {
diff --git a/drivers/pinctrl/pinctrl-ab9540.c b/drivers/pinctrl/pinctrl-ab9540.c
index a169e5b..7610bd0 100644
--- a/drivers/pinctrl/pinctrl-ab9540.c
+++ b/drivers/pinctrl/pinctrl-ab9540.c
@@ -455,10 +455,10 @@ struct alternate_functions ab9540alternate_functions[AB9540_GPIO_MAX_NUMBER + 1]
 };
 
 struct abx500_gpio_irq_cluster ab9540_gpio_irq_cluster[] = {
-	GPIO_IRQ_CLUSTER(10, 13, 34),
-	GPIO_IRQ_CLUSTER(24, 25, 24),
-	GPIO_IRQ_CLUSTER(40, 41, 14),
-	GPIO_IRQ_CLUSTER(50, 54, 63),
+	GPIO_IRQ_CLUSTER(10, 13, AB8500_INT_GPIO10R),
+	GPIO_IRQ_CLUSTER(24, 25, AB8500_INT_GPIO24R),
+	GPIO_IRQ_CLUSTER(40, 41, AB8500_INT_GPIO40R),
+	GPIO_IRQ_CLUSTER(50, 54, AB9540_INT_GPIO50R),
 };
 
 static struct abx500_pinctrl_soc_data ab9540_soc = {
diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index ded8f21..a0d324b 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -273,8 +273,7 @@ static int abx500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 			 * To solve this quandry, we have placed the read-in values
 			 * into the cluster information table.
 			 */
-			hwirq = gpio + cluster->to_irq;
-
+			hwirq = gpio - cluster->start + cluster->to_irq;
 			return irq_create_mapping(pct->parent->domain, hwirq);
 		}
 	}
-- 
1.7.11.3

