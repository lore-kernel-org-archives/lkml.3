Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaC0MYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 08:24:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42804 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaC0MYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:24:01 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-04-53341860148f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] ata: fix Marvell SATA driver dependencies
Date: Thu, 27 Mar 2014 13:23:39 +0100
Message-id: <1668037.2oe7J2B7N4@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAd0ECZNgg+VnhSzO3z3EbLGp7S2j
	ReOSyywWmx5fY7U4tuMRk8XlXXPYLN7/dLT4tfwoowOHx5NNFxk9ds66y+6xaVUnm0fDgfMs
	HpuX1Hvs3PGZyePzJrkA9igum5TUnMyy1CJ9uwSujHf9N1kK+nkqGrYLNTBO5epi5OCQEDCR
	WL5IvouRE8gUk7hwbz1bFyMXh5DAIkaJp3snskA4LUwST19+ZwWpYhOwkpjYvooRxBYRkJW4
	Mu0hI0gRs8BsJonJL1+zgCSEBWwlpvb+YQKxWQRUJR5862UG2cYroCnRdjEMJCwq4CmxY/tK
	NhCbV0BQ4sfke2CtzALyEvv2T2WFsLUk1u88zjSBkW8WkrJZSMpmISlbwMi8ilE0tSC5oDgp
	PddIrzgxt7g0L10vOT93EyM4mJ9J72Bc1WBxiFGAg1GJh3fHfaNgIdbEsuLK3EOMEhzMSiK8
	t4VNgoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwytX5
	Gwf4zC607tv8rKFPaKpec+mBL1tmqHy+P/XlhluZbyt+Rig020ksWJd0XLDzwEu5cxNn9Wi8
	/XFc4oLF4uh+7zzT6EUap6cnX90kG35xT6LzwpwNda9+fXDXttsyg/+dtZPv3P6HW03ZQz/P
	26i5g3vWu8X8e3auMFJw6Zw9XXCG+XzGOUosxRmJhlrMRcWJAKfQvLtiAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sata_mv host driver depend on PCI || ARCH_DOVE || ARCH_KIRKWOOD ||
ARCH_MV78XX0 || ARCH_MVEBU || ARCH_ORION5X config options as Marvell
SATA support covers both Marvell PCI devices and Marvell Dove, Kirkwood,
MV78xx0, Armada 370/XP and Orion5x SoCs (for non-PCI devices the driver
to work requires suitable device tree node to be defined).  Additionally
allow the driver build if COMPILE_TEST config option is set.

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
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

