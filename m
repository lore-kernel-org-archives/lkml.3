Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaJOTCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:02:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:33482 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbaJOTCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:02:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,726,1406617200"; 
   d="scan'208";a="615084797"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: gregkh@linuxfoundation.org
Cc: Fabio Estevam <fabio.estevam@freescale.com>, linux-kernel@vger.kernel.org,
        mail@beyermatthias.de, devel@driverdev.osuosl.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Perches <joe@perches.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH v2] bcm/CmHost.c: Fix noisy compile warnings
Date: Wed, 15 Oct 2014 12:01:41 -0700
Message-Id: <1413399701-4321-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

The Beceem WIMAX was generating compile warnings on 64bit machines,
which were:

drivers/staging/bcm/CmHost.c: In function ‘StoreCmControlResponseMessage’:
drivers/staging/bcm/CmHost.c:1503:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   (struct bcm_connect_mgr_params *) ntohl(
   ^
drivers/staging/bcm/CmHost.c:1546:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   (struct bcm_connect_mgr_params *) ntohl(
   ^
drivers/staging/bcm/CmHost.c:1564:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   (struct bcm_connect_mgr_params *) ntohl(

This resolves the issue by preventing the driver to compile if CONFIG_64BIT
is enabled, since the driver is known to be broken for 64 bit arch's.

CC: Dan Carpenter <dan.carpenter@oracle.com>
CC: Joe Perches <joe@perches.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
v2: change fix from using typecast u64 in the code to altering Kconfig to
    prevent the driver from compiling on 64 bit arch's based on feedback

 drivers/staging/bcm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/Kconfig b/drivers/staging/bcm/Kconfig
index 8acf4b2..273b328 100644
--- a/drivers/staging/bcm/Kconfig
+++ b/drivers/staging/bcm/Kconfig
@@ -1,6 +1,6 @@
 config BCM_WIMAX
        tristate "Beceem BCS200/BCS220-3 and BCSM250 wimax support"
-       depends on USB && NET
+       depends on USB && NET && !64BIT
        help
          This is an experimental driver for the Beceem WIMAX chipset used
 	 by Sprint 4G.
-- 
1.9.3

