Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412AbaLBXFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:05:35 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59869 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722AbaLBXFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:05:33 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Benoit Taine <benoit.taine@lip6.fr>,
        Bjorn Helgaas <bhelgaas@google.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound: pci: azt3328.c:  Cleaning up function that are not used anywhere
Date: Wed,  3 Dec 2014 00:08:09 +0100
Message-Id: <1417561690-27471-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove function snd_azf3328_codec_outl() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/pci/azt3328.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 5a69e26..82da7b9 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -379,15 +379,6 @@ snd_azf3328_codec_inw(const struct snd_azf3328_codec_data *codec, unsigned reg)
 }
 
 static inline void
-snd_azf3328_codec_outl(const struct snd_azf3328_codec_data *codec,
-		       unsigned reg,
-		       u32 value
-)
-{
-	outl(value, codec->io_base + reg);
-}
-
-static inline void
 snd_azf3328_codec_outl_multi(const struct snd_azf3328_codec_data *codec,
 			     unsigned reg, const void *buffer, int count
 )
-- 
1.7.10.4

