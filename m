Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbaAHND1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:03:27 -0500
Received: from mail-ae1-f8.auone-net.jp ([106.187.231.8]:53814 "EHLO
	dmta02.auone-net.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755969AbaAHNDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:03:24 -0500
Date: Wed, 8 Jan 2014 22:03:22 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-trace-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] trace-cmd: Fix out-of-tree build
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <52cd4c9a000b471b000025a100006084180007d8d2e1@amlmta302.auone-net.jp>
X-MXM-DELIVERY-TYPE: 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make O=foo fails with following error:

.../Makefile:221: features.mk: No such file or directory
make[1]: *** No rule to make target `features.mk'.  Stop.
make: *** [sub-make] Error 2

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 0578546..b967019 100644
--- a/Makefile
+++ b/Makefile
@@ -218,7 +218,7 @@ KERNELSHARK_VERSION = $(KS_VERSION).$(KS_PATCHLEVEL).$(KS_EXTRAVERSION)
 
 INCLUDES = -I. $(CONFIG_INCLUDES)
 
-include features.mk
+include $(src)/features.mk
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -Wall
-- 
1.8.5.2

