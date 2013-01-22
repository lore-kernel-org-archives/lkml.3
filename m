Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab3AVTqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 14:46:46 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:47401 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3AVTqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 14:46:44 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Jamie Lentin <jm@lentin.co.uk>, Jean-Francois Moine <moinejf@free.fr>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: kirkwood: fix missing #interrupt-cells property
Date: Tue, 22 Jan 2013 20:46:33 +0100
Message-Id: <1358883993-17280-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio controller on kirkwood can provide interrupts but is missing
the #interrupt-cells property. This patch just adds it to both gpio
controllers.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jamie Lentin <jm@lentin.co.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/kirkwood.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
index 110d6cb..d6ab442 100644
--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -36,6 +36,7 @@
 			reg = <0x10100 0x40>;
 			ngpios = <32>;
 			interrupt-controller;
+			#interrupt-cells = <2>;
 			interrupts = <35>, <36>, <37>, <38>;
 		};
 
@@ -46,6 +47,7 @@
 			reg = <0x10140 0x40>;
 			ngpios = <18>;
 			interrupt-controller;
+			#interrupt-cells = <2>;
 			interrupts = <39>, <40>, <41>;
 		};
 
-- 
1.7.10.4

