Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaABRJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:09:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40471 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaABRJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:09:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 42/91] gpio: mvebu: make mvchip->irqbase signed for error handling
Date: Thu,  2 Jan 2014 09:04:17 -0800
Message-Id: <1388682306-30859-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d535922691fc026479fcc03e78ac3d931a54e75a upstream.

There is a bug in mvebu_gpio_probe() where we do:

	mvchip->irqbase = irq_alloc_descs(-1, 0, ngpios, -1);
	if (mvchip->irqbase < 0) {

The problem is that mvchip->irqbase is unsigned so the error handling
doesn't work.  I have changed it to be a regular int.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpio/gpio-mvebu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 456663c..6300159 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -78,7 +78,7 @@ struct mvebu_gpio_chip {
 	spinlock_t	   lock;
 	void __iomem	  *membase;
 	void __iomem	  *percpu_membase;
-	unsigned int       irqbase;
+	int		   irqbase;
 	struct irq_domain *domain;
 	int                soc_variant;
 };
-- 
1.8.3.2

