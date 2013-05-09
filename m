Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3EIVFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 17:05:14 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:34592 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3EIVFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 17:05:08 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 12/12] staging: COMEDI should depend on HAS_DMA
Date: Thu,  9 May 2013 23:04:54 +0200
Message-Id: <1368133494-22198-12-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
References: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

ERROR: "dma_free_coherent" [drivers/staging/comedi/comedi.ko] undefined!
ERROR: "dma_alloc_coherent" [drivers/staging/comedi/comedi.ko] undefined!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/comedi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 7871579..ed2e769 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -1,6 +1,6 @@
 config COMEDI
 	tristate "Data acquisition support (comedi)"
-	depends on m
+	depends on m && HAS_DMA
 	---help---
 	  Enable support a wide range of data acquisition devices
 	  for Linux.
-- 
1.7.0.4

