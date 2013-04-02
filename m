Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520Ab3DBAUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 20:20:48 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:65475 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759485Ab3DBAUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 20:20:44 -0400
Message-ID: <1364862038.15806.1.camel@phoenix>
Subject: [PATCH] regulator: ab8500: Staticize
 ab8500_ext_regulator_[init|exit] if !CONFIG_REGULATOR_AB8500_EXT
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 02 Apr 2013 08:20:38 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build errors:

  LD      arch/arm/mach-ux500/built-in.o
arch/arm/mach-ux500/board-mop500-regulators.o: In function `ab8500_ext_regulator_init':
include/linux/regulator/ab8500.h:331: multiple definition of `ab8500_ext_regulator_init'
arch/arm/mach-ux500/board-mop500.o:/home/axel/repos/git/regulator/include/linux/regulator/ab8500.h:331: first defined here
arch/arm/mach-ux500/board-mop500-regulators.o: In function `ab8500_ext_regulator_exit':
include/linux/regulator/ab8500.h:335: multiple definition of `ab8500_ext_regulator_exit'
arch/arm/mach-ux500/board-mop500.o:/home/axel/repos/git/regulator/include/linux/regulator/ab8500.h:335: first defined here
make[1]: *** [arch/arm/mach-ux500/built-in.o] Error 1
make: *** [arch/arm/mach-ux500] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 include/linux/regulator/ab8500.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index bb0140c..1790059 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -325,11 +325,11 @@ struct ab8500_regulator_platform_data {
 int ab8500_ext_regulator_init(struct platform_device *pdev);
 int ab8500_ext_regulator_exit(struct platform_device *pdev);
 #else
-inline int ab8500_ext_regulator_init(struct platform_device *pdev)
+static inline int ab8500_ext_regulator_init(struct platform_device *pdev)
 {
 	return 0;
 }
-inline int ab8500_ext_regulator_exit(struct platform_device *pdev)
+static inline int ab8500_ext_regulator_exit(struct platform_device *pdev)
 {
 	return 0;
 }
-- 
1.7.10.4



