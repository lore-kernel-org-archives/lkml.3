Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab3IEUnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:43:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab3IEU2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>, Mark Brown <broonie@linaro.org>
Subject: [ 10/36] regmap: Add another missing header for !CONFIG_REGMAP stubs
Date: Thu,  5 Sep 2013 13:27:39 -0700
Message-Id: <20130905202703.498460488@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hilman <khilman@linaro.org>

commit 3f0fa9a808f98fa10a18ba2a73f13d65fda990fb upstream.

The use of WARN_ON() needs the definitions from bug.h, without it
you can get:

include/linux/regmap.h: In function 'regmap_write':
include/linux/regmap.h:525:2: error: implicit declaration of function 'WARN_ONCE' [-Werror=implicit-function-declaration]

Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/regmap.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -16,6 +16,7 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <linux/err.h>
+#include <linux/bug.h>
 
 struct module;
 struct device;


