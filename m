Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3GAJv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:51:26 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:42529 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab3GAJvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:51:25 -0400
Date: Mon, 1 Jul 2013 11:51:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/boot change for v3.11
Message-ID: <20130701095121.GA16701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-boot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-boot-for-linus

   HEAD: 062f487190c8126209391ccb720a4ec943fd4a57 x86/boot: Close opened file descriptor

Small fixlet for the build process.

 Thanks,

	Ingo

------------------>
Jiri Slaby (1):
      x86/boot: Close opened file descriptor


 arch/x86/boot/tools/build.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 94c5446..c941d6a 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -243,6 +243,7 @@ static void parse_zoffset(char *fname)
 	c = fread(buf, 1, sizeof(buf) - 1, file);
 	if (ferror(file))
 		die("read-error on `zoffset.h'");
+	fclose(file);
 	buf[c] = 0;
 
 	p = (char *)buf;
