Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaBCS3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:29:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37747 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbaBCS3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:29:47 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: X86 ML <x86@kernel.org>, Richard Weinberger <richard@nod.at>,
        Borislav Petkov <bp@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Clarify CONFIG_DEBUG_INFO's bloaty nature
Date: Mon,  3 Feb 2014 19:29:43 +0100
Message-Id: <1391452183-2160-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hold down when it makes sense to enable CONFIG_DEBUG_INFO and when
CONFIG_KALLSYMS suffices.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/CA%2B55aFw_xs1tUteDrXz21QZB7BFk5p%2BF5NZ-SpV=CUVjeFwapA@mail.gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 lib/Kconfig.debug | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dbf94a7d25a8..9095c2078095 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -126,7 +126,11 @@ config DEBUG_INFO
 	  This adds debug symbols to the kernel and modules (gcc -g), and
 	  is needed if you intend to use kernel crashdump or binary object
 	  tools like crash, kgdb, LKCD, gdb, etc on the kernel.
-	  Say Y here only if you plan to debug the kernel.
+
+	  If you only want to have resolved symbols in kernel traces and
+	  are not going to need support for those tools above, you don't need
+	  to enable this as it is a huge bloat and build slowdown;
+	  enable CONFIG_KALLSYMS instead.
 
 	  If unsure, say N.
 
-- 
1.8.5.2.192.g7794a68

