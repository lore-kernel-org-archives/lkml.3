Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab3HMG6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:58:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab3HMGdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@linaro.org>
Subject: [ 14/60] regmap: Add missing header for !CONFIG_REGMAP stubs
Date: Mon, 12 Aug 2013 23:33:41 -0700
Message-Id: <20130813063334.066855737@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/regmap.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -15,6 +15,7 @@
 
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include <linux/err.h>
 
 struct module;
 struct device;


