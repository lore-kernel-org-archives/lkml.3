Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3IKNmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:42:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:19594 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab3IKNmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:42:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,884,1371106800"; 
   d="scan'208";a="401773209"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] mfd: wm8994: fix compile warning in wm8994_i2c_probe()
Date: Wed, 11 Sep 2013 16:42:17 +0300
Message-Id: <1378906937-4437-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building a 64-bit kernel we get following compiler warning:

drivers/mfd/wm8994-core.c: In function ‘wm8994_i2c_probe’:
drivers/mfd/wm8994-core.c:758:19: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Fix this by casting the of_id->data to kernel_ulong_t as it should be the
same size than the native pointer type.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/mfd/wm8994-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index bd53879..9928bb1 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -755,7 +755,7 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	if (i2c->dev.of_node) {
 		of_id = of_match_device(wm8994_of_match, &i2c->dev);
 		if (of_id)
-			wm8994->type = (int)of_id->data;
+			wm8994->type = (kernel_ulong_t)of_id->data;
 	} else {
 		wm8994->type = id->driver_data;
 	}
-- 
1.8.4.rc3

