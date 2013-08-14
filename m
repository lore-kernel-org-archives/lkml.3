Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab3HNKp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:45:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab3HNKiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 57/75] regmap: Add missing header for !CONFIG_REGMAP stubs
Date: Wed, 14 Aug 2013 11:36:46 +0100
Message-Id: <1376476624-10011-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>

commit 49ccc142f9cbc33fdda18e8fa90c1c5b4a79c0ad upstream.

regmap.h requires linux/err.h if CONFIG_REGMAP is not defined. Without it I get
error.
CC      drivers/media/platform/exynos4-is/fimc-reg.o
In file included from drivers/media/platform/exynos4-is/fimc-reg.c:14:0:
include/linux/regmap.h: In function ‘regmap_write’:
include/linux/regmap.h:525:10: error: ‘EINVAL’ undeclared (first use in this function)
include/linux/regmap.h:525:10: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/regmap.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 56af22e..adde16f 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -14,6 +14,7 @@
  */
 
 #include <linux/list.h>
+#include <linux/err.h>
 
 struct module;
 struct device;
-- 
1.8.3.2

