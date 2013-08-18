Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab3HRUry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:47:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3HRUdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, Takashi Iwai <tiwai@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 06/34] sound: Fix make allmodconfig on MIPS
Date: Sun, 18 Aug 2013 13:34:19 -0700
Message-Id: <20130818203300.123829982@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d4702b189c6b951c1cb3260036ff998f719bfb62 upstream.

The compile of soundcard.c is broken on MIPS when allmodconfig is used
because of the missing MAX_DMA_CHANNELS definition.  As a simple
workaround, just add a Kconfig dependency.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/oss/Kconfig |    1 +
 1 file changed, 1 insertion(+)

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


