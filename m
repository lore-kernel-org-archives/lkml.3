Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaDVKrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:47:43 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:50352 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbaDVKri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:47:38 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] regmap: Add missing initialization of this_page
Date: Tue, 22 Apr 2014 12:47:29 +0200
Message-Id: <1398163650-19367-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/base/regmap/regmap.c: In function ‘_regmap_range_multi_paged_reg_write’:
drivers/base/regmap/regmap.c:1665: warning: ‘this_page’ may be used uninitialized in this function

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This may be a false positive, if "range" is guaranteed to be non-zero
during the first iteration of the loop
---
 drivers/base/regmap/regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 63e30ef096e2..0eaf581b2bb6 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1662,7 +1662,7 @@ static int _regmap_range_multi_paged_reg_write(struct regmap *map,
 	int ret;
 	int i, n;
 	struct reg_default *base;
-	unsigned int this_page;
+	unsigned int this_page = 0;
 	/*
 	 * the set of registers are not neccessarily in order, but
 	 * since the order of write must be preserved this algorithm
-- 
1.7.9.5

