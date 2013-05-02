Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab3EBPs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:48:27 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54746 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760190Ab3EBPsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:48:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/4] ARM: ux500: Rid ignored return value of regulator_enable() compiler warning
Date: Thu,  2 May 2013 16:48:07 +0100
Message-Id: <1367509690-24022-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-ux500/board-mop500.c: In function ‘mop500_prox_activate’:
arch/arm/mach-ux500/board-mop500.c:406:18: warning: ignoring return value of
        ‘regulator_enable’, declared with attribute warn_unused_result
        [-Wunused-result]

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index a15dd6b..9bc762a 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -403,8 +403,8 @@ static int mop500_prox_activate(struct device *dev)
 			"no regulator\n");
 		return PTR_ERR(prox_regulator);
 	}
-	regulator_enable(prox_regulator);
-	return 0;
+	
+	return regulator_enable(prox_regulator);
 }
 
 static void mop500_prox_deactivate(struct device *dev)
-- 
1.7.10.4

