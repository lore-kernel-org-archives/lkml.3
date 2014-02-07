Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaBGQqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:46:37 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:55896 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaBGQqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:46:36 -0500
Date: Fri, 7 Feb 2014 22:16:31 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rashika Kheria <rashika.kheria@gmail.com>, alsa-devel@alsa-project.org,
        josh@joshtriplett.org
Subject: [PATCH 3/3] sound: Move prototype declaration to header file
 oss/pas2.h from oss/pas2_card.c
Message-ID: <3c35e9b980ccc0ca155214e8fad0dae24b20c5af.1391791103.git.rashika.kheria@gmail.com>
References: <512472c7d96cf1c239ba3d0bc517891a7c2f9da1.1391791103.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <512472c7d96cf1c239ba3d0bc517891a7c2f9da1.1391791103.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration of function to header file oss/pas2.h
from oss/pas2_card.c because it is used by more than one file.

This eliminates the following warnings in oss/pas2_mixer.c:
sound/oss/pas2_mixer.c:62:1: warning: no previous prototype for ‘mix_write’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 sound/oss/pas2.h      |    3 +++
 sound/oss/pas2_card.c |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/oss/pas2.h b/sound/oss/pas2.h
index fa12c55..d19f757 100644
--- a/sound/oss/pas2.h
+++ b/sound/oss/pas2.h
@@ -15,3 +15,6 @@ int pas_init_mixer(void);
 /*	From pas_midi.c */
 void pas_midi_init(void);
 void pas_midi_interrupt(void);
+
+/*	From pas2_mixer.c*/
+void mix_write(unsigned char data, int ioaddr);
diff --git a/sound/oss/pas2_card.c b/sound/oss/pas2_card.c
index 7004e24..b07954a 100644
--- a/sound/oss/pas2_card.c
+++ b/sound/oss/pas2_card.c
@@ -74,8 +74,6 @@ static char    *pas_model_names[] = {
  * to support other than the default base address
  */
 
-extern void     mix_write(unsigned char data, int ioaddr);
-
 unsigned char pas_read(int ioaddr)
 {
 	return inb(ioaddr + pas_translate_code);
-- 
1.7.9.5

