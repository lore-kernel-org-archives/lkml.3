Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162235Ab3LFNGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:06:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44833 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162218Ab3LFNGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:06:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 266/272] cris: media platform drivers: fix build
Date: Fri,  6 Dec 2013 12:59:15 +0000
Message-Id: <1386334761-25517-267-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 72a0c5571351f5184195754d23db3e14495b2080 upstream.

On cris arch, the functions below aren't defined:

  drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_read':

  drivers/media/platform/sh_veu.c:228:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
  drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_write':

  drivers/media/platform/sh_veu.c:234:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
  drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
  drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
  drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
  drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
  drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
  drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
  drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
  drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
  drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin_setup':
  drivers/media/platform/soc_camera/rcar_vin.c:284:3: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]

  drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin_request_capture_stop':
  drivers/media/platform/soc_camera/rcar_vin.c:353:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]

Yet, they're available, as CONFIG_GENERIC_IOMAP is defined.  What happens
is that asm/io.h was not including asm-generic/iomap.h.

Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/cris/include/asm/io.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index 5d3047e..4353cf2 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -3,6 +3,7 @@
 
 #include <asm/page.h>   /* for __va, __pa */
 #include <arch/io.h>
+#include <asm-generic/iomap.h>
 #include <linux/kernel.h>
 
 struct cris_io_operations
-- 
1.8.3.2

