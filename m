Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab3FCVjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 17:39:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54156 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3FCVjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 17:39:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH] net: emaclite: include linux/of_irq.h
Date: Mon, 03 Jun 2013 23:39:29 +0200
Message-ID: <2244203.EL457oABTU@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZiNq7RSw3bj72M197vL8Pk6rvvbVvl8h7GZrF91IDSg
 Mmy3woO/8j4VjDt5oOjIHTgDMpCLukjZtFZJ+vf7HmPh8kvrmj
 4dk9z6uaPhcPD+cE8RndSW89PJJGir5tvoz7YE8W/kPrK/YoyB
 rInYMiDqMaoLnMF8iwAc+0296jhxTJ0o4mfVuZUudVG/4Dcaoq
 cloERntS11enGQZuI9n02owqUNrGN+/UD8GWjFNaer3BDAadMH
 Pe239tJzrAOfTe5rTyf/+M+DHLRL7V+7pZZYdC74DAEKdNPUPB
 q2loD6hqUuh9BHmmHKt3O4sCiQFqv/PkqNky1Bvx5UxKnYWPx4
 t15F1aTgsm7t47f9pckM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The emaclite driver now calls of_irq_to_resource, which is
declared in linux/of_irq.h. Without this patch, I get a build
error on ARM.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Simek <michal.simek@xilinx.com>

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index aa14d8a..9559a3d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>

