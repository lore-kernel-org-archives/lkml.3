Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaCaNXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:23:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35512 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaCaNXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roman Volkov <v1ron@mail.ru>, Clemens Ladisch <clemens@ladisch.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 02/71] ALSA: oxygen: Xonar DG(X): modify DAC routing
Date: Mon, 31 Mar 2014 14:22:08 +0100
Message-Id: <1396272197-13394-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 1f91ecc14deea9461aca93273d78871ec4d98fcd upstream.

When selecting the audio output destinations (headphones, FP headphones,
multichannel output), unnecessary I2S channels are digitally muted to
avoid invalid signal levels on the other outputs.

Signed-off-by: Roman Volkov <v1ron@mail.ru>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/oxygen/xonar_dg.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/pci/oxygen/xonar_dg.c b/sound/pci/oxygen/xonar_dg.c
index 5519b8f..eb7ad77 100644
--- a/sound/pci/oxygen/xonar_dg.c
+++ b/sound/pci/oxygen/xonar_dg.c
@@ -294,6 +294,16 @@ static int output_switch_put(struct snd_kcontrol *ctl,
 		oxygen_write16_masked(chip, OXYGEN_GPIO_DATA,
 				      data->output_sel == 1 ? GPIO_HP_REAR : 0,
 				      GPIO_HP_REAR);
+		oxygen_write8_masked(chip, OXYGEN_PLAY_ROUTING,
+				     data->output_sel == 0 ?
+				     OXYGEN_PLAY_MUTE01 :
+				     OXYGEN_PLAY_MUTE23 |
+				     OXYGEN_PLAY_MUTE45 |
+				     OXYGEN_PLAY_MUTE67,
+				     OXYGEN_PLAY_MUTE01 |
+				     OXYGEN_PLAY_MUTE23 |
+				     OXYGEN_PLAY_MUTE45 |
+				     OXYGEN_PLAY_MUTE67);
 	}
 	mutex_unlock(&chip->mutex);
 	return changed;
-- 
1.9.1

