Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3F0MfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:35:18 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:24793
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819Ab3F0MfQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:35:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzc89bhzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h93fhd24he5bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>
To: <linux-next@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <trivial@kernel.org>
Subject: [PATCH linux-next] videomode: fix compilation warning
Date: Thu, 27 Jun 2013 14:34:57 +0200
Message-ID: <1372336497-2005-1-git-send-email-vincent.stehle@freescale.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing include file to fix the following compilation warning:

  In file included from drivers/video/wm8505fb.c:35:0:
  include/video/of_display_timing.h:18:10: warning: ‘struct display_timing’ declared inside parameter list [enabled by default]
  include/video/of_display_timing.h:18:10: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: trivial@kernel.org
---


Hi,

This warning happens on linux-next tag next-20130627, for ARM multi_v7_defconfig.

Best regards,

V.


 include/video/of_display_timing.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/video/of_display_timing.h b/include/video/of_display_timing.h
index 6562ad9..d43be98 100644
--- a/include/video/of_display_timing.h
+++ b/include/video/of_display_timing.h
@@ -9,6 +9,8 @@
 #ifndef __LINUX_OF_DISPLAY_TIMING_H
 #define __LINUX_OF_DISPLAY_TIMING_H
 
+#include <video/display_timing.h>
+
 struct device_node;
 struct display_timings;
 
-- 
1.7.10.4



