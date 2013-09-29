Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab3I2Ith (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 04:49:37 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1456 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab3I2Itb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 04:49:31 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1782
From: Lars-Peter Clausen <lars@metafoo.de>
To: Wolfram Sang <wsa@the-dreams.de>, David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/8] [media] exynos4-is: Don't use i2c_client->driver
Date: Sun, 29 Sep 2013 10:51:00 +0200
Message-Id: <1380444666-12019-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1380444666-12019-1-git-send-email-lars@metafoo.de>
References: <1380444666-12019-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'driver' field of the i2c_client struct is redundant and is going to be
removed. The results of the expressions 'client->driver.driver->field' and
'client->dev.driver->field' are identical, so replace all occurrences of the
former with the later.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index a835112..7a4ee4c 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -411,8 +411,8 @@ static int fimc_md_of_add_sensor(struct fimc_md *fmd,
 
 	device_lock(&client->dev);
 
-	if (!client->driver ||
-	    !try_module_get(client->driver->driver.owner)) {
+	if (!client->dev.driver ||
+	    !try_module_get(client->dev.driver->owner)) {
 		ret = -EPROBE_DEFER;
 		v4l2_info(&fmd->v4l2_dev, "No driver found for %s\n",
 						node->full_name);
@@ -442,7 +442,7 @@ static int fimc_md_of_add_sensor(struct fimc_md *fmd,
 	fmd->num_sensors++;
 
 mod_put:
-	module_put(client->driver->driver.owner);
+	module_put(client->dev.driver->owner);
 dev_put:
 	device_unlock(&client->dev);
 	put_device(&client->dev);
-- 
1.8.0

