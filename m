Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3LSPFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:05:03 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:51826 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3LSPE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:58 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Ondrej Zary <linux@rainbow-software.org>,
        Yacine Belkadi <yacine.belkadi.1@gmail.com>,
        alsa-devel@alsa-project.org
Subject: [PATCH 22/38] sound: ac97: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:33 +0100
Message-Id: <1387465429-3568-23-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 sound/pci/ac97/ac97_codec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index bf578ba2..55186f8 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -1964,6 +1964,7 @@ static int snd_ac97_dev_register(struct snd_device *device)
 		     snd_ac97_get_short_name(ac97));
 	if ((err = device_register(&ac97->dev)) < 0) {
 		snd_printk(KERN_ERR "Can't register ac97 bus\n");
+		put_device(&ac97->dev);
 		ac97->dev.bus = NULL;
 		return err;
 	}
-- 
1.8.3.1

