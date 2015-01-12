Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbbALXAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:00:50 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:64856 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbALXAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:00:49 -0500
Message-ID: <54B4521E.4050507@landley.net>
Date: Mon, 12 Jan 2015 17:00:46 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] Build superh without CONFIG_EXPERT.
References: <53700D71.1090201@landley.net>	<53767FB9.5040508@infradead.org> <CAMuHMdVnUqc+gyqok_OAUWT++K-O=9kRQkyUkHduPGxQUQ20oA@mail.gmail.com>
In-Reply-To: <CAMuHMdVnUqc+gyqok_OAUWT++K-O=9kRQkyUkHduPGxQUQ20oA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

What sh4 actually wants is HAVE_PATA_PLATFORM, so select that instead.

Signed-off-by: Rob Landley <rob@landley.net>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

---

 arch/sh/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

A follow-up patch could simplify the defconfigs in arch/sh/configs...

--- linux/arch/sh/Kconfig
+++ linux/arch/sh/Kconfig
@@ -1,7 +1,7 @@
 config SUPERH
 	def_bool y
 	select ARCH_MIGHT_HAVE_PC_PARPORT
-	select EXPERT
+	select HAVE_PATA_PLATFORM
 	select CLKDEV_LOOKUP
 	select HAVE_IDE if HAS_IOPORT_MAP
 	select HAVE_MEMBLOCK
