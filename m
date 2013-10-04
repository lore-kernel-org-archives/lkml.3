Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3JDH52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 03:57:28 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60055 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3JDH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 03:57:26 -0400
Date: Fri, 4 Oct 2013 09:57:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20131004075722.GA14194@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 29d274b8d3e2404cd1832b3a999b12f9d1e1d895 x86/simplefb: Mark framebuffer mem-resources as IORESOURCE_BUSY to avoid bootup warning

Two simplefb fixes.

 Thanks,

	Ingo

------------------>
David Herrmann (1):
      x86/simplefb: Mark framebuffer mem-resources as IORESOURCE_BUSY to avoid bootup warning

Tom Gundersen (1):
      x86/simplefb: Fix overflow causing bogus fall-back


 arch/x86/kernel/sysfb_simplefb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 22513e9..86179d4 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -72,14 +72,14 @@ __init int create_simplefb(const struct screen_info *si,
 	 * the part that is occupied by the framebuffer */
 	len = mode->height * mode->stride;
 	len = PAGE_ALIGN(len);
-	if (len > si->lfb_size << 16) {
+	if (len > (u64)si->lfb_size << 16) {
 		printk(KERN_WARNING "sysfb: VRAM smaller than advertised\n");
 		return -EINVAL;
 	}
 
 	/* setup IORESOURCE_MEM as framebuffer memory */
 	memset(&res, 0, sizeof(res));
-	res.flags = IORESOURCE_MEM;
+	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	res.name = simplefb_resname;
 	res.start = si->lfb_base;
 	res.end = si->lfb_base + len - 1;
