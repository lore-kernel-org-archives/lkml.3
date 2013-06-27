Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3F0M0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:26:25 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:17014
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566Ab3F0M0X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:26:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzc89bhzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h93fhd24he5bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>
To: <linux-next@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>,
        Robin Holt <holt@sgi.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, <trivial@kernel.org>
Subject: [PATCH linux-next] ARM: OMAP2+: fix omap4-restart compilation
Date: Thu, 27 Jun 2013 14:26:00 +0200
Message-ID: <1372335961-31401-1-git-send-email-vincent.stehle@freescale.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following compilation error due to missing include file:

  arch/arm/mach-omap2/omap4-restart.c:21:28: warning: ‘enum reboot_mode’ declared inside parameter list [enabled by default]
  arch/arm/mach-omap2/omap4-restart.c:21:28: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
  arch/arm/mach-omap2/omap4-restart.c:21:40: error: parameter 1 (‘mode’) has incomplete type
  arch/arm/mach-omap2/omap4-restart.c:21:6: warning: function declaration isn’t a prototype [-Wstrict-prototypes]
  make[1]: *** [arch/arm/mach-omap2/omap4-restart.o] Error 1

Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: trivial@kernel.org
---


Hi,

This fixes the build of linux-next for arch ARM, config multi_v7_defconfig, tag
next-20130627.

Best regards,

V.


 arch/arm/mach-omap2/omap4-restart.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/omap4-restart.c b/arch/arm/mach-omap2/omap4-restart.c
index 652adde..41dfd7d 100644
--- a/arch/arm/mach-omap2/omap4-restart.c
+++ b/arch/arm/mach-omap2/omap4-restart.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/reboot.h>
 #include "prminst44xx.h"
 
 /**
-- 
1.7.10.4



