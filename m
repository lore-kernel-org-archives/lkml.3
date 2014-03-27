Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbaC0NZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 09:25:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43973 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaC0NZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 09:25:09 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-f2-533426b32275
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] ata: fix Marvell SATA driver dependencies
Date: Thu, 27 Mar 2014 14:24:39 +0100
Message-id: <13175343.U1fiIXSeHv@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd3NaibBBtvXaFucv3uI2WJT21tG
	i8Yll1ksNj2+xmpxbMcjJovLu+awWbz/6Wjxa/lRRgcOjyebLjJ67Jx1l91j06pONo+GA+dZ
	PDYvqffYueMzk8fnTXIB7FFcNimpOZllqUX6dglcGTNXz2YuOMpTMevpT7YGxgNcXYycHBIC
	JhIz27sYIWwxiQv31rN1MXJxCAksYpRY3LKVEcJpYZJ4fWw3C0gVm4CVxMT2VWAdIgKyElem
	PQQrYhaYzSQx+eVrsCJhAVuJL82T2UFsFgFViSO/LrKC2LwCWhIre5+zgdiiAp4SO7avZIOI
	C0r8mHwPrJdZQF5i3/6prBC2lsT6nceZJjDyzUJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukV
	J+YWl+al6yXn525iBIf0M+kdjKsaLA4xCnAwKvHw7rhvFCzEmlhWXJl7iFGCg1lJhNdX2SRY
	iDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA6OljPCR7sPV
	l2VirGR+KJw4Ur9GWHIV/xIbBdUVh5+YF4dc9/G9Uvsx7aJf9pvb/cpvluWxqWteTLf5dMn1
	zEH/Hza/ji9gOtdr7CTydOXCRx11TpFlDza5bmNV9Mx8ajdD933b+UXSXTb8CoX83kWzJh6o
	Edkcm9j+tcIv48W3BuEujsiOCiWW4oxEQy3mouJEAOgDY7RlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sata_mv host driver depend on PCI || ARCH_DOVE || ARCH_KIRKWOOD ||
ARCH_MV78XX0 || ARCH_MVEBU || ARCH_ORION5X config options as Marvell
SATA support covers both Marvell PCI devices and Marvell Dove, Kirkwood,
MV78xx0, Armada 370/XP and Orion5x SoCs (for non-PCI devices the driver
to work requires suitable device tree node or platform device to be
defined).  Additionally allow the driver build if COMPILE_TEST config
option is set.

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
v4:
- updated patch description
v3:
- added dependencies for Marvel Dove and MV78xx0 
v2:
- resynced patch with libata/for-3.15 branch (previous patch was against
  libata/for-next branch and SATA_MV selects GENERIC_PHY in that branch)

 drivers/ata/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig	2014-03-26 17:59:35.000000000 +0100
+++ b/drivers/ata/Kconfig	2014-03-27 13:14:24.097787880 +0100
@@ -281,6 +281,8 @@ config SATA_HIGHBANK
 
 config SATA_MV
 	tristate "Marvell SATA support"
+	depends on PCI || ARCH_DOVE || ARCH_KIRKWOOD || ARCH_MV78XX0 || \
+		   ARCH_MVEBU || ARCH_ORION5X || COMPILE_TEST
 	help
 	  This option enables support for the Marvell Serial ATA family.
 	  Currently supports 88SX[56]0[48][01] PCI(-X) chips,

