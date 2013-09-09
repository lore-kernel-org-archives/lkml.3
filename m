Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3IISp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:45:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57043 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3IISpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kevin Hilman <khilman@linaro.org>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 03/24] regmap: Add another missing header for !CONFIG_REGMAP stubs
Date: Mon,  9 Sep 2013 11:44:53 -0700
Message-Id: <1378752314-2416-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hilman <khilman@linaro.org>

commit 3f0fa9a808f98fa10a18ba2a73f13d65fda990fb upstream.

The use of WARN_ON() needs the definitions from bug.h, without it
you can get:

include/linux/regmap.h: In function 'regmap_write':
include/linux/regmap.h:525:2: error: implicit declaration of function 'WARN_ONCE' [-Werror=implicit-function-declaration]

Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/regmap.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 6a0b639..9064450 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -16,6 +16,7 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <linux/err.h>
+#include <linux/bug.h>
 
 struct module;
 struct device;
-- 
1.8.1.2

