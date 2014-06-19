Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356AbaFSPEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:04:07 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:36015 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbaFSPEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:04:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] gpio: crystalcove: Fix implicit declaration of function 'seq_printf' error
Date: Thu, 19 Jun 2014 16:03:48 +0100
Message-Id: <1403190228-14344-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpio/gpio-crystalcove.c: In function 'crystalcove_gpio_dbg_show':
drivers/gpio/gpio-crystalcove.c:286:3: error: implicit declaration of function 'seq_printf'
   seq_printf(s, " gpio-%-2d %s %s %s %s ctlo=%2x,%s %s %s\n",

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
I'm looking for a quick Ack on this patch.  It's a fix to an immutable
branch that I'm carrying which is shared between GPIO and MFD.  Stephen
reported it when the MFD tree was sucked into -next.

Alexandre,
  I believe Linus is out on vacation this week, so if you could take a
quick look at this, I'd be much obliged.

Linus,
  Once I've acquired the aforementioned Ack I'll fix this patch up into
our immutable branch and send another pull-request.
---
 drivers/gpio/gpio-crystalcove.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
index 5a98499..934462f 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/seq_file.h>
 #include <linux/bitops.h>
 #include <linux/regmap.h>
 #include <linux/mfd/intel_soc_pmic.h>
-- 
1.8.3.2

