Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3LJJGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:06:32 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:41711 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3LJJGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:06:25 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: [PATCH] pinctrl: make the MSM SoC driver depend on OF
Date: Tue, 10 Dec 2013 10:06:10 +0100
Message-Id: <1386666370-6394-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had a compilation failure on x86_64 due to missing OF support
as this was an implicit dependency. Add an explicit dependency
on OF and OF_IRQ on the SoC driver.

Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Total failure with older approaches: what we need to do is
  have the *SoC subdriver* depend on OF and OF_IRQ. This is
  because the placeholder bool PINCTRL_MSM cannot cascade its
  dependencies when a subdriver selects it, Kconfig is smart
  but not that smart.
ChangeLog v1->v2:
- OK so "depends on OF" did not work here let's try to simply
  select OF and OF_IRQ for this then? It's one of those
  "warning: (PINCTRL_MSM8X74) selects PINCTRL_MSM which has
  unmet direct dependencies (PINCTRL && OF)" that I simply
  cannot find my way out of :-/
---
 drivers/pinctrl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 06e057bb3376..30fcb897eb99 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -211,6 +211,7 @@ config PINCTRL_MSM
 
 config PINCTRL_MSM8X74
 	bool "Qualcomm 8x74 pin controller driver"
+	depends on OF && OF_IRQ
 	select PINCTRL_MSM
 
 config PINCTRL_NOMADIK
-- 
1.8.3.1

