Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3I2Itx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 04:49:53 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1244 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab3I2Itp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 04:49:45 -0400
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
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 6/8] ALSA: ppc: keywest: Don't use i2c_client->driver
Date: Sun, 29 Sep 2013 10:51:04 +0200
Message-Id: <1380444666-12019-7-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1380444666-12019-1-git-send-email-lars@metafoo.de>
References: <1380444666-12019-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'driver' field of the i2c_client struct is redundant and is going to be
removed. Use 'to_i2c_driver(client->dev.driver)' instead to get direct
access to the i2c_driver struct.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/ppc/keywest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/ppc/keywest.c b/sound/ppc/keywest.c
index 01aecc2..0d1c27e 100644
--- a/sound/ppc/keywest.c
+++ b/sound/ppc/keywest.c
@@ -65,7 +65,7 @@ static int keywest_attach_adapter(struct i2c_adapter *adapter)
 	 * already bound. If not it means binding failed, and then there
 	 * is no point in keeping the device instantiated.
 	 */
-	if (!keywest_ctx->client->driver) {
+	if (!keywest_ctx->client->dev.driver) {
 		i2c_unregister_device(keywest_ctx->client);
 		keywest_ctx->client = NULL;
 		return -ENODEV;
@@ -76,7 +76,7 @@ static int keywest_attach_adapter(struct i2c_adapter *adapter)
 	 * This is safe because i2c-core holds the core_lock mutex for us.
 	 */
 	list_add_tail(&keywest_ctx->client->detected,
-		      &keywest_ctx->client->driver->clients);
+		      &to_i2c_driver(keywest_ctx->client->dev.driver)->clients);
 	return 0;
 }
 
-- 
1.8.0

