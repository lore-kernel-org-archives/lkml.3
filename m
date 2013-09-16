Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3IPUvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:51:47 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:37183 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3IPUvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:51:44 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH linux-next] pinctrl: fix pinconf_dbg_config_write return type
Date: Mon, 16 Sep 2013 22:50:32 +0200
Message-Id: <1379364632-19197-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have pinconf_dbg_config_write() return a ssize_t. This fixes the following
compilation warning:

  drivers/pinctrl/pinconf.c:617:2: warning: initialization from incompatible pointer type [enabled by default]
  drivers/pinctrl/pinconf.c:617:2: warning: (near initialization for ‘pinconf_dbg_pinconfig_fops.write’) [enabled by default]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
---

Hi,

This can be seen with e.g. next-20130916 with x86 allmodconfig.

Best regards,

V.

 drivers/pinctrl/pinconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index a138965..1664e78 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -490,7 +490,7 @@ exit:
  * <devicename> <state> <pinname> are values that should match the pinctrl-maps
  * <newvalue> reflects the new config and is driver dependant
  */
-static int pinconf_dbg_config_write(struct file *file,
+static ssize_t pinconf_dbg_config_write(struct file *file,
 	const char __user *user_buf, size_t count, loff_t *ppos)
 {
 	struct pinctrl_maps *maps_node;
-- 
1.8.4.rc3

