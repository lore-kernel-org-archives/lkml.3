Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaIISyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:54:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48052 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaIISyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:54:17 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCHv3 1/3] [media] disable OMAP1 COMPILE_TEST
Date: Tue,  9 Sep 2014 15:54:04 -0300
Message-Id: <5f850d5d45a27c50dabf3da08689cbedf986841b.1410288748.git.m.chehab@samsung.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
References: <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver depends on a legacy OMAP DMA API. So, it won't
compile-test on other archs.

While we might add stubs to the functions, this is not a
good idea, as the hole API should be replaced.

So, for now, let's just remove COMPILE_TEST and wait for
some time for people to fix. If not fixed, then we'll end
by removing this driver as a hole.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index 6af6c6dccda8..f2776cd415ca 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -63,7 +63,7 @@ config VIDEO_SH_MOBILE_CEU
 config VIDEO_OMAP1
 	tristate "OMAP1 Camera Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA
-	depends on ARCH_OMAP1 || COMPILE_TEST
+	depends on ARCH_OMAP1
 	depends on HAS_DMA
 	select VIDEOBUF_DMA_CONTIG
 	select VIDEOBUF_DMA_SG
-- 
1.9.3

