Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089Ab3LIO1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:27:10 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:51061 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3LIO1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:27:07 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: [PATCH] pinctrl: select dependency on OF for MSM driver
Date: Mon,  9 Dec 2013 15:27:00 +0100
Message-Id: <1386599220-29474-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had a compilation failure on x86_64 due to missing OF support
as this was an implicit dependency. Add an explicit selection
of OF and OF_IRQ so we get rid of this build failure.

Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- OK so "depends on OF" did not work here let's try to simply
  select OF and OF_IRQ for this then? It's one of those
  "warning: (PINCTRL_MSM8X74) selects PINCTRL_MSM which has
  unmet direct dependencies (PINCTRL && OF)" that I simply
  cannot find my way out of :-/
---
 drivers/pinctrl/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 06e057bb3376..5d96e502dab2 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -205,6 +205,8 @@ config PINCTRL_IMX28
 
 config PINCTRL_MSM
 	bool
+	select OF
+	select OF_IRQ
 	select PINMUX
 	select PINCONF
 	select GENERIC_PINCONF
-- 
1.8.3.1

