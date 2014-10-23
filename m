Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaJWISH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:18:07 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5652 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaJWISC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:18:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 23 Oct 2014 01:17:28 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] input: soc_button_array: update calls to gpiod_get*()
Date: Thu, 23 Oct 2014 17:17:55 +0900
Message-ID: <1414052275-20310-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new flags argument to calls of (devm_)gpiod_get*().

Currently both forms (with or without the flags argument)
are valid thanks to transitional macros in
<linux/gpio/consumer.h>. These macros will be removed once
all consumers are updated and the flags argument will become
compulsary.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/input/misc/soc_button_array.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
index 735604753568..e097f1ab427f 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -55,7 +55,7 @@ static int soc_button_lookup_gpio(struct device *dev, int acpi_index)
 	struct gpio_desc *desc;
 	int gpio;
 
-	desc = gpiod_get_index(dev, KBUILD_MODNAME, acpi_index);
+	desc = gpiod_get_index(dev, KBUILD_MODNAME, acpi_index, GPIOD_ASIS);
 	if (IS_ERR(desc))
 		return PTR_ERR(desc);
 
-- 
2.1.2

