Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab3I3KMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:12:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43464 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab3I3KMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 028/104] regmap: silence GCC warning
Date: Mon, 30 Sep 2013 11:10:05 +0100
Message-Id: <1380535881-9239-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit a8f28cfad8cd44d7c34b166d0e5ace1125dbee1f upstream.

Building regmap.o triggers this GCC warning:
    drivers/base/regmap/regmap.c: In function ‘regmap_raw_read’:
    drivers/base/regmap/regmap.c:1172:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Long story short: Jakub Jelinek pointed out that there is a type
mismatch between 'num' in regmap_volatile_range() and 'val_count' in
regmap_raw_read(). And indeed, converting 'num' to the type of
'val_count' (ie, size_t) makes this warning go away.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c89aa01..cb721e3 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -69,7 +69,7 @@ bool regmap_precious(struct regmap *map, unsigned int reg)
 }
 
 static bool regmap_volatile_range(struct regmap *map, unsigned int reg,
-	unsigned int num)
+	size_t num)
 {
 	unsigned int i;
 
-- 
1.8.3.2

