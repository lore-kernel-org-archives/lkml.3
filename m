Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaAQLfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 06:35:30 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:55069 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaAQLf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 06:35:28 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jan 2014 06:35:28 EST
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] cris: Provide {in,out}[wl]_p()
Date: Fri, 17 Jan 2014 12:30:22 +0100
Message-Id: <1389958222-4540-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/comedi/drivers/das6402.c: In function 'intr_handler':
drivers/staging/comedi/drivers/das6402.c:164:3: error: implicit declaration of function 'outw_p' [-Werror=implicit-function-declaration]
drivers/staging/speakup/speakup_dtlk.c: In function 'synth_probe':
drivers/staging/speakup/speakup_dtlk.c:362:2: error: implicit declaration of function 'inw_p' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/include/asm/io.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index 4353cf239a13..e59dba12ce94 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -169,7 +169,11 @@ static inline void outsl(unsigned int port, const void *addr,
 }
 
 #define inb_p(port)             inb(port)
+#define inw_p(port)             inw(port)
+#define inl_p(port)             inl(port)
 #define outb_p(val, port)       outb((val), (port))
+#define outw_p(val, port)       outw((val), (port))
+#define outl_p(val, port)       outl((val), (port))
 
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
-- 
1.7.9.5

