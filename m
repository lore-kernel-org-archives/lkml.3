Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaC3Xba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:31:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36539 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbaC3XZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Roman Volkov" <v1ron@mail.ru>,
        "Clemens Ladisch" <clemens@ladisch.de>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.14156929@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 195/200] ALSA: oxygen: Xonar DG(X): modify DAC routing
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 1f91ecc14deea9461aca93273d78871ec4d98fcd upstream.

When selecting the audio output destinations (headphones, FP headphones,
multichannel output), unnecessary I2S channels are digitally muted to
avoid invalid signal levels on the other outputs.

Signed-off-by: Roman Volkov <v1ron@mail.ru>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/oxygen/xonar_dg.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/pci/oxygen/xonar_dg.c
+++ b/sound/pci/oxygen/xonar_dg.c
@@ -294,6 +294,16 @@ static int output_switch_put(struct snd_
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

