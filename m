Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbbAJVv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:51:59 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:44295 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbbAJVv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:51:58 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] pinctrl: pass -DDEBUG in subdirs
Date: Sat, 10 Jan 2015 22:51:52 +0100
Message-Id: <1420926712-13447-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When drivers are compiled in subdirectories the -DDEBUG flag need
to be passed in the individual Makefiles.

Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Suggested-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
This replaces Mika's patch too.
---
 drivers/pinctrl/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index c030b3db8034..c7139ba195fe 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -1,6 +1,6 @@
 # generic pinmux support
 
-ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
+subdir-ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 
 obj-$(CONFIG_PINCTRL)		+= core.o pinctrl-utils.o
 obj-$(CONFIG_PINMUX)		+= pinmux.o
-- 
1.9.3

