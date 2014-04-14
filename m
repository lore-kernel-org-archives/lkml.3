Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaDNPao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:30:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaDNPam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:30:42 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, paulus@samba.org
Cc: linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: [PATCH 1/1] powerpc: Increase COMMAND_LINE_SIZE to 2048 from 512.
Date: Mon, 14 Apr 2014 11:30:33 -0400
Message-Id: <84356b1cb9452226d54641a71e4b1363e78d4417.1397260362.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1397260361.git.joseph.salisbury@canonical.com>
References: <cover.1397260361.git.joseph.salisbury@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1306677

While booting the PPC64EL kernel, the command line gets truncated to 512 characters. This is due to a hard limit of 512 defined for COMMAND_LINE_SIZE.  It would be beneficial to have a command line longer than 512 characters, as iscsi targets and cloud-init parameters are passed through the kernel command line.

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org> (supporter:LINUX FOR POWERPC...)
Cc: Paul Mackerras <paulus@samba.org> (supporter:LINUX FOR POWERPC...)
Cc: linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...)
Cc: linux-kernel@vger.kernel.org (open list)
Cc: stable@vger.kernel.org

---
 arch/powerpc/boot/ops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/ops.h b/arch/powerpc/boot/ops.h
index b3218ce..5a01fb1 100644
--- a/arch/powerpc/boot/ops.h
+++ b/arch/powerpc/boot/ops.h
@@ -15,7 +15,7 @@
 #include "types.h"
 #include "string.h"
 
-#define	COMMAND_LINE_SIZE	512
+#define	COMMAND_LINE_SIZE	2048	
 #define	MAX_PATH_LEN		256
 #define	MAX_PROP_LEN		256 /* What should this be? */
 
-- 
1.7.9.5

