Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaKXMHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:07:51 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:63136 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbaKXMHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:07:49 -0500
Message-ID: <1416830865.10073.35.camel@x220>
Subject: [PATCH] [media] omap: Fix typo "HAS_MMU"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 24 Nov 2014 13:07:45 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2014 12:07:45.0610 (UTC) FILETIME=[41C252A0:01D007DF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 38a073116525 ("[media] omap: be sure that MMU is there for
COMPILE_TEST") added a dependency on HAS_MMU. There's no Kconfig symbol
HAS_MMU. Use MMU instead.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Perhaps it would have been better to add a line or two explaining why
MMU is now a separate dependency, as Mauro suggested.

Commit 38a073116525 tells us that "COMPILE_TEST fail[s] on (some) archs
without MMU". It doesn't tell on which architectures nor how it fails.
And I was unable to figure that out myself so I decided to stay silent
on that aspect of this patch.

1) A Fixes: line seems not worth the trouble here.

2) Tested on top of next-20141124 by doing, in short:
    cp arch/x86/configs/x86_64_defconfig .config
    echo CONFIG_COMPILE_TEST=y >> .config
    echo CONFIG_MEDIA_SUPPORT=y >> .config
    echo CONFIG_MEDIA_CAMERA_SUPPORT=y >> .config
    echo CONFIG_V4L_PLATFORM_DRIVERS=y >> .config
    echo CONFIG_VIDEO_OMAP2_VOUT=[ym] >> .config
    yes "" | make oldconfig

both before and after applying this patch and diffing the "before" and
"after" .config. Only with this patch I see CONFIG_VIDEO_OMAP2_VOUT=[ym]
appear in the .config.

3) Actually, I've wasted quite a bit of time cobbling together a script
to test commits locally. The test(s) I want to run is (are) saved in a
git note for that commit. The script parses this note and runs the
test(s).

Have I been reinventing the wheel?

 drivers/media/platform/omap/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
index 05de442d24e4..8f27cdadf8b8 100644
--- a/drivers/media/platform/omap/Kconfig
+++ b/drivers/media/platform/omap/Kconfig
@@ -3,7 +3,8 @@ config VIDEO_OMAP2_VOUT_VRFB
 
 config VIDEO_OMAP2_VOUT
 	tristate "OMAP2/OMAP3 V4L2-Display driver"
-	depends on ARCH_OMAP2 || ARCH_OMAP3 || (COMPILE_TEST && HAS_MMU)
+	depends on MMU
+	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_CONTIG
 	select OMAP2_DSS if HAS_IOMEM && ARCH_OMAP2PLUS
-- 
1.9.3

