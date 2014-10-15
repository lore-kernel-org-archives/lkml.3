Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaJOVfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 17:35:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:41618 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaJOVfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 17:35:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,727,1406617200"; 
   d="scan'208";a="619452754"
From: David Cohen <david.a.cohen@linux.intel.com>
To: thierry.reding@gmail.com
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] pwm: clps711x: add CONFIG_HAS_IOMEM dependence
Date: Wed, 15 Oct 2014 14:36:10 -0700
Message-Id: <1413408970-13648-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clps711x uses io memory which makes it not compilable on architectures
without HAS_IOMEM such as UML:

drivers/built-in.o: In function `clps711x_pwm_probe':
pwm-clps711x.c:(.text+0x2848): undefined reference to
`devm_ioremap_resource'

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/pwm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 3865dfb9ed08..bc5bdce00059 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -82,7 +82,7 @@ config PWM_BFIN
 
 config PWM_CLPS711X
 	tristate "CLPS711X PWM support"
-	depends on ARCH_CLPS711X || COMPILE_TEST
+	depends on HAS_IOMEM && (ARCH_CLPS711X || COMPILE_TEST)
 	help
 	  Generic PWM framework driver for Cirrus Logic CLPS711X.
 
-- 
2.1.0

