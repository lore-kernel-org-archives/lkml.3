Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaDAKqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:46:51 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47088 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaDAKqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:46:48 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: broonie@kernel.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] regmap: adds missing braces in regmap_init()
Date: Tue, 01 Apr 2014 19:46:43 +0900
Message-ID: <5822859.Za3p9c1V74@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It need to add curly braces because the inner for "if" has
two statements.

coccicheck says:
 drivers/base/regmap/regmap.c:765:2-44:
code aligned with following code on line 766

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/base/regmap/regmap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d0a0724..63e30ef 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -761,10 +761,11 @@ skip_format_initialization:
 	if (ret != 0)
 		goto err_range;
 
-	if (dev)
+	if (dev) {
 		ret = regmap_attach_dev(dev, map, config);
 		if (ret != 0)
 			goto err_regcache;
+	}
 
 	return map;
 
-- 
1.7.4.4


