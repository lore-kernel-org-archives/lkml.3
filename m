Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbbADSAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 13:00:45 -0500
Received: from borg.tf-network.de ([62.75.218.204]:46024 "EHLO
	borg.tf-network.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbbADSAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 13:00:44 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2015 13:00:43 EST
From: Thomas D <whissi@whissi.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas D <whissi@whissi.de>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH] tools/power: turbostat: Use $(CURDIR) instead of $(PWD) in Makefile
Date: Sun,  4 Jan 2015 18:52:43 +0100
Message-Id: <1420393963-30645-1-git-send-email-whissi@whissi.de>
X-Mailer: git-send-email 2.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ee0778a30153 ("tools/power: turbostat: make Makefile a bit
more capable") turbostat’s Makefile is using

  [...]
  BUILD_OUTPUT    := $(PWD)
  [...]

which obviously causes trouble when building "turbostat" with

  make -C /usr/src/linux/tools/power/x86/turbostat ARCH=x86 turbostat

because GNU make doesn’t update nor guarantee that $PWD is set.

This patch changes the Makefile to use $CURDIR instead, which GNU make
guarantees to set and update (i.e. when using "make –C ...").

Link: https://bugs.gentoo.org/show_bug.cgi?id=533918
Fixes: ee0778a30153 ("tools/power: turbostat: make Makefile a bit more capable")
Signed-off-by: Thomas D. <whissi@whissi.de>
Cc: Mark Asselstine <mark.asselstine@windriver.com>
Cc: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/Makefile b/tools/power/x86/turbostat/Makefile
index d1b3a36..6dd4cad 100644
--- a/tools/power/x86/turbostat/Makefile
+++ b/tools/power/x86/turbostat/Makefile
@@ -1,5 +1,5 @@
 CC		= $(CROSS_COMPILE)gcc
-BUILD_OUTPUT	:= $(PWD)
+BUILD_OUTPUT	:= $(CURDIR)
 PREFIX		:= /usr
 DESTDIR		:=
 
-- 
2.2.1

