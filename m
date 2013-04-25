Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab3DYR3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:29:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62626 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929Ab3DYR3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH 06/21] ALSA: ali5451: use mdelay instead of large udelay constants
Date: Thu, 25 Apr 2013 19:28:49 +0200
Message-Id: <1366910944-3033663-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:3mFDWxf5DvANutbs3AdV5k8psouQ3cX+/zYAr1+Zapc
 7Sckz/4HAlsOxHmfatvmGizXUBKsPQrbmuKGbns93POqsniuO6
 rUnAvzHOTYQCDeJkB/7HBBN6EWy5VXk8HGYf4snCQN3no51g7W
 sc0kukoqelmrkPNgnxHkgYbk/NOgZ5mS1Fm/zPx05FA6szsS8o
 Djb7IG3+c8FQyKphTFC+FpI5Mr8msBQkCd6Lst8T3mCAjP35LE
 C/xP3uIKKC243Xpu71VlL/08ss6EFTfJgWJPhbyv/f5A/0qI6Q
 0juRW5RRi81kdKTHrqgFzu+wbTfNISLZmZbrt2rhHrQGqTY5CY
 YXGkYpgFlvwFajQYF5ugGodCDzI09Oi/d++yM3OMg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM cannot handle udelay for more than 2 miliseconds, so we
should use mdelay instead for those.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
---
 sound/pci/ali5451/ali5451.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index e760af9..53754f5 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -451,10 +451,10 @@ static int snd_ali_reset_5451(struct snd_ali *codec)
 	if (pci_dev) {
 		pci_read_config_dword(pci_dev, 0x7c, &dwVal);
 		pci_write_config_dword(pci_dev, 0x7c, dwVal | 0x08000000);
-		udelay(5000);
+		mdelay(5);
 		pci_read_config_dword(pci_dev, 0x7c, &dwVal);
 		pci_write_config_dword(pci_dev, 0x7c, dwVal & 0xf7ffffff);
-		udelay(5000);
+		mdelay(5);
 	}
 	
 	pci_dev = codec->pci;
@@ -463,14 +463,14 @@ static int snd_ali_reset_5451(struct snd_ali *codec)
 	udelay(500);
 	pci_read_config_dword(pci_dev, 0x44, &dwVal);
 	pci_write_config_dword(pci_dev, 0x44, dwVal & 0xfffbffff);
-	udelay(5000);
+	mdelay(5);
 	
 	wCount = 200;
 	while(wCount--) {
 		wReg = snd_ali_codec_peek(codec, 0, AC97_POWERDOWN);
 		if ((wReg & 0x000f) == 0x000f)
 			return 0;
-		udelay(5000);
+		mdelay(5);
 	}
 
 	/* non-fatal if you have a non PM capable codec */
-- 
1.8.1.2

