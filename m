Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3KGT27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:28:59 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:48091 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3KGT2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:28:51 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, davem@davemloft.net,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/2] dt: disable self-tests for !OF_IRQ
Date: Thu,  7 Nov 2013 12:15:48 -0600
Message-Id: <1383848149-15488-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Fix OF selftest compile on sparc which does not enable OF_IRQ.

drivers/of/selftest.c:177: undefined reference to `of_irq_parse_one'
drivers/of/selftest.c:197: undefined reference to `of_irq_parse_one'
drivers/of/selftest.c:248: undefined reference to `of_irq_parse_one'

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/of/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 9d2009a..9b28f8b 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -17,6 +17,7 @@ config PROC_DEVICETREE
 
 config OF_SELFTEST
 	bool "Device Tree Runtime self tests"
+	depends on OF_IRQ
 	help
 	  This option builds in test cases for the device tree infrastructure
 	  that are executed one at boot time, and the results dumped to the
-- 
1.8.1.2

