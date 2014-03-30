Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaC3XdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:33:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36540 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Clemens Ladisch" <clemens@ladisch.de>,
        "Roman Volkov" <v1ron@mail.ru>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.166796139@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 194/200] ALSA: oxygen: Xonar DG(X): capture from I2S
 channel 1, not 2
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Volkov <v1ron@mail.ru>

commit 3dd77654fb1d7f68b9739f3039bad8dbbc0739f8 upstream.

Actually CS4245 connected to the I2S channel 1 for
capture, not channel 2. Otherwise capturing and
playback does not work for CS4245.

Signed-off-by: Roman Volkov <v1ron@mail.ru>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/oxygen/xonar_dg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/oxygen/xonar_dg.c
+++ b/sound/pci/oxygen/xonar_dg.c
@@ -597,7 +597,7 @@ struct oxygen_model model_xonar_dg = {
 	.model_data_size = sizeof(struct dg),
 	.device_config = PLAYBACK_0_TO_I2S |
 			 PLAYBACK_1_TO_SPDIF |
-			 CAPTURE_0_FROM_I2S_2,
+			 CAPTURE_0_FROM_I2S_1,
 	.dac_channels_pcm = 6,
 	.dac_channels_mixer = 0,
 	.function_flags = OXYGEN_FUNCTION_SPI,

