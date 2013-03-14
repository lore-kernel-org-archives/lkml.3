Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3CNV46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:56:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65479 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3CNV4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:56:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] [media] ir: IR_RX51 only works on OMAP2
Date: Thu, 14 Mar 2013 22:56:44 +0100
Message-Id: <1363298204-8014-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363298204-8014-1-git-send-email-arnd@arndb.de>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:azUisV1g9iGoL0f1+UCiVUOKKVQlaFe3n5RRcJ0uWlH
 c0gSVRzKZ9pRsvy5KtrG9tc5UqBOHwbasxT5fihnnzC+khXDve
 py+CR9zzqUJozHgdPvZWKV52cTDMiZun8aBcr3b/MvPDc+7BUR
 Q5Ic/vRV1q61j2Ncu8Ar3Shl8p6/BRP7OoWTaab46vufX0Xd5R
 Kx/5GsTK5lcOE/yvjjMQBUQ/sE+FTt41UjHXaVPKdwJ4ixSyZN
 rY9bnCmV4HZkaaJ9j9fDCsFRe6yTlqOysMRqO+ulW2l5JjG7kJ
 9s//pWqa66Odz0RilRp1yBkjyHgicif5vx6N8bpvRCx3DcATdl
 4718oOfJoBt6nAMK+ANgWNvpWAjnYgrJ4mpYXrFBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can be enabled on OMAP1 at the moment, which breaks
allyesconfig for that platform. Let's mark it OMAP2PLUS-only
in Kconfig, since that is the only thing it builds on.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
---
Mauro, please apply for 3.9

 drivers/media/rc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 19f3563..5a79c33 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -291,7 +291,7 @@ config IR_TTUSBIR
 
 config IR_RX51
 	tristate "Nokia N900 IR transmitter diode"
-	depends on OMAP_DM_TIMER && LIRC && !ARCH_MULTIPLATFORM
+	depends on OMAP_DM_TIMER && ARCH_OMAP2PLUS && LIRC && !ARCH_MULTIPLATFORM
 	---help---
 	   Say Y or M here if you want to enable support for the IR
 	   transmitter diode built in the Nokia N900 (RX51) device.
-- 
1.8.1.2

