Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030297Ab3BNW2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:28:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65059 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030276Ab3BNW1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:27:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 5/9] ARM: shmobile: mark mackerel sh_mmcif_device __maybe_unused
Date: Thu, 14 Feb 2013 23:26:54 +0100
Message-Id: <1360880818-4071454-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:tKaBKzFraVBe0N06d/9VMynkq4zhwBjw1tqjGAWoe40
 cKHI0CkOm35VUGdYtUy44KJnfAO6J/sNky714sTxfKSPoF8lOU
 LHHHpnph1H1jzN+lzoZPpFTMwRYeorXzXT+d9osM1oIsjwVshC
 cw2ghBhVv6TvCWQll29bJF4+A3iTsfN9ZvtnHKHQD/eZ8n164J
 zJ8iapq5iIialVwJRU318ahWwWQVLc6MeLoZ6JtSlH4uKzM2kk
 yLcixBySLLeM6lgLTYgnQ+Vn7ztNIYb9yMXo1wZrTchMDlTIky
 vJdHu4Dq3K0YSVWnM4ffwMEk5Sfmt8Ninnvf2SKL3GxMox2adI
 mJQ980+czeozKXVY4AMZXDEjiZ5tjCnukgvzoPlij
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch eac036ef9e "ARM: shmobile: streamline mackerel SD and MMC devices"
made the use of the sh_mmcif_device variable for mackarel optional,
but the definition is always provided, causing a build warning.

arch/arm/mach-shmobile/board-mackerel.c:1120:31: warning: 'sh_mmcif_device'
	defined but not used [-Wunused-variable]

Marking the variable as __maybe_unused will do the right thing here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Simon Horman <horms+renesas@verge.net.au>
---
 arch/arm/mach-shmobile/board-mackerel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index 0c78207..1de898f 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -1117,7 +1117,7 @@ static struct sh_mmcif_plat_data sh_mmcif_plat = {
 	.slave_id_rx	= SHDMA_SLAVE_MMCIF_RX,
 };
 
-static struct platform_device sh_mmcif_device = {
+static struct platform_device sh_mmcif_device __maybe_unused = {
 	.name		= "sh_mmcif",
 	.id		= 0,
 	.dev		= {
-- 
1.8.1.2

