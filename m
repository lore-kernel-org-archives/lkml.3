Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab3I2Ivj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 04:51:39 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1440 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab3I2It3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 04:49:29 -0400
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
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 1/8] [media] s5c73m3: Don't use i2c_client->driver
Date: Sun, 29 Sep 2013 10:50:59 +0200
Message-Id: <1380444666-12019-2-git-send-email-lars@metafoo.de>
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
Cc: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index b76ec0e..1083890 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1581,7 +1581,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	oif_sd = &state->oif_sd;
 
 	v4l2_subdev_init(sd, &s5c73m3_subdev_ops);
-	sd->owner = client->driver->driver.owner;
+	sd->owner = client->dev.driver->owner;
 	v4l2_set_subdevdata(sd, state);
 	strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
 
-- 
1.8.0

