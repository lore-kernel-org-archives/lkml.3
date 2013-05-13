Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3EMKjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:39:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56211 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3EMKjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:39:18 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] drivers/staging: davinci: vpfe: fix dependency for building the driver
Date: Mon, 13 May 2013 16:09:07 +0530
Message-Id: <1368441547-6078-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

from commit 3778d05036cc7ddd983ae2451da579af00acdac2
[media: davinci: kconfig: fix incorrect selects]
VIDEO_VPFE_CAPTURE was removed but there was a negative
dependancy for building the DM365 VPFE MC based capture driver
(VIDEO_DM365_VPFE), This patch fixes this dependency by replacing
the VIDEO_VPFE_CAPTURE with VIDEO_DM365_ISIF, so as when older DM365
ISIF v4l driver is selected the newer media controller driver for
DM365 isnt visible.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/staging/media/davinci_vpfe/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/Kconfig b/drivers/staging/media/davinci_vpfe/Kconfig
index 2e4a28b..12f321d 100644
--- a/drivers/staging/media/davinci_vpfe/Kconfig
+++ b/drivers/staging/media/davinci_vpfe/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_DM365_VPFE
 	tristate "DM365 VPFE Media Controller Capture Driver"
-	depends on VIDEO_V4L2 && ARCH_DAVINCI_DM365 && !VIDEO_VPFE_CAPTURE
+	depends on VIDEO_V4L2 && ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF
 	select VIDEOBUF2_DMA_CONTIG
 	help
 	  Support for DM365 VPFE based Media Controller Capture driver.
-- 
1.7.4.1

