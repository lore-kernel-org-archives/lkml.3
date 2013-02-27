Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451Ab3B0S1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:27:12 -0500
Received: from mail1.windriver.com ([147.11.146.13]:52448 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605Ab3B0S1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:27:10 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-fbdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH] video: make goldfish option have a dependency on goldfish
Date: Wed, 27 Feb 2013 13:26:56 -0500
Message-ID: <1361989616-1842-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nearly all the other goldfish peripherals (mtd, keyboard, etc)
have a dependency on the main platform's GOLDFISH Kconfig item,
but this one got skipped, so add it.

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/video/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 4c1546f..2df6d9c 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2208,7 +2208,7 @@ config FB_XILINX
 
 config FB_GOLDFISH
 	tristate "Goldfish Framebuffer"
-	depends on FB
+	depends on FB && GOLDFISH
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
1.8.1.2

