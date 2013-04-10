Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937135Ab3DJXTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:19:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936969Ab3DJWrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 04/64] regmap: Initialize `map->debugfs before regcache
Date: Wed, 10 Apr 2013 15:46:01 -0700
Message-Id: <20130410224334.116051908@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

commit c6432ea9cc043994d5b7dcb3ad86a087777cb40c upstream.

In the rbtree code we are exposing statistics relating to the
number of nodes/registers of the rbtree cache for each of the
devices.  Ensure that `map->debugfs' has been initialized before
we attempt to initialize the debugfs entry for the rbtree cache.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -662,12 +662,12 @@ struct regmap *regmap_init(struct device
 		}
 	}
 
+	regmap_debugfs_init(map, config->name);
+
 	ret = regcache_init(map, config);
 	if (ret != 0)
 		goto err_range;
 
-	regmap_debugfs_init(map, config->name);
-
 	/* Add a devres resource for dev_get_regmap() */
 	m = devres_alloc(dev_get_regmap_release, sizeof(*m), GFP_KERNEL);
 	if (!m) {


