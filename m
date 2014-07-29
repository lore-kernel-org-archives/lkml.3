Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaG2PWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:22:00 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:15172 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079AbaG2PUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:20:00 -0400
X-IronPort-AV: E=Sophos;i="5.01,757,1400018400"; 
   d="scan'208";a="87459218"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: kernel-janitors@vger.kernel.org, linux-ia64@vger.kernel.org,
        ceph-devel@vger.kernel.org, toralf.foerster@gmx.de, hmh@hmh.eng.br,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] gpiolib: devres: use correct structure type name in sizeof
Date: Tue, 29 Jul 2014 17:16:48 +0200
Message-Id: <1406647011-8543-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Correct typo in the name of the type given to sizeof.  Because it is the
size of a pointer that is wanted, the typo has no impact on compilation or
execution.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).  The
semantic patch used can be found in message 0 of this patch series.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/gpio/devres.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 65978cf..4a63207 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -84,7 +84,7 @@ struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
 	struct gpio_desc **dr;
 	struct gpio_desc *desc;
 
-	dr = devres_alloc(devm_gpiod_release, sizeof(struct gpiod_desc *),
+	dr = devres_alloc(devm_gpiod_release, sizeof(struct gpio_desc *),
 			  GFP_KERNEL);
 	if (!dr)
 		return ERR_PTR(-ENOMEM);

