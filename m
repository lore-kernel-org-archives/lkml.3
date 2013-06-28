Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3F1InG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:43:06 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:54517 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3F1InC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:43:02 -0400
Date: Fri, 28 Jun 2013 10:42:59 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kevin Hilman <khilman@linaro.org>
cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] ARM: zImage: fix path to fonts which moved to
 lib/fonts
In-Reply-To: <CAMuHMdVoqKTwgYLCu2ktcWEOYHy+jGo4YZ7ithAgQ6EN0Nhnqw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1306281041100.25479@ayla.of.borg>
References: <1372363940-13023-1-git-send-email-khilman@linaro.org> <CAMuHMdVoqKTwgYLCu2ktcWEOYHy+jGo4YZ7ithAgQ6EN0Nhnqw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013, Geert Uytterhoeven wrote:
> On Thu, Jun 27, 2013 at 10:12 PM, Kevin Hilman <khilman@linaro.org> wrote:
> > commit 1affee67 (lib: Move fonts from drivers/video/console/ to lib/fonts/)
> > moved fonts from drivers/video/console/ to lib/fonts, but the ARM zImage
> > build still references the old location.
> >
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Olof Johansson <olof@lixom.net>
> > Signed-off-by: Kevin Hilman <khilman@linaro.org>
> > ---
> > Found due to build failures on ARM in next-20130627.
> >
> > Rather than go through the ARM tree, this should probably be included
> > with the original series from Geert.
> 
> Thanks! Sorry for missing this.
> 
> There's a similar one in the unicore32 boot code, and a few stale references
> in comments and documentation. I'll fold all of these in the original commit.

I ammended it with the below, and pushed it out.

[Kevin Hilman <khilman@linaro.org>: Update arch/arm/boot/compressed/Makefile]

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index c36892c..fca3419 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -297,10 +297,10 @@ KAO -->
      </sect1>
      <sect1><title>Frame Buffer Fonts</title>
         <para>
-           Refer to the file drivers/video/console/fonts.c for more information.
+           Refer to the file lib/fonts/fonts.c for more information.
         </para>
 <!-- FIXME: Removed for now since no structured comments in source
-X!Idrivers/video/console/fonts.c
+X!Ilib/fonts/fonts.c
 -->
      </sect1>
   </chapter>
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 120b83b..48d0a44 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -27,7 +27,7 @@ OBJS	+= misc.o decompress.o
 ifeq ($(CONFIG_DEBUG_UNCOMPRESS),y)
 OBJS	+= debug.o
 endif
-FONTC	= $(srctree)/drivers/video/console/font_acorn_8x8.c
+FONTC	= $(srctree)/lib/fonts/font_acorn_8x8.c
 
 # string library code (-Os is enforced to keep it much smaller)
 OBJS		+= string.o
diff --git a/arch/m68k/kernel/asm-offsets.c b/arch/m68k/kernel/asm-offsets.c
index a972b00..8b7b228 100644
--- a/arch/m68k/kernel/asm-offsets.c
+++ b/arch/m68k/kernel/asm-offsets.c
@@ -77,7 +77,7 @@ int main(void)
 	DEFINE(BIR_SIZE, offsetof(struct bi_record, size));
 	DEFINE(BIR_DATA, offsetof(struct bi_record, data));
 
-	/* offsets into font_desc (drivers/video/console/font.h) */
+	/* offsets into the font_desc struct */
 	DEFINE(FONT_DESC_IDX, offsetof(struct font_desc, idx));
 	DEFINE(FONT_DESC_NAME, offsetof(struct font_desc, name));
 	DEFINE(FONT_DESC_WIDTH, offsetof(struct font_desc, width));
diff --git a/arch/unicore32/boot/compressed/Makefile b/arch/unicore32/boot/compressed/Makefile
index 950a9af..96494fb 100644
--- a/arch/unicore32/boot/compressed/Makefile
+++ b/arch/unicore32/boot/compressed/Makefile
@@ -17,7 +17,7 @@ OBJS		:= misc.o
 
 # font.c and font.o
 CFLAGS_font.o	:= -Dstatic=
-$(obj)/font.c: $(srctree)/drivers/video/console/font_8x8.c
+$(obj)/font.c: $(srctree)/lib/fonts/font_8x8.c
 	$(call cmd,shipped)
 
 # piggy.S and piggy.o
diff --git a/lib/fonts/fonts.c b/lib/fonts/fonts.c
index d0c03fd..f947189 100644
--- a/lib/fonts/fonts.c
+++ b/lib/fonts/fonts.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/video/fonts.c -- `Soft' font definitions
+ * `Soft' font definitions
  *
  *    Created 1995 by Geert Uytterhoeven
  *    Rewritten 1998 by Martin Mares <mj@ucw.cz>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
