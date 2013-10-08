Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3JHK3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:29:19 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50657 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab3JHK3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:29:17 -0400
From: Majunath Goudar <csmanjuvijay@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nataraja.km@lge.com, Majunath Goudar <csmanjuvijay@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH] ARM: mach-omap1: Fix omap1510_fpga_init_irq() implicit declarations.
Date: Tue,  8 Oct 2013 15:59:01 +0530
Message-Id: <1381228141-16213-1-git-send-email-csmanjuvijay@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a omap1510_fpga_init_irq() inline dummy implementations
in arch/arm/mach-omap1/common.h. Without this patch,build system can
lead to issues. This was discovered during randconfig testing,in which
other than CONFIG_ARCH_OMAP15XX was enabled the leading to the following
error:

CC      arch/arm/mach-omap1/board-innovator.o
arch/arm/mach-omap1/board-innovator.c: In function ‘innovator_init’:
arch/arm/mach-omap1/board-innovator.c:377:3: error: implicit declaration of
function ‘omap1510_fpga_init_irq’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [arch/arm/mach-omap1/board-innovator.o] Error 1
make: *** [arch/arm/mach-omap1] Error 2

Signed-off-by: Manjunath Goudar <csmanjuvijay@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
---
 arch/arm/mach-omap1/common.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-omap1/common.h b/arch/arm/mach-omap1/common.h
index abec019..732f8ee 100644
--- a/arch/arm/mach-omap1/common.h
+++ b/arch/arm/mach-omap1/common.h
@@ -46,6 +46,9 @@ static inline void omap7xx_map_io(void)
 void omap1510_fpga_init_irq(void);
 void omap15xx_map_io(void);
 #else
+static inline void omap1510_fpga_init_irq(void)
+{
+}
 static inline void omap15xx_map_io(void)
 {
 }
-- 
1.7.9.5

