Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3I2Itu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 04:49:50 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1222 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab3I2Ito (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 04:49:44 -0400
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
        Martin Peres <martin.peres@labri.fr>
Subject: [PATCH 5/8] drm: nouveau: Don't use i2c_client->driver
Date: Sun, 29 Sep 2013 10:51:03 +0200
Message-Id: <1380444666-12019-6-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1380444666-12019-1-git-send-email-lars@metafoo.de>
References: <1380444666-12019-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'driver' field of the i2c_client struct is redundant and is going to be
removed. Use 'to_i2c_driver(client->dev.driver)' instead to get direct access to
the i2c_driver struct.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Martin Peres <martin.peres@labri.fr>
---
 drivers/gpu/drm/nouveau/core/subdev/therm/ic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/therm/ic.c b/drivers/gpu/drm/nouveau/core/subdev/therm/ic.c
index 8b3adec..eae939d 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/therm/ic.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/therm/ic.c
@@ -41,7 +41,8 @@ probe_monitoring_device(struct nouveau_i2c_port *i2c,
 	if (!client)
 		return false;
 
-	if (!client->driver || client->driver->detect(client, info)) {
+	if (!client->dev.driver ||
+	    to_i2c_driver(client->dev.driver)->detect(client, info)) {
 		i2c_unregister_device(client);
 		return false;
 	}
-- 
1.8.0

