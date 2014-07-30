Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbaG3Btm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:49:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbaG3Btk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 01/29] media: staging: tighten omap4iss dependencies
Date: Tue, 29 Jul 2014 18:48:36 -0700
Message-Id: <20140730014809.372121459@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014809.316066303@linuxfoundation.org>
References: <20140730014809.316066303@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 4856fbd12d69965d3ab680c686222db93872728d upstream.

The OMAP4 camera support depends on I2C and VIDEO_V4L2, both
of which can be loadable modules. This causes build failures
if we want the camera driver to be built-in.

This can be solved by turning the option into "tristate",
which unfortunately causes another problem, because the
driver incorrectly calls a platform-internal interface
for omap4_ctrl_pad_readl/omap4_ctrl_pad_writel.

Instead, this patch just forbids the invalid configurations
and ensures that the driver can only be built if all its
dependencies are built-in.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/omap4iss/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/media/omap4iss/Kconfig
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_OMAP4
 	bool "OMAP 4 Camera support"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && I2C && ARCH_OMAP4
+	depends on VIDEO_V4L2=y && VIDEO_V4L2_SUBDEV_API && I2C=y && ARCH_OMAP4
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Driver for an OMAP 4 ISS controller.


