Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966854AbaCUBRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:17:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760493AbaCUADy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roman Volkov <v1ron@mail.ru>, Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH 3.13 047/149] ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2
Date: Thu, 20 Mar 2014 17:03:30 -0700
Message-Id: <20140321000438.599004503@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Volkov <v1ron@mail.ru>

commit 3dd77654fb1d7f68b9739f3039bad8dbbc0739f8 upstream.

Actually CS4245 connected to the I2S channel 1 for
capture, not channel 2. Otherwise capturing and
playback does not work for CS4245.

Signed-off-by: Roman Volkov <v1ron@mail.ru>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/oxygen/xonar_dg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


