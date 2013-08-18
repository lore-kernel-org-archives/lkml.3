Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3HRUef (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:34:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3HRUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Takashi Iwai <tiwai@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 07/34] sound: Fix make allmodconfig on MIPS correctly
Date: Sun, 18 Aug 2013 13:34:20 -0700
Message-Id: <20130818203300.191517255@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit a62ee234a572b4c98fe98cf5fb18e4e8b0f6e43d upstream.

Commit d4702b189c ("sound: Fix make allmodconfig on MIPS") added a
(negative) dependency on ISA_DMA_SUPPORT_BROKEN. Since that Kconfig
symbol doesn't exist, this dependency will always evaluate to true.
Apparently GENERIC_ISA_DMA_SUPPORT_BROKEN was meant to be used here.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/oss/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


