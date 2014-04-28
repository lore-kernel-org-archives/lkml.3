Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbaD1VLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:11:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46238 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbaD1VLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:11:34 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, paulus@samba.org
Cc: linuxppc-dev@lists.ozlabs.org, anton@samba.org
Subject: [PATCH 3/3][RFC][v1] powerpc: kconfig: Increase the size of COMMAND_LINE_SIZE to 2048 from 512 for powerpc.
Date: Mon, 28 Apr 2014 17:11:25 -0400
Message-Id: <2640a93711258c5a6e72e7fed8f89ddd25504d5b.1398287637.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1398287636.git.joseph.salisbury@canonical.com>
References: <cover.1398287636.git.joseph.salisbury@canonical.com>
In-Reply-To: <cover.1398287636.git.joseph.salisbury@canonical.com>
References: <cover.1398287636.git.joseph.salisbury@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1306677

While booting the PPC64EL kernel, the command line gets truncated to 512 characters. This is due to a limit of 512 defined for COMMAND_LINE_SIZE.  It would be beneficial to have a command line longer than 512 characters, as iscsi targets and cloud-init parameters are passed through the kernel command line.

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
---
 arch/powerpc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 3426bdc..becee70 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -614,7 +614,7 @@ config CMDLINE_BOOL
 
 config COMMAND_LINE_SIZE
         int "Maximum size of the command line."
-        default "512"
+        default "2048"
         help
         This is the per architecture maximum command line size.
 
-- 
1.9.1

