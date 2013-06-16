Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab3FPUHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 16:07:08 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48639 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab3FPUGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 16:06:41 -0400
From: ddaney.cavm@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com
Cc: david.s.daney@gmail.com, David Daney <ddaney@caviumnetworks.com>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH 1/2] ia64: Fix include dependency in asm/irqflags.h
Date: Sun, 16 Jun 2013 13:06:28 -0700
Message-Id: <1371413189-2568-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1371413189-2568-1-git-send-email-ddaney.cavm@gmail.com>
References: <1371413189-2568-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>

asm/kregs.h isn't always included first, so we need an explicit include.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/ia64/include/asm/irqflags.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/include/asm/irqflags.h b/arch/ia64/include/asm/irqflags.h
index 1bf2cf2..cec6c06 100644
--- a/arch/ia64/include/asm/irqflags.h
+++ b/arch/ia64/include/asm/irqflags.h
@@ -11,6 +11,7 @@
 #define _ASM_IA64_IRQFLAGS_H
 
 #include <asm/pal.h>
+#include <asm/kregs.h>
 
 #ifdef CONFIG_IA64_DEBUG_IRQ
 extern unsigned long last_cli_ip;
-- 
1.7.11.7

