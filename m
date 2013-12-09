Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab3LII14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:27:56 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:35671 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3LII1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:27:55 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: [PATCH] pinctrl: add dependency on OF for MSM driver
Date: Mon,  9 Dec 2013 09:27:44 +0100
Message-Id: <1386577664-23877-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had a compilation failure on x86_64 due to missing OF support
as this was an implicit dependency. Add an explicit dependency
on OF so we get rid of this build failure.

Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 06e057bb3376..138d114d61b8 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -205,6 +205,7 @@ config PINCTRL_IMX28
 
 config PINCTRL_MSM
 	bool
+	depends on OF
 	select PINMUX
 	select PINCONF
 	select GENERIC_PINCONF
-- 
1.8.3.1

