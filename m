Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbbA2BxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:53:16 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:64907 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbbA2BxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:53:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 7/7] [media] marvell-ccic needs VIDEOBUF2_DMA_SG
Date: Wed, 28 Jan 2015 22:17:47 +0100
Message-Id: <1422479867-3370921-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 2.1.0.rc2
In-Reply-To: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
References: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V03:K0:/hMT7EQvmjXAEO+Pd3YwbO4Kk4mAbyhOgNzQhhpVe0DIg3d/duI
 vFgf5L/U02PdoKBRKWFwdSH4GoXYG7Whw3ULyzCpIUPQAC/Z+YgqMZQCablDCU2SOrr7UCv
 xN5XFzwLe4MKR6pcgKv6OkcQqD0McShVn0XCY/+Fz2XSXHvLmwcrd3xSt9BRp6AQW0516bI
 erVvYTQDhUp2S5q8lOI3g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vb2_dma_sg_memops pointer is only valid if VIDEOBUF2_DMA_SG is
set, so we should select that to avoid this build error:

drivers/built-in.o: In function `mcam_v4l_open':
:(.text+0x388d00): undefined reference to `vb2_dma_sg_memops'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/platform/marvell-ccic/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index 7ac0f13c98be..4bf5bd1e90d6 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -5,6 +5,7 @@ config VIDEO_CAFE_CCIC
 	select VIDEO_OV7670
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_DMA_SG
 	---help---
 	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
 	  CMOS camera controller.  This is the controller found on first-
-- 
2.1.0.rc2

