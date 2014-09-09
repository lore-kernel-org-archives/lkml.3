Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbaIIGQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:16:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaIIGQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:16:10 -0400
Message-ID: <1410243346.3389.7.camel@nilsson.home.kraxel.org>
Subject: Re: [coreboot] [PATCH] x86: add coreboot framebuffer support
From: Gerd Hoffmann <kraxel@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vladimir =?UTF-8?Q?=27=CF=86-coder/phcoder=27?= Serbinenko 
	<phcoder@gmail.com>,
        ron minnich <rminnich@gmail.com>, coreboot <coreboot@coreboot.org>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 09 Sep 2014 08:15:46 +0200
In-Reply-To: <540A2FB4.6060605@zytor.com>
References: <1409826307-23075-1-git-send-email-kraxel@redhat.com>
		<540A17A6.1000802@zytor.com>	<540A266F.80503@gmail.com>
	 <CAP6exYJj8Fupa1uTLRP5uGoWNjvwKo7bAAPvYmzUYB=AOqOq8g@mail.gmail.com>
	 <540A29E6.2080405@gmail.com> <540A2B9A.1070707@zytor.com>
	 <540A2DD1.1040002@gmail.com> <540A2FB4.6060605@zytor.com>
Content-Type: multipart/mixed; boundary="=-hMOnEh5SBrPpicfp0eCC"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hMOnEh5SBrPpicfp0eCC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

  Hi,

> > Yes, efifb has the same semantics. We just need some ID with clear 
> > documentation saying sth like "implies framebuffer without
> > anything else" so that noone will get an idea to plug e.g. vga
> > hooks into it.
> > 
> 
> Want to make a patch?

Attached.  Can someone test with the patched coreboot trampoline please?

cheers,
  Gerd


--=-hMOnEh5SBrPpicfp0eCC
Content-Disposition: attachment; filename="0001-Add-VIDEO_TYPE_LINEAR.patch"
Content-Type: text/x-patch; name="0001-Add-VIDEO_TYPE_LINEAR.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From cadf8315cb5d76a89a1b84e7ea22565f6b1945dc Mon Sep 17 00:00:00 2001
From: Gerd Hoffmann <kraxel@redhat.com>
Date: Tue, 9 Sep 2014 08:10:09 +0200
Subject: [PATCH] Add VIDEO_TYPE_LINEAR

Add VIDEO_TYPE_LINEAR for a simple linear framebuffer,
initialized by the firmware (for example coreboot).

Needs CONFIG_X86_SYSFB=y and CONFIG_FB_SIMPLE=y to work.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/kernel/sysfb_simplefb.c | 4 +++-
 include/uapi/linux/screen_info.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 86179d4..0742c82 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -36,7 +36,9 @@ __init bool parse_mode(const struct screen_info *si,
 	unsigned int i;
 
 	type = si->orig_video_isVGA;
-	if (type != VIDEO_TYPE_VLFB && type != VIDEO_TYPE_EFI)
+	if (type != VIDEO_TYPE_VLFB &&
+	    type != VIDEO_TYPE_EFI &&
+	    type != VIDEO_TYPE_LINEAR)
 		return false;
 
 	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
diff --git a/include/uapi/linux/screen_info.h b/include/uapi/linux/screen_info.h
index 7530e74..d27126d 100644
--- a/include/uapi/linux/screen_info.h
+++ b/include/uapi/linux/screen_info.h
@@ -66,6 +66,8 @@ struct screen_info {
 
 #define VIDEO_TYPE_EFI		0x70	/* EFI graphic mode		*/
 
+#define VIDEO_TYPE_LINEAR	0x80	/* simple linear framebuffer	*/
+
 #define VIDEO_FLAGS_NOCURSOR	(1 << 0) /* The video mode has no cursor set */
 
 #define VIDEO_CAPABILITY_SKIP_QUIRKS	(1 << 0)
-- 
1.8.3.1


--=-hMOnEh5SBrPpicfp0eCC--

