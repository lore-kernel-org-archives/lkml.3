Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaDALP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:15:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42061 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaDALPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:15:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roman Volkov <v1ron@mail.ru>, Clemens Ladisch <clemens@ladisch.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 001/144] ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2
Date: Tue,  1 Apr 2014 12:13:25 +0100
Message-Id: <1396350948-29910-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Volkov <v1ron@mail.ru>

commit 3dd77654fb1d7f68b9739f3039bad8dbbc0739f8 upstream.

Actually CS4245 connected to the I2S channel 1 for
capture, not channel 2. Otherwise capturing and
playback does not work for CS4245.

Signed-off-by: Roman Volkov <v1ron@mail.ru>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
[ luis: backported to 3.11:
  - model_xonar_dg is defined in xonar_dg.c in 3.5 kernel ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/oxygen/xonar_dg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/oxygen/xonar_dg.c b/sound/pci/oxygen/xonar_dg.c
index 77acd79..5519b8f 100644
--- a/sound/pci/oxygen/xonar_dg.c
+++ b/sound/pci/oxygen/xonar_dg.c
@@ -596,7 +596,7 @@ struct oxygen_model model_xonar_dg = {
 	.model_data_size = sizeof(struct dg),
 	.device_config = PLAYBACK_0_TO_I2S |
 			 PLAYBACK_1_TO_SPDIF |
-			 CAPTURE_0_FROM_I2S_2 |
+			 CAPTURE_0_FROM_I2S_1 |
 			 CAPTURE_1_FROM_SPDIF,
 	.dac_channels_pcm = 6,
 	.dac_channels_mixer = 0,
-- 
1.9.1

