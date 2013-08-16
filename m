Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab3HQAGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:06:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51731 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab3HPWj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 100/133] regmap: Add missing header for !CONFIG_REGMAP stubs
Date: Fri, 16 Aug 2013 15:34:02 -0700
Message-Id: <1376692475-28413-101-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/regmap.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index b7e95bf..6a0b639 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -15,6 +15,7 @@
 
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include <linux/err.h>
 
 struct module;
 struct device;
-- 
1.8.1.2

