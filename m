Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043Ab3K0BmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:42:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353Ab3K0A6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 77/80] cris: media platform drivers: fix build
Date: Tue, 26 Nov 2013 16:57:46 -0800
Message-Id: <20131127005646.256252726@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/cris/include/asm/io.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -3,6 +3,7 @@
 
 #include <asm/page.h>   /* for __va, __pa */
 #include <arch/io.h>
+#include <asm-generic/iomap.h>
 #include <linux/kernel.h>
 
 struct cris_io_operations


