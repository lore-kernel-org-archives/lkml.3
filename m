Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaLCLh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:37:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbaLCL1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:44 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 077/101] pcmcia: sa1100: H3100 and H3600 share a driver
Date: Wed,  3 Dec 2014 12:26:39 +0100
Message-Id: <77cf7a125c16bfab995ea37962047a80d296bad7.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d8477126f46b036b26d95b127689a3774a080e34 upstream.

When building a iPAQ H3100-only kernel with PCMCIA enabled,
we get this build error:

ERROR: "pcmcia_h3600_init" [drivers/pcmcia/sa1100_cs.ko] undefined!

The defconfig normally works fine because it enables both H3100
and H3600 support. This patch fixes the Makefile to build the
driver if at least one of the two machines are selected.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pcmcia/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pcmcia/Makefile b/drivers/pcmcia/Makefile
index 7745b512a87c..fd55a6951402 100644
--- a/drivers/pcmcia/Makefile
+++ b/drivers/pcmcia/Makefile
@@ -49,6 +49,7 @@ sa1100_cs-y					+= sa1100_generic.o
 sa1100_cs-$(CONFIG_SA1100_ASSABET)		+= sa1100_assabet.o
 sa1100_cs-$(CONFIG_SA1100_CERF)			+= sa1100_cerf.o
 sa1100_cs-$(CONFIG_SA1100_COLLIE)		+= pxa2xx_sharpsl.o
+sa1100_cs-$(CONFIG_SA1100_H3100)		+= sa1100_h3600.o
 sa1100_cs-$(CONFIG_SA1100_H3600)		+= sa1100_h3600.o
 sa1100_cs-$(CONFIG_SA1100_NANOENGINE)		+= sa1100_nanoengine.o
 sa1100_cs-$(CONFIG_SA1100_SHANNON)		+= sa1100_shannon.o
-- 
2.1.3

