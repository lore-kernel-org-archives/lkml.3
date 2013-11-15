Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab3KOOUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:20:41 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:48506 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3KOOUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:20:36 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: kirkwood: mark guruplug sdio as non-removable
Date: Fri, 15 Nov 2013 15:20:25 +0100
Message-Id: <1384525225-591-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1384525225-591-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1384525225-591-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Globalscale Guruplug has AW-GH381 WiFi/BT on sdio which is always
present and cannot be detected in any way. Therefore, mark the node
as non-removable instead of broken-cd. While at it, also put a note
about connected WiFi/BT chip above.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: devicetree@vger.kernel.org 
Cc: linux-arm-kernel@lists.infradead.org 
Cc: linux-kernel@vger.kernel.org 
---
 .../arm/boot/dts/kirkwood-guruplug-server-plus.dts |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts b/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
index 6548b9d..4ebe720 100644
--- a/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
+++ b/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
@@ -65,10 +65,10 @@
 			nr-ports = <1>;
 		};
 
+		/* AzureWave AW-GH381 WiFi/BT */
 		mvsdio@90000 {
 			status = "okay";
-			/* No CD or WP GPIOs */
-			broken-cd;
+			non-removable;
 		};
 	};
 
-- 
1.7.2.5

