Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3GDFk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:40:59 -0400
Received: from mail1.windriver.com ([147.11.146.13]:39975 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab3GDFk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:40:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/4] video: make goldfish video depend on GOLDFISH || COMPILE_TEST
Date: Thu, 4 Jul 2013 01:39:12 -0400
Message-ID: <1372916353-24050-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nearly all the other goldfish peripherals (mtd, keyboard, etc)
have a dependency on the main platform's GOLDFISH Kconfig item,
but this one got skipped.  It was suggested to add it earlier[1],
but that never got responded to or picked up -- presumably because
some developers desired the extra compile coverage at the cost of
exposing unusable options to end users.

With CONFIG_COMPILE_TEST, we can have the best of both worlds.
Add the GOLDFISH dependency, in conjunction with COMPILE_TEST.

[1] https://lkml.org/lkml/2013/2/27/169

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/video/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 2e937bd..630b637 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2199,7 +2199,7 @@ config FB_XILINX
 
 config FB_GOLDFISH
 	tristate "Goldfish Framebuffer"
-	depends on FB && HAS_DMA
+	depends on FB && HAS_DMA && (GOLDFISH || COMPILE_TEST)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
1.8.1.2

