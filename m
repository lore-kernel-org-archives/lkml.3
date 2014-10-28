Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaJ1Dg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:36:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbaJ1Dgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:36:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 031/146] regmap: fix NULL pointer dereference in _regmap_write/read
Date: Tue, 28 Oct 2014 11:32:53 +0800
Message-Id: <20141028033344.790371251@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pankaj Dubey <pankaj.dubey@samsung.com>

commit 5336be8416a71b5568d2cf54a2f2066abe9f2a53 upstream.

If LOG_DEVICE is defined and map->dev is NULL it will lead to NULL
pointer dereference. This patch fixes this issue by adding check for
dev->NULL in all such places in regmap.c

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1408,7 +1408,7 @@ int _regmap_write(struct regmap *map, un
 	}
 
 #ifdef LOG_DEVICE
-	if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
+	if (map->dev && strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
 		dev_info(map->dev, "%x <= %x\n", reg, val);
 #endif
 
@@ -2058,7 +2058,7 @@ static int _regmap_read(struct regmap *m
 	ret = map->reg_read(context, reg, val);
 	if (ret == 0) {
 #ifdef LOG_DEVICE
-		if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
+		if (map->dev && strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
 			dev_info(map->dev, "%x => %x\n", reg, *val);
 #endif
 


