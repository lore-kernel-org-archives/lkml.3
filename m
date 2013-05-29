Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024Ab3E2Hzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:55:51 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:51960 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964885Ab3E2Hzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:55:49 -0400
Message-ID: <1369814147.23034.9.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Fix error typo "CONFIG_START_KERNEL"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 May 2013 09:55:47 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2013 07:55:48.0171 (UTC) FILETIME=[EE5831B0:01CE5C41]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Please note that a quick scan of this code suggests that the
preceding test should read
    #if (CONFIG_LOWMEM_SIZE > (0xF0000000 - CONFIG_KERNEL_START))

But this fix is correct anyhow.

 arch/powerpc/mm/init_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index 01e2db9..d47d3da 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -52,7 +52,7 @@
 #if defined(CONFIG_KERNEL_START_BOOL) || defined(CONFIG_LOWMEM_SIZE_BOOL)
 /* The amount of lowmem must be within 0xF0000000 - KERNELBASE. */
 #if (CONFIG_LOWMEM_SIZE > (0xF0000000 - PAGE_OFFSET))
-#error "You must adjust CONFIG_LOWMEM_SIZE or CONFIG_START_KERNEL"
+#error "You must adjust CONFIG_LOWMEM_SIZE or CONFIG_KERNEL_START"
 #endif
 #endif
 #define MAX_LOW_MEM	CONFIG_LOWMEM_SIZE
-- 
1.7.11.7

