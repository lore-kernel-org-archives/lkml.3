Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab3DYR3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:29:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54981 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab3DYR3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 04/21] ARM: orion5x: include linux/cpu.h
Date: Thu, 25 Apr 2013 19:28:47 +0200
Message-Id: <1366910944-3033663-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:lpnv92qTG/YrEk+qX8echo7CFLpWATmQBhFJIZRw44v
 LulxWNHa+1XWg952Oh6hV46ywsITdI6+9abPN2bOpilAMDCf7P
 wuqomvtd87tDzQc899v3IhcC2n0mxuC6p9Vkb6BwU7Y1+3KmzT
 SfgAFY+m2PRkxj+GwzAsFs6Cqiv6yIhbWcckvkEuaNuhLQJ59m
 ox4oV6kZI1xnYu/4Og8kFrnkBSlBYmJ1kTx8SU0KLkDneVofDj
 upiqLrcSY8gg3YnieOtoRvVBZRrDfPpJKPTgAupBOVliFxO664
 OHKZabA2c9YL+rhsnAb2awC2UCJhfk5zemKCamtI8a+cRafP4d
 yK2gE6Gc99MmdZ6kvQvZEHlys9JNS7dx+RzHGiNMd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linux/cpu.h header is no longer implictly included in this
file, so we need to an #include statement to avoid this build
warning:

arch/arm/mach-orion5x/common.c:339:3: error: implicit declaration of function 'cpu_idle_poll_ctrl' [-Werror=implicit-function-declaration]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-orion5x/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 664c97d..b97fd67 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -19,6 +19,7 @@
 #include <linux/ata_platform.h>
 #include <linux/delay.h>
 #include <linux/clk-provider.h>
+#include <linux/cpu.h>
 #include <net/dsa.h>
 #include <asm/page.h>
 #include <asm/setup.h>
-- 
1.8.1.2

