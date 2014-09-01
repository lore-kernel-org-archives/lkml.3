Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaIAPjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:39:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24571 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbaIAPjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:39:15 -0400
X-AuditID: cbfee61a-f79e46d00000134f-04-540493210dd9
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Rob Herring <robh@kernel.org>, Kyungmin Park <kyungmin.park@samsung.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: calxedaxgmac: fix driver dependencies
Date: Mon, 01 Sep 2014 17:39:04 +0200
Message-id: <7268934.nBXHizFkl4@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAV3FySwhBgdm8lvMOd/CYnG26Q27
	xeVdc9gsji0Qs/i/Zwe7A6vHlpU3mTw2repk8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	nmX2BZPZKy5OXcrSwNjP1sXIySEhYCLx/VgDM4QtJnHh3nqgOBeHkMAiRolT169DOS1MEu/u
	nGMBqWITsJKY2L6KEcQWEdCWWHeghxWkiFmghVHi0NPPrCAJYQFrid+z57CD2CwCqhJNz/eC
	reMV0JRYf6gVrEZUwFNix/aVUHFBiR+T74EtYBaQl9i3fyorhK0lsX7ncaYJjHyzkJTNQlI2
	C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBYflMagfjygaLQ4wCHIxKPLwPZjGH
	CLEmlhVX5h5ilOBgVhLh/dLHEiLEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2
	ampBahFMlomDU6qBcdomq68xf2ZOD3axEltcFcG5KvzN7VufJ/IoRxdk/g3juDhlV9iPa4di
	/SMbXyXGTN+itZ9162+zI9qXQj8ku624vj3lwvLLgdd+O00Nnane9fznB4WlX9MtFCdLvjx1
	85nCsf8KoZfU+EL79m1ius+lfLgn/tk7/njJSzbVOSytL6K9Z1qlqSqxFGckGmoxFxUnAgAP
	JCaHRwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calxeda 1G/10G XGMAC Ethernet support should be available only on
Calxeda ECX-1000/2000 (Highbank/Midway) platforms.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rob Herring <robh@kernel.org>
---
 drivers/net/ethernet/calxeda/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/net/ethernet/calxeda/Kconfig
===================================================================
--- a/drivers/net/ethernet/calxeda/Kconfig	2014-07-30 14:31:12.159522474 +0200
+++ b/drivers/net/ethernet/calxeda/Kconfig	2014-09-01 17:33:49.232810483 +0200
@@ -1,6 +1,7 @@
 config NET_CALXEDA_XGMAC
 	tristate "Calxeda 1G/10G XGMAC Ethernet driver"
 	depends on HAS_IOMEM && HAS_DMA
+	depends on ARCH_HIGHBANK || COMPILE_TEST
 	select CRC32
 	help
 	  This is the driver for the XGMAC Ethernet IP block found on Calxeda

