Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3LBUS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:18:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3LBTRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.12 043/212] gpio: msm: make msm_gpio.summary_irq signed for error handling
Date: Mon,  2 Dec 2013 11:13:54 -0800
Message-Id: <20131202191253.158714828@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-msm-v2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 


