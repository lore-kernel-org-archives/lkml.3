Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbbA2Ewi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 23:52:38 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:61062 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbbA2Ewh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 23:52:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] sound: sscape: add missing include of asm/io.h
Date: Wed, 28 Jan 2015 15:54:04 +0100
Message-ID: <7794866.XZSLAdxcrb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:uM3Iclk2mUq80w6e3Th2nakszcvTe3lTHsSmllHaFP4BQyn8nUq
 dm06e4F7tItlea+EdJM2OvNDQOitubFRnqLSPg/kKLfy26JTztRcuj2zPMEY3nHtnxU+S11
 gHLBX0iI9YE15odZ4UQEqAux8KplCWeKE7YFcXLwB8IyjJYl8Lw30ANsAQGOU+6kkiR7DhZ
 guSaRBoTwvP3h9xrvpwXg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The soundscape driver uses the ISA inb/outb functions declared
in asm/io.h, so it needs to include this header to avoid
a build error:

sscape.c: In function 'sscape_write_unsafe':
sscape.c:203:2: error: implicit declaration of function 'outb' [-Werror=implicit-function-declaration]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/sound/isa/sscape.c b/sound/isa/sscape.c
index 018ab140c2be..7b248cdf06e2 100644
--- a/sound/isa/sscape.c
+++ b/sound/isa/sscape.c
@@ -23,6 +23,7 @@
 
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/io.h>
 #include <linux/isa.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>

