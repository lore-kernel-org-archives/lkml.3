Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161057Ab3BNW1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:27:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50887 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030268Ab3BNW1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:27:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 8/9] [media] s5p-fimc: fix s5pv210 build
Date: Thu, 14 Feb 2013 23:26:57 +0100
Message-Id: <1360880818-4071454-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:r8gJDXL6Mag5ieF7gw1qR2d9Y9SCbD4Ry/uJdlI4F+y
 M0wsQXPD2lCRqyFUDfGVXwXgKxdi4gHEHSysg+xRbkK87rRXFe
 ZWq55yvDInhoqAKhZ8KXwkMMBdgt3JSv6JEhShTMAe258pZJJb
 Zp1le0nJHvzA+A6lFzDaQ/Y4LHve2WXD9MdnJC1Ltkqvy/va6O
 dztBUl7mwDlUplc56+sg8ftAGloWHNQY6xq68fHvnXtFej7kZE
 2NCV15KRGivytdiP5kZQwpqkfo+KMGyS01uQ/py+TPfuuKRnz6
 ZXbUKEav+ws1Gn7fpOz9R45qxymVLJwpq7KcuPhFbiyCYWU7jq
 KF8ez2J9aYGDHYCsqa89KMozVvTTTEU65fFDA+8tZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

56bc911 "[media] s5p-fimc: Redefine platform data structure for fimc-is"
changed the bus_type member of struct fimc_source_info treewide, but
got one instance wrong in mach-s5pv210, which was evidently not
even build tested.

This adds the missing change to get s5pv210_defconfig to build again.
Applies on the Mauro's media tree.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 arch/arm/mach-s5pv210/mach-goni.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 3a38f7b..e373de4 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -845,7 +845,7 @@ static struct fimc_source_info goni_camera_sensors[] = {
 		.mux_id		= 0,
 		.flags		= V4L2_MBUS_PCLK_SAMPLE_FALLING |
 				  V4L2_MBUS_VSYNC_ACTIVE_LOW,
-		.bus_type	= FIMC_BUS_TYPE_ITU_601,
+		.fimc_bus_type	= FIMC_BUS_TYPE_ITU_601,
 		.board_info	= &noon010pc30_board_info,
 		.i2c_bus_num	= 0,
 		.clk_frequency	= 16000000UL,
-- 
1.8.1.2

