Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbaIWWz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:55:26 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53950 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbaIWWzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:55:23 -0400
From: behanw@converseincode.com
To: bcm@fixthebug.org, chris@printf.net, gnurou@gmail.com,
        linus.walleij@linaro.org, mporter@linaro.org, ulf.hansson@linaro.org
Cc: bcm-kernel-feedback-list@broadcom.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        rjui@broadcom.com, Behan Webster <behanw@converseincode.com>
Subject: [PATCH v2 1/2] gpio, bcm-kona, LLVMLinux: Remove use of __initconst
Date: Tue, 23 Sep 2014 15:55:07 -0700
Message-Id: <1411512908-19237-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140923212922.GG12270@beef>
References: <20140923212922.GG12270@beef>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

The __initconst is in the wrong place, and when moved to the correct place
it uncovers an error where the variable is used by non-init data structures.

Instead merely make them const and put the const in the right spot.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Matt Porter <mporter@linaro.org>
---
 drivers/gpio/gpio-bcm-kona.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index 3f6b33c..de0801e 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -496,7 +496,7 @@ static struct irq_chip bcm_gpio_irq_chip = {
 	.irq_release_resources = bcm_kona_gpio_irq_relres,
 };
 
-static struct __initconst of_device_id bcm_kona_gpio_of_match[] = {
+static struct of_device_id const bcm_kona_gpio_of_match[] = {
 	{ .compatible = "brcm,kona-gpio" },
 	{}
 };
-- 
1.9.1

