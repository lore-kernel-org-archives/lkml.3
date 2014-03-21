Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965690AbaCUAHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:07:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759652AbaCUAEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roman Volkov <v1ron@mail.ru>, Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH 3.13 143/149] ALSA: oxygen: modify adjust_dg_dac_routing function
Date: Thu, 20 Mar 2014 17:05:06 -0700
Message-Id: <20140321000441.916722815@linuxfoundation.org>
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

commit 1f91ecc14deea9461aca93273d78871ec4d98fcd upstream.

When selecting the audio output destinations (headphones,
FP headphones, multichannel output), the channel routing
should be changed depending on what destination selected.
Also unnecessary I2S channels are digitally muted. This
function called when the user selects the destination
in the ALSA mixer.

Signed-off-by: Roman Volkov <v1ron@mail.ru>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


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


