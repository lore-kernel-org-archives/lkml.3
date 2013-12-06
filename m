Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab3LFONY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:13:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43738 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161249Ab3LFNAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 047/272] gpio: msm: make msm_gpio.summary_irq signed for error handling
Date: Fri,  6 Dec 2013 12:55:36 +0000
Message-Id: <1386334761-25517-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit bfea603bc54c0a736d45bc60b188a8cdae9aaaa3 upstream.

There is a bug in msm_gpio_probe() where we do:

	msm_gpio.summary_irq = platform_get_irq(pdev, 0);
	if (msm_gpio.summary_irq < 0) {

The problem is that "msm_gpio.summary_irq" is unsigned so the error
handling doesn't work.  I've fixed it by making it signed.

Fixes: 43f68444bce7 ('gpio: msm: Add device tree and irqdomain support for gpio-msm-v2')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpio/gpio-msm-v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-msm-v2.c b/drivers/gpio/gpio-msm-v2.c
index c2fa770..6516499 100644
--- a/drivers/gpio/gpio-msm-v2.c
+++ b/drivers/gpio/gpio-msm-v2.c
@@ -102,7 +102,7 @@ struct msm_gpio_dev {
 	DECLARE_BITMAP(wake_irqs, MAX_NR_GPIO);
 	DECLARE_BITMAP(dual_edge_irqs, MAX_NR_GPIO);
 	struct irq_domain *domain;
-	unsigned int summary_irq;
+	int summary_irq;
 	void __iomem *msm_tlmm_base;
 };
 
-- 
1.8.3.2

