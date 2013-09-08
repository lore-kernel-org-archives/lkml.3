Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab3IHDUk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56203 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756543Ab3IHDSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:51 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Paul Bolle" <pebolle@tiscali.nl>,
        "Guenter Roeck" <linux@roeck-us.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.875014971@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [093/121] sound: Fix make allmodconfig on MIPS correctly
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/oss/Kconfig | 2 +-
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

