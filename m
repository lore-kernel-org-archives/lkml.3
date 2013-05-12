Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab3ELMbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 08:31:25 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:58494 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112Ab3ELMbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 08:31:24 -0400
Message-ID: <1368361879.1350.13.camel@x61.thuisdomein>
Subject: [PATCH] sound: Fix make allmodconfig on MIPS correctly
From: Paul Bolle <pebolle@tiscali.nl>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Sun, 12 May 2013 14:31:19 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2013 12:31:20.0727 (UTC) FILETIME=[9B7E4A70:01CE4F0C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d4702b189c ("sound: Fix make allmodconfig on MIPS") added a
(negative) dependency on ISA_DMA_SUPPORT_BROKEN. Since that Kconfig
symbol doesn't exist, this dependency will always evaluate to true.
Apparently GENERIC_ISA_DMA_SUPPORT_BROKEN was meant to be used here.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested only with "git grep".

 sound/oss/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index 51c4ba9..1a96402 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -250,7 +250,7 @@ config MSND_FIFOSIZE
 menuconfig SOUND_OSS
 	tristate "OSS sound modules"
 	depends on ISA_DMA_API && VIRT_TO_BUS
-	depends on !ISA_DMA_SUPPORT_BROKEN
+	depends on !GENERIC_ISA_DMA_SUPPORT_BROKEN
 	help
 	  OSS is the Open Sound System suite of sound card drivers.  They make
 	  sound programming easier since they provide a common API.  Say Y or
-- 
1.7.11.7

