Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030438Ab3HBKLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:11:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030386Ab3HBKLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:11:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>, Mark Brown <broonie@linaro.org>
Subject: [ 58/99] regmap: cache: bail in regmap_async_complete() for bus-less maps
Date: Fri,  2 Aug 2013 18:08:11 +0800
Message-Id: <20130802100234.108671389@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit f2e055e7c9c6084bfbaa68701e52562acf96419e upstream.

Commit f8bd822cb ("regmap: cache: Factor out block sync") made
regcache_rbtree_sync() call regmap_async_complete(), which in turn does
not check for map->bus before dereferencing it.

This causes a NULL pointer dereference on bus-less maps.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1717,7 +1717,7 @@ int regmap_async_complete(struct regmap
 	int ret;
 
 	/* Nothing to do with no async support */
-	if (!map->bus->async_write)
+	if (!map->bus || !map->bus->async_write)
 		return 0;
 
 	trace_regmap_async_complete_start(map->dev);


