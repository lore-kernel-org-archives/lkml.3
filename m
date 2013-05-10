Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3EJUMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 16:12:42 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:53646 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab3EJUMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 16:12:40 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: plat-orion: add missing ehci include to common.h
Date: Fri, 10 May 2013 22:12:27 +0200
Message-Id: <1368216747-28898-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing orion ehci include from board files will raise a compiler
error because plat/common.h is using an enum provided by orion ehci
but not including the include itself. This just adds the missing include.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/plat-orion/include/plat/common.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/plat-orion/include/plat/common.h b/arch/arm/plat-orion/include/plat/common.h
index e06fc5f..d9a24f6 100644
--- a/arch/arm/plat-orion/include/plat/common.h
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -10,6 +10,7 @@
 
 #ifndef __PLAT_COMMON_H
 #include <linux/mv643xx_eth.h>
+#include <linux/platform_data/usb-ehci-orion.h>
 
 struct dsa_platform_data;
 struct mv_sata_platform_data;
-- 
1.7.10.4

