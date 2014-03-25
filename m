Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaCYPu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 11:50:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaCYPu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 11:50:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfio: always select ANON_INODES
Date: Tue, 25 Mar 2014 16:50:54 +0100
Message-ID: <11162011.2nHj9XzrYt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bJur8VT015kSZ3ASIUZgw6Itt374EpkItCjoWrdPtlm
 g2meCHoKhWjVBVc4G66GihARF2pH0lAmz5jfhtJtDW9NEdmaAi
 AttIK/exvZbCc4Qmo5bpPLBt/CbYUrgZSImee/txcvUrrtVZHD
 dtPTpN7Hxz0+IpVE0osFn2b6tR2x3LQtQi5IFOrd20BnGKbyVL
 yyHMA9lK+LjaZMM+i/F5+NmtSqn3a+xunnRHRkbLIG4mHx3o+S
 V1+pRNA8qHWjMukFb5Ok/2vsSxVoAtuIQUbMsduS14DbKHlF/x
 9bFsTNNSQkyr44CP9Ft+y1shScWva3dQnczbR6dmUnRG8kitJt
 0t5cZPEQgXmCyk66s62U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfio code cannot be built when CONFIG_ANON_INODES is
disabled, so this enforces the symbol to be enabled through
Kconfig.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 26b3d9d..af7b204 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -13,6 +13,7 @@ menuconfig VFIO
 	depends on IOMMU_API
 	select VFIO_IOMMU_TYPE1 if X86
 	select VFIO_IOMMU_SPAPR_TCE if (PPC_POWERNV || PPC_PSERIES)
+	select ANON_INODES
 	help
 	  VFIO provides a framework for secure userspace device drivers.
 	  See Documentation/vfio.txt for more details.

