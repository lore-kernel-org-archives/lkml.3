Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaCZQTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:19:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40604 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbaCZQTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:19:30 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-e8-5332fe10007f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ata: fix Marvell SATA driver dependencies
Date: Wed, 26 Mar 2014 17:19:02 +0100
Message-id: <5138028.BSQbEP7RRB@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jQV2Bf0bBBm8/qFqcv3uI2WJT21tG
	i8Yll1ksNj2+xmpxbMcjJovLu+awWbz/6Wjxa/lRRgcOjyebLjJ67Jx1l91j06pONo+GA+dZ
	PDYvqffYueMzk8fnTXIB7FFcNimpOZllqUX6dglcGZ8XhRZc4Kz4ef4BSwNjD0cXIyeHhICJ
	xMzGZ8wQtpjEhXvr2boYuTiEBKYzSlyevZQFwmlhkng/6SUbSBWbgJXExPZVjCC2iICsxJVp
	DxlBipgFZjNJTH75mgUkIQxUtHfSTlYQm0VAVeLfvz/sXYwcHLwCmhL77qWChEUFPCV2bF8J
	NpNXQFDix+R7YK3MAvIS+/ZPZYWwtSTW7zzONIGRbxaSsllIymYhKVvAyLyKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTIzicn0ntYFzZYHGIUYCDUYmHd8d9o2Ah1sSy4srcQ4wSHMxKIrw7
	vgKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1MNp+efJJ
	aJK9l3a5Ql1Mzbs8n5N/n274eVOi523Nj8c2Hbfur1DomqFy30feIP7Gk2kaAj4b/j/Oc3sQ
	q5KiJbKQNTzw+r7lL01NBdqFC8Smqjx+HOuirr9RmGVdh4h+En/uGuEjSzZHvJUp7FvK92Cx
	xatffhvzwr4KnbLgbdh9xX2TZLWQgxJLcUaioRZzUXEiAIdEsX5jAgAA
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
 drivers/ata/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig	2014-03-26 15:49:59.919101924 +0100
+++ b/drivers/ata/Kconfig	2014-03-26 17:02:08.187028122 +0100
@@ -273,6 +273,8 @@ config SATA_HIGHBANK
 
 config SATA_MV
 	tristate "Marvell SATA support"
+	depends on PCI || ARCH_KIRKWOOD || ARCH_MVEBU || ARCH_ORION5X || \
+		   COMPILE_TEST
 	select GENERIC_PHY
 	help
 	  This option enables support for the Marvell Serial ATA family.

