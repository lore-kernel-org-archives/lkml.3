Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab3CAUvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:51:12 -0500
Received: from mail-ve0-f202.google.com ([209.85.128.202]:49455 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab3CAUvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 15:51:11 -0500
From: Doug Anderson <dianders@chromium.org>
To: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Remove VFP debug spew
Date: Fri,  1 Mar 2013 12:46:52 -0800
Message-Id: <1362170812-31048-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit e36815e2e4a2fb675207d8968bb68e22bc938328:
  ARM: Fix broken commit 0cc41e4a21d43 corrupting kernel messages

...a "#define DEBUG" line was accidentally left in.  This has the side
effect of spewing massive numbers of debug messages into the log at
boot.  Remove the DEBUG define.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Note: The commit in question is only on linux-next.

 arch/arm/vfp/vfphw.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index 20c8dd7..8d10dc8 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -19,7 +19,6 @@
 #include <linux/kern_levels.h>
 #include "../kernel/entry-header.S"
 
-#define DEBUG
 	.macro	DBGSTR, str
 #ifdef DEBUG
 	stmfd	sp!, {r0-r3, ip, lr}
-- 
1.8.1.3

