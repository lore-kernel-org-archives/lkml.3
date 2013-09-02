Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab3IBJIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:08:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37742 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401Ab3IBIzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ralf Baechle <ralf@linux-mips.org>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 26/58] sound: Fix make allmodconfig on MIPS
Date: Mon,  2 Sep 2013 09:54:11 +0100
Message-Id: <1378112083-9475-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d4702b189c6b951c1cb3260036ff998f719bfb62 upstream.

The compile of soundcard.c is broken on MIPS when allmodconfig is used
because of the missing MAX_DMA_CHANNELS definition.  As a simple
workaround, just add a Kconfig dependency.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/oss/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index 5849b12..51c4ba9 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -250,6 +250,7 @@ config MSND_FIFOSIZE
 menuconfig SOUND_OSS
 	tristate "OSS sound modules"
 	depends on ISA_DMA_API && VIRT_TO_BUS
+	depends on !ISA_DMA_SUPPORT_BROKEN
 	help
 	  OSS is the Open Sound System suite of sound card drivers.  They make
 	  sound programming easier since they provide a common API.  Say Y or
-- 
1.8.3.2

