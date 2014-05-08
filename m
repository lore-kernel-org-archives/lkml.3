Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaEHF0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 01:26:21 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62431 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaEHF0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 01:26:20 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] sound: soc: intel: remove unneeded dependency from Makefile
Date: Thu,  8 May 2014 10:56:11 +0530
Message-Id: <1399526771-28422-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch removes drops the entries form Makefile, fixing
following issues when make clean was run,

scripts/Makefile.clean:17: sound/soc/intel/board/Makefile: No such file or directory
scripts/Makefile.clean:17: sound/soc/intel/sst/Makefile: No such file or directory

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Found this issue on linux-next not sure if this is fixed in
 sound subsystem tree.
 
 sound/soc/intel/Makefile |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/soc/intel/Makefile b/sound/soc/intel/Makefile
index 57242c4..26544c5 100644
--- a/sound/soc/intel/Makefile
+++ b/sound/soc/intel/Makefile
@@ -32,9 +32,3 @@ PLATFORM_LIBS = platform-libs/controls_v2_dpcm.o
 
 snd-soc-sst-platform-objs := pcm.o compress.o $(PLATFORM_LIBS)
 obj-$(CONFIG_SND_SST_PLATFORM) += snd-soc-sst-platform.o
-
-# Relevant Machine driver
-obj-$(CONFIG_SND_SST_MACHINE) += board/
-
-# IPC driver
-obj-$(CONFIG_SND_INTEL_SST) += sst/
-- 
1.7.9.5

