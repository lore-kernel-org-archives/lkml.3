Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab3GMUJy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 16:09:54 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:58256 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758074Ab3GMUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 16:09:53 -0400
Message-ID: <1373746191.1359.37.camel@x61.thuisdomein>
Subject: [PATCH] ARM: multiplatform: remove reference to ARCH_MULTI_V4
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Sat, 13 Jul 2013 22:09:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2013 20:09:51.0790 (UTC) FILETIME=[EEF9DCE0:01CE8004]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol ARCH_MULTI_V4 was removed in commit 24e860fbfd
("ARM: multiplatform: always pick one CPU type"). Remove the last
reference to it too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) Commit 24e860fbfd is silent on the reason to drop ARCH_MULTI_V4. And
the ARM section of the Kconfig files is rather complicated for people,
like me, that aren't familiar with the way the ARM universe is divided
in architectures, machines, platforms, etc. That makes it hard to say
whether ARCH_MULTI_V4 was dropped on purpose or by accident.

 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 0ac9be6..0746bc8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -912,7 +912,7 @@ config ARCH_MULTI_V6_V7
 	bool
 
 config ARCH_MULTI_CPU_AUTO
-	def_bool !(ARCH_MULTI_V4 || ARCH_MULTI_V4T || ARCH_MULTI_V6_V7)
+	def_bool !(ARCH_MULTI_V4T || ARCH_MULTI_V6_V7)
 	select ARCH_MULTI_V5
 
 endmenu
-- 
1.8.1.4

