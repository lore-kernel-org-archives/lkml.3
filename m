Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab3L2C13 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:27:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55559 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281Ab3L2CLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:00 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.456931977@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 064/185] ALSA: pcsp: Fix the order of input device
 unregistration
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

commit 6408eac2665955343cd0e4bcd7d6237ce39611ed upstream.

The current code may access to the already freed object.  The input
device must be accessed and unregistered before freeing the top level
sound object.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/drivers/pcsp/pcsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/drivers/pcsp/pcsp.c
+++ b/sound/drivers/pcsp/pcsp.c
@@ -187,8 +187,8 @@ static int __devinit pcsp_probe(struct p
 static int __devexit pcsp_remove(struct platform_device *dev)
 {
 	struct snd_pcsp *chip = platform_get_drvdata(dev);
-	alsa_card_pcsp_exit(chip);
 	pcspkr_input_remove(chip->input_dev);
+	alsa_card_pcsp_exit(chip);
 	platform_set_drvdata(dev, NULL);
 	return 0;
 }

