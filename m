Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3L2C6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:58:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55061 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020Ab3L2CJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:57 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.581049092@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 013/185] ALSA: 6fire: Fix probe of multiple cards
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 9b389a8a022110b4bc055a19b888283544d9eba6 upstream.

The probe code of snd-usb-6fire driver overrides the devices[] pointer
wrongly without checking whether it's already occupied or not.  This
would screw up the device disconnection later.

Spotted by coverity CID 141423.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/6fire/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/6fire/chip.c
+++ b/sound/usb/6fire/chip.c
@@ -102,7 +102,7 @@ static int __devinit usb6fire_chip_probe
 			usb_set_intfdata(intf, chips[i]);
 			mutex_unlock(&register_mutex);
 			return 0;
-		} else if (regidx < 0)
+		} else if (!devices[i] && regidx < 0)
 			regidx = i;
 	}
 	if (regidx < 0) {

