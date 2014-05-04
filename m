Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbaEDQ7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:59:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaEDPlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 016/158] ARM: Fix default CPU selection for ARCH_MULTI_V5
Date: Sun,  4 May 2014 11:38:45 -0400
Message-Id: <20140504154032.258318329@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit 12567bbdee7ea553237085a2bbc0ffa5240f5248 upstream.

CPU_ARM926T should be selected if no other CPU is. Put the ! in the
right place so this works.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Fixes: 24e860fbfdb1c ("ARM: multiplatform: always pick one CPU type")
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -898,7 +898,7 @@ config ARCH_MULTI_V5
 	bool "ARMv5 based platforms (ARM926T, XSCALE, PJ1, ...)"
 	depends on !ARCH_MULTI_V6_V7
 	select ARCH_MULTI_V4_V5
-	select CPU_ARM926T if (!CPU_ARM946E || CPU_ARM1020 || \
+	select CPU_ARM926T if !(CPU_ARM946E || CPU_ARM1020 || \
 		CPU_ARM1020E || CPU_ARM1022 || CPU_ARM1026 || \
 		CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_FEROCEON)
 


