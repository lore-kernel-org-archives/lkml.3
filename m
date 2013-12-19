Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab3LSWm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:42:57 -0500
Received: from mail-yh0-f74.google.com ([209.85.213.74]:45192 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3LSWmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:42:54 -0500
From: Doug Anderson <dianders@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Simon Glass <sjg@chromium.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Olof Johansson <olof@lixom.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ARM: dts: Fix exynos5250-snow's search key to be L_META
Date: Thu, 19 Dec 2013 14:36:18 -0800
Message-Id: <1387492578-22068-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387492578-22068-1-git-send-email-dianders@chromium.org>
References: <1387492578-22068-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree sent upstream for exynos5250-snow encoded the search
key as CAPSLK.  However in all ChromeOS kernels it is L_META.  One can
certainly have long debates about which it ought to be, but I'm
proposing setting it to L_META because:
* That's how _all_ ChromeOS kernels do it and will do it.
* There is no L_META key on the board, so it's nice to have.
* For those people who really want it to be caps lock, they can use
  xmodmap or somesuch.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/exynos5250-snow.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 28fe2e2..c65f52a 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -85,7 +85,7 @@
 				        keypad,num-rows = <8>;
 				        keypad,num-columns = <13>;
 				        google,needs-ghost-filter;
-					linux,keymap = <0x0001003a	/* CAPSLK */
+					linux,keymap = <0x0001007d	/* L_META */
 							0x0002003b	/* F1 */
 							0x00030030	/* B */
 							0x00040044	/* F10 */
-- 
1.8.5.1

