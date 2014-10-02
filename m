Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaJBOwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:52:51 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48901 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaJBOwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:52:50 -0400
Message-ID: <542D6819.4000907@gmail.com>
Date: Thu, 02 Oct 2014 22:58:33 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: benjamin.romer@unisys.com, david.kershner@unisys.com,
        regkh@linuxfoundation.org, jkc@redhat.com, sparmaintainer@unisys.com
CC: devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] drivers/staging/unisys: Let all IOMEM related modules depend
 on HAS_IOMEM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UNISYS_UISLIB, UNISYS_VISORCHIPSET, and UNISYS_VISORUTIL need HAS_IOMEM,
so depend on it. One of related error (with allmodconfig under um):

    CC [M]  drivers/staging/unisys/uislib/uislib.o
  In file included from drivers/staging/unisys/uislib/uislib.c:34:0:
  drivers/staging/unisys/include/uisutils.h: In function ‘dbg_ioremap_cache’:
  drivers/staging/unisys/include/uisutils.h:88:2: error: implicit declaration of function ‘ioremap_cache’ [-Werror=implicit-function-declaration]
    new = ioremap_cache(addr, size);
    ^
  drivers/staging/unisys/include/uisutils.h:88:6: warning: assignment makes pointer from integer without a cast [enabled by default]
    new = ioremap_cache(addr, size);
        ^
  drivers/staging/unisys/include/uisutils.h: In function ‘dbg_ioremap’:
  drivers/staging/unisys/include/uisutils.h:99:2: error: implicit declaration of function ‘ioremap’ [-Werror=implicit-function-declaration]
    new = ioremap(addr, size);
    ^
  drivers/staging/unisys/include/uisutils.h:99:6: warning: assignment makes pointer from integer without a cast [enabled by default]
    new = ioremap(addr, size);
        ^
  drivers/staging/unisys/include/uisutils.h: In function ‘dbg_iounmap’:
  drivers/staging/unisys/include/uisutils.h:108:2: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration]
    iounmap(addr);
    ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/staging/unisys/uislib/Kconfig       | 2 +-
 drivers/staging/unisys/visorchipset/Kconfig | 2 +-
 drivers/staging/unisys/visorutil/Kconfig    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/unisys/uislib/Kconfig b/drivers/staging/unisys/uislib/Kconfig
index 8d87d9c..6b134e2 100644
--- a/drivers/staging/unisys/uislib/Kconfig
+++ b/drivers/staging/unisys/uislib/Kconfig
@@ -4,7 +4,7 @@
 
 config UNISYS_UISLIB
 	tristate "Unisys uislib driver"
-	depends on UNISYSSPAR && UNISYS_VISORCHIPSET && UNISYS_CHANNELSTUB
+	depends on UNISYSSPAR && UNISYS_VISORCHIPSET && UNISYS_CHANNELSTUB && HAS_IOMEM
 	---help---
 	If you say Y here, you will enable the Unisys uislib driver.
 
diff --git a/drivers/staging/unisys/visorchipset/Kconfig b/drivers/staging/unisys/visorchipset/Kconfig
index 7ca2fbc..e86836f 100644
--- a/drivers/staging/unisys/visorchipset/Kconfig
+++ b/drivers/staging/unisys/visorchipset/Kconfig
@@ -4,7 +4,7 @@
 
 config UNISYS_VISORCHIPSET
 	tristate "Unisys visorchipset driver"
-	depends on UNISYSSPAR && UNISYS_VISORUTIL && UNISYS_VISORCHANNEL
+	depends on UNISYSSPAR && UNISYS_VISORUTIL && UNISYS_VISORCHANNEL && HAS_IOMEM
 	---help---
 	If you say Y here, you will enable the Unisys visorchipset driver.
 
diff --git a/drivers/staging/unisys/visorutil/Kconfig b/drivers/staging/unisys/visorutil/Kconfig
index 4ff61a7..74b474e 100644
--- a/drivers/staging/unisys/visorutil/Kconfig
+++ b/drivers/staging/unisys/visorutil/Kconfig
@@ -4,7 +4,7 @@
 
 config UNISYS_VISORUTIL
 	tristate "Unisys visorutil driver"
-	depends on UNISYSSPAR
+	depends on UNISYSSPAR && HAS_IOMEM
 	---help---
 	If you say Y here, you will enable the Unisys visorutil driver.
 
-- 
1.9.3
