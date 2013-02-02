Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3BBWxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 17:53:13 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:50490 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751435Ab3BBWxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 17:53:12 -0500
Message-ID: <510D98D1.2000008@semaphore.gr>
Date: Sun, 03 Feb 2013 00:53:05 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] regmap: debugfs: Fix compiler warning
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compiler warning of uninitialized
variable:

drivers/base/regmap/regmap-debugfs.c: In function ‘regmap_read_debugfs’:
drivers/base/regmap/regmap-debugfs.c:180:9: warning: ‘ret’ may be used
uninitialized in this function [-Wmaybe-uninitialized]

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/base/regmap/regmap-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index d9a6c94..aa570af 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -80,7 +80,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 {
        struct regmap_debugfs_off_cache *c = NULL;
        loff_t p = 0;
-       unsigned int i, ret;
+       unsigned int i, ret = base;

        /*
         * If we don't have a cache build one so we don't have to do a
-- 
1.8.1

