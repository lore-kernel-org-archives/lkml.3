Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab3CMLzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:55:07 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:37034 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab3CMLzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:55:05 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 1/1] pinctrl: generic: Fix compilation error
Date: Wed, 13 Mar 2013 17:13:46 +0530
Message-Id: <1363175026-11016-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function definition of pinconf_generic_dump_config is defined
under CONFIG_DEBUG_FS macro. Define the declaration too under this macro.

Without this patch we get the following build error:
drivers/built-in.o: In function `pcs_pinconf_config_dbg_show':
drivers/pinctrl/pinctrl-single.c:726: undefined reference to
`pinconf_generic_dump_config'

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinconf.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
index 1f7113e..92c7267 100644
--- a/drivers/pinctrl/pinconf.h
+++ b/drivers/pinctrl/pinconf.h
@@ -90,7 +90,7 @@ static inline void pinconf_init_device_debugfs(struct dentry *devroot,
  * pin config.
  */
 
-#ifdef CONFIG_GENERIC_PINCONF
+#if defined(CONFIG_GENERIC_PINCONF) && defined(CONFIG_DEBUG_FS)
 
 void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
 			      struct seq_file *s, unsigned pin);
-- 
1.7.4.1

