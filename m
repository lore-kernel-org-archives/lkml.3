Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853AbaEMKkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:40:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60757 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760024AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 017/182] ARM: Fix default CPU selection for ARCH_MULTI_V5
Date: Tue, 13 May 2014 11:26:09 +0200
Message-Id: <efc93dcf1cec913f9e4f97264b6457ff63716dfd.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 12567bbdee7ea553237085a2bbc0ffa5240f5248 upstream.

CPU_ARM926T should be selected if no other CPU is. Put the ! in the
right place so this works.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Fixes: 24e860fbfdb1c ("ARM: multiplatform: always pick one CPU type")
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ad6fb6c094d..e47fcd1e9645 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -892,7 +892,7 @@ config ARCH_MULTI_V5
 	bool "ARMv5 based platforms (ARM926T, XSCALE, PJ1, ...)"
 	depends on !ARCH_MULTI_V6_V7
 	select ARCH_MULTI_V4_V5
-	select CPU_ARM926T if (!CPU_ARM946E || CPU_ARM1020 || \
+	select CPU_ARM926T if !(CPU_ARM946E || CPU_ARM1020 || \
 		CPU_ARM1020E || CPU_ARM1022 || CPU_ARM1026 || \
 		CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_FEROCEON)
 
-- 
1.9.3

