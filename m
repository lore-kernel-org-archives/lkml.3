Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab3LERzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:55:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297Ab3LERhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 34/90] ALSA: pcsp: Fix the order of input device unregistration
Date: Thu,  5 Dec 2013 17:35:16 +0000
Message-Id: <1386264972-5399-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6408eac2665955343cd0e4bcd7d6237ce39611ed upstream.

The current code may access to the already freed object.  The input
device must be accessed and unregistered before freeing the top level
sound object.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/drivers/pcsp/pcsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/drivers/pcsp/pcsp.c b/sound/drivers/pcsp/pcsp.c
index 99704e6..7ab6741 100644
--- a/sound/drivers/pcsp/pcsp.c
+++ b/sound/drivers/pcsp/pcsp.c
@@ -187,8 +187,8 @@ static int __devinit pcsp_probe(struct platform_device *dev)
 static int __devexit pcsp_remove(struct platform_device *dev)
 {
 	struct snd_pcsp *chip = platform_get_drvdata(dev);
-	alsa_card_pcsp_exit(chip);
 	pcspkr_input_remove(chip->input_dev);
+	alsa_card_pcsp_exit(chip);
 	platform_set_drvdata(dev, NULL);
 	return 0;
 }
-- 
1.8.3.2

