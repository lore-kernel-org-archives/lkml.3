Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335Ab3BLO4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:56:51 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:57184 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760770Ab3BLOxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 10/10] cris: Provide inb_p() and outb_p()
Date: Tue, 12 Feb 2013 15:52:57 +0100
Message-Id: <1360680777-12622-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
References: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/block/hd.c: In function 'check_status':
drivers/block/hd.c:256:2: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]
drivers/block/hd.c: In function 'controller_ready':
drivers/block/hd.c:297:3: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/include/asm/io.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index ac12ae2..5d3047e 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -167,6 +167,9 @@ static inline void outsl(unsigned int port, const void *addr,
 		cris_iops->write_io(port, (void *)addr, 4, count);
 }
 
+#define inb_p(port)             inb(port)
+#define outb_p(val, port)       outb((val), (port))
+
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
-- 
1.7.0.4

