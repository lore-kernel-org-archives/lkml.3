Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaCZQ72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:59:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20203 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaCZQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:59:25 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-53-5333076cb193
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ata: fix Marvell SATA driver dependencies
Date: Wed, 26 Mar 2014 17:59:03 +0100
Message-id: <3641258.OaO7lhnDYy@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jQd0cduNgg2vzOS3O3z3EbLGp7S2j
	ReOSyywWmx5fY7U4tuMRk8XlXXPYLN7/dLT4tfwoowOHx5NNFxk9ds66y+6xaVUnm0fDgfMs
	HpuX1Hvs3PGZyePzJrkA9igum5TUnMyy1CJ9uwSujAdnjAoec1U0/5rB2MDYytnFyMkhIWAi
	MfvpTEYIW0ziwr31bF2MXBxCAtMZJX7fv8gM4bQwSVy+eJ8FpIpNwEpiYvsqsA4RAVmJK9Me
	MoIUMQvMZpKY/PI1UBEHh7CArcSDb2D1LAKqEqd/3GAGsXkFNCUm/VkBFhcV8JTYsX0lG0Rc
	UOLH5HtgcWYBeYl9+6eyQthaEut3HmeawMg3C0nZLCRls5CULWBkXsUomlqQXFCclJ5rpFec
	mFtcmpeul5yfu4kRHM7PpHcwrmqwOMQowMGoxMO7475RsBBrYllxZe4hRgkOZiUR3h1fgUK8
	KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYGbrChAONFRav
	vOammS7FYGvC63Y3saZC1otzons5h/zisxVK7bUfTr/vak+1P/tfeO6GWTOk+MVOsJu+1/db
	IrPY+29zzV6pkhr3eUHH3vzWKpv8dMGX+XPvsm7fq7BCZaaSxAxP5f+rbjcnT1g8/7ms11eD
	Q5Epoevnqolu3rGj2fVdw/9TSizFGYmGWsxFxYkAX2RkBmMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sata_mv host driver depend on PCI || ARCH_KIRKWOOD || ARCH_MVEBU ||
ARCH_ORION5X config options as Marvell SATA support covers both Marvell
PCI devices and Marvell Kirkwood, Armada 370/XP and Orion5x SoCs (for
non-PCI devices the driver to work requires suitable device tree node to
be defined).  Additionally allow the driver build if COMPILE_TEST config
option is set.

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
v2:
- previous patch was against libata/for-next branch
  (SATA_MV selects GENERIC_PHY in for-next branch)

 drivers/ata/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig	2014-03-26 17:43:46.000000000 +0100
+++ b/drivers/ata/Kconfig	2014-03-26 17:45:34.522983681 +0100
@@ -281,6 +281,8 @@ config SATA_HIGHBANK
 
 config SATA_MV
 	tristate "Marvell SATA support"
+	depends on PCI || ARCH_KIRKWOOD || ARCH_MVEBU || ARCH_ORION5X || \
+		   COMPILE_TEST
 	help
 	  This option enables support for the Marvell Serial ATA family.
 	  Currently supports 88SX[56]0[48][01] PCI(-X) chips,

