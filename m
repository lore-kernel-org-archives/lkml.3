Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3BETwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:52:09 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:58912 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756633Ab3BETtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:49:20 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 06/14] pinctrl/abx500: align GPIO cluster boundaries
Date: Tue, 5 Feb 2013 20:48:27 +0100
Message-ID: <1360093715-6348-7-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

Not quite sure how this ever worked. In ab8500_gpio_to_irq() the
GPIO for conversion is passed through as the second argument. If
GPIO13, which is a valid GPIO for IRQ functionality, was received;
it would be rejected by the following guard:

    GPIO_IRQ_CLUSTER(5, 12, 0); /* GPIO numbers start from 1 */

    if (offset >= cluster->start && offset <= cluster->end)
        /* Valid GPIO for IRQ use */

Signed-off-by: Lee Jones <lee.jones@linaro.org>
[Augmented to account for off-by-one problem]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-ab8500.c |  6 +++---
 drivers/pinctrl/pinctrl-ab8505.c | 10 +++++-----
 drivers/pinctrl/pinctrl-ab8540.c |  4 ++--
 drivers/pinctrl/pinctrl-ab9540.c |  8 ++++----
 drivers/pinctrl/pinctrl-abx500.c |  6 ++++--
 5 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ab8500.c b/drivers/pinctrl/pinctrl-ab8500.c
index 2cd424e..67dc942 100644
--- a/drivers/pinctrl/pinctrl-ab8500.c
+++ b/drivers/pinctrl/pinctrl-ab8500.c
@@ -456,9 +456,9 @@ struct alternate_functions ab8500_alternate_functions[AB8500_GPIO_MAX_NUMBER + 1
  *	GPIO36 to GPIO41
  */
 struct abx500_gpio_irq_cluster ab8500_gpio_irq_cluster[] = {
-	GPIO_IRQ_CLUSTER(5, 12, 0), /* GPIO numbers start from 1 */
-	GPIO_IRQ_CLUSTER(23, 24, 0),
-	GPIO_IRQ_CLUSTER(35, 40, 0),
+	GPIO_IRQ_CLUSTER(6, 13, 0),
+	GPIO_IRQ_CLUSTER(24, 25, 0),
+	GPIO_IRQ_CLUSTER(36, 41, 0),
 };
 
 static struct abx500_pinctrl_soc_data ab8500_soc = {
diff --git a/drivers/pinctrl/pinctrl-ab8505.c b/drivers/pinctrl/pinctrl-ab8505.c
index 40dc3e1..825710a 100644
--- a/drivers/pinctrl/pinctrl-ab8505.c
+++ b/drivers/pinctrl/pinctrl-ab8505.c
@@ -349,11 +349,11 @@ struct alternate_functions ab8505_alternate_functions[AB8505_GPIO_MAX_NUMBER + 1
  *	GPIO52 to GPIO53
  */
 struct abx500_gpio_irq_cluster ab8505_gpio_irq_cluster[] = {
-	GPIO_IRQ_CLUSTER(9, 10, 0), /* GPIO numbers start from 1 */
-	GPIO_IRQ_CLUSTER(12, 12, 0),
-	GPIO_IRQ_CLUSTER(39, 40, 0),
-	GPIO_IRQ_CLUSTER(49, 49, 0),
-	GPIO_IRQ_CLUSTER(51, 52, 0),
+	GPIO_IRQ_CLUSTER(10, 11, 0),
+	GPIO_IRQ_CLUSTER(13, 13, 0),
+	GPIO_IRQ_CLUSTER(40, 41, 0),
+	GPIO_IRQ_CLUSTER(50, 50, 0),
+	GPIO_IRQ_CLUSTER(52, 53, 0),
 };
 
 static struct abx500_pinctrl_soc_data ab8505_soc = {
diff --git a/drivers/pinctrl/pinctrl-ab8540.c b/drivers/pinctrl/pinctrl-ab8540.c
index e75310d..0fcd943 100644
--- a/drivers/pinctrl/pinctrl-ab8540.c
+++ b/drivers/pinctrl/pinctrl-ab8540.c
@@ -377,8 +377,8 @@ static struct pullud ab8540_pullud = {
  *	GPIO51 to GPIO54
  */
 struct abx500_gpio_irq_cluster ab8540_gpio_irq_cluster[] = {
-	GPIO_IRQ_CLUSTER(42, 43, 2), /* GPIO numbers start from 1 */
-	GPIO_IRQ_CLUSTER(50, 53, 0),
+	GPIO_IRQ_CLUSTER(43, 44, 2),
+	GPIO_IRQ_CLUSTER(51, 54, 0),
 };
 
 static struct abx500_pinctrl_soc_data ab8540_soc = {
diff --git a/drivers/pinctrl/pinctrl-ab9540.c b/drivers/pinctrl/pinctrl-ab9540.c
index 31fec3e..28dfb2e 100644
--- a/drivers/pinctrl/pinctrl-ab9540.c
+++ b/drivers/pinctrl/pinctrl-ab9540.c
@@ -455,10 +455,10 @@ struct alternate_functions ab9540alternate_functions[AB9540_GPIO_MAX_NUMBER + 1]
 };
 
 struct abx500_gpio_irq_cluster ab9540_gpio_irq_cluster[] = {
-	GPIO_IRQ_CLUSTER(9, 12, 0), /* GPIO numbers start from 1 */
-	GPIO_IRQ_CLUSTER(23, 24, 0),
-	GPIO_IRQ_CLUSTER(39, 40, 0),
-	GPIO_IRQ_CLUSTER(49, 53, 0),
+	GPIO_IRQ_CLUSTER(10, 13, 0),
+	GPIO_IRQ_CLUSTER(24, 25, 0),
+	GPIO_IRQ_CLUSTER(40, 41, 0),
+	GPIO_IRQ_CLUSTER(50, 54, 0),
 };
 
 static struct abx500_pinctrl_soc_data ab9540_soc = {
diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 9bdfcb9..a9e720f 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -272,6 +272,8 @@ static int abx500_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 static int abx500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
 	struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
+	/* The AB8500 GPIO numbers are off by one */
+	int gpio = offset + 1;
 	int base = pct->irq_base;
 	int i;
 
@@ -279,8 +281,8 @@ static int abx500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 		struct abx500_gpio_irq_cluster *cluster =
 			&pct->irq_cluster[i];
 
-		if (offset >= cluster->start && offset <= cluster->end)
-			return base + offset - cluster->start;
+		if (gpio >= cluster->start && gpio <= cluster->end)
+			return base + gpio - cluster->start;
 
 		/* Advance by the number of gpios in this cluster */
 		base += cluster->end + cluster->offset - cluster->start + 1;
-- 
1.7.11.3

