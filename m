Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3A3L1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:27:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63758 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab3A3L1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:27:13 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Patrice Chotard <patrice.chotard@st.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: Remove newly introduced __dev* annotations
Date: Wed, 30 Jan 2013 12:27:09 +0100
Message-Id: <1359545229-14620-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:BgdmH7N6YXmMLo3Yvl7a9YehswQhEYUsUuiu7y/EjwW
 Sq56Ch+ooWz3L3z34BNbbAo1AFMfSBxf8F4bqe7RZ1PhJgfGNS
 qpqMG6HWnjkPHOcE/zc3lH5wyvmx8C/BDgmp1geU6gK45S4VY5
 1P8OF7Mxs34/G+6+DFwK5UoEG1wIWXz+gaj0CoETWntMncHynn
 OIQ0E524cd9odjB7HW72eWy8t5HRVbQsYioGmZ+spjdcAVL59R
 dmqYrwMV0Q9CziKAo1j4x+2FvLEbP182jH6hFyuhDycHHWlv/K
 UztcGr6frnN2S6Fb5Aupvv75kHXfFOhvQiYrc8Rio970z9YU5F
 ZgV/yzT3BRqtmt7RT78tw1rEEyMtsC5EBldhRmsgm9nErMa+1T
 TklYz01ruYpXnPQqh4kb7WXiFYF7D09L42bDC/pEb/qQ+VGwf9
 /Yko+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__devinit, __devexit and __devexit_p have been removed and should no
longer be used.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/pinctrl/pinctrl-ab8500.c | 2 +-
 drivers/pinctrl/pinctrl-abx500.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ab8500.c b/drivers/pinctrl/pinctrl-ab8500.c
index 6495390..bb931e7 100644
--- a/drivers/pinctrl/pinctrl-ab8500.c
+++ b/drivers/pinctrl/pinctrl-ab8500.c
@@ -478,7 +478,7 @@ static struct abx500_pinctrl_soc_data ab8500_soc = {
 	.irq_gpio_factor = 1,
 };
 
-void __devinit
+void
 abx500_pinctrl_ab8500_init(struct abx500_pinctrl_soc_data **soc)
 {
 	*soc = &ab8500_soc;
diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 13ae68f..214d659 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -1080,7 +1080,7 @@ static int abx500_get_gpio_num(struct abx500_pinctrl_soc_data *soc)
 	return npins;
 }
 
-static int __devinit abx500_gpio_probe(struct platform_device *pdev)
+static int abx500_gpio_probe(struct platform_device *pdev)
 {
 	struct ab8500_platform_data *abx500_pdata =
 				dev_get_platdata(pdev->dev.parent);
@@ -1189,7 +1189,7 @@ out_free:
  * abx500_gpio_remove() - remove Ab8500-gpio driver
  * @pdev :	Platform device registered
  */
-static int __devexit abx500_gpio_remove(struct platform_device *pdev)
+static int abx500_gpio_remove(struct platform_device *pdev)
 {
 	struct abx500_pinctrl *pct = platform_get_drvdata(pdev);
 	int ret;
@@ -1220,7 +1220,7 @@ static struct platform_driver abx500_gpio_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = abx500_gpio_probe,
-	.remove = __devexit_p(abx500_gpio_remove),
+	.remove = abx500_gpio_remove,
 	.id_table = abx500_pinctrl_id,
 };
 
-- 
1.8.1.2

