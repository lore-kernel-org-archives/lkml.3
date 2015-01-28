Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbbA2FC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:02:56 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:59398 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbbA2FCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:02:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] sound: sscape: add missing include of linux/io.h
Date: Wed, 28 Jan 2015 16:04:46 +0100
Message-ID: <3560329.35JVsOOFlQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <s5hlhknx8bc.wl-tiwai@suse.de>
References: <7794866.XZSLAdxcrb@wuerfel> <s5hlhknx8bc.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:dMIlYrTsX7z1p2NPc6HW8bZ32f6Bo8uUJs9quo4/66IxYn6xcuN
 DHCDnMYuIrO0ibJzQk6ELgBFJSVzTU47ibnVdZYih1Zwhqv8lF9yCqwKcsvN1H3YKPIE78g
 NwK6cOePZDuFO3h/S0gBPzvwkwxvAwhqHHVfCsHpsaG66oX1k7kQJK35PTn1RksNqJJ4ZMt
 pF0SRnOpnN4CZjrbm+DJQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The soundscape driver uses the ISA inb/outb functions declared
in linux/io.h, so it needs to include this header to avoid
a build error:

sscape.c: In function 'sscape_write_unsafe':
sscape.c:203:2: error: implicit declaration of function 'outb' [-Werror=implicit-function-declaration]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Sorry about messing up the patch description the first time. I'm cleaning
out old patches from a randconfig build tree and I found this one was
still needed but did not inspect the changelog closely enough.

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

