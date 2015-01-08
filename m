Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbbAHAsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:48:18 -0500
Received: from mailout.micron.com ([137.201.242.129]:36626 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbbAHAsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:48:15 -0500
From: =?gb2312?B?UGV0ZXIgUGFuIMXLtrAgKHBldGVycGFuZG9uZyk=?= 
	<peterpandong@micron.com>
To: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        =?gb2312?B?UWkgV2FuZyDN9cbwIChxaXdhbmcp?= <qiwang@micron.com>,
        =?gb2312?B?RnJhbmsgTGl1IMH1yLogKGZyYW5rbGl1KQ==?= 
	<frankliu@micron.com>,
        =?gb2312?B?TWVsYW5pZSBaaGFuZyDVxdHgIChtZWxhbmllemhhbmcp?= 
	<melaniezhang@micron.com>,
        =?gb2312?B?UGV0ZXIgUGFuIMXLtrAgKHBldGVycGFuZG9uZyk=?= 
	<peterpandong@micron.com>
Subject: [PATCH 0/3] An alternative to SPI NAND
Thread-Topic: [PATCH 0/3] An alternative to SPI NAND
Thread-Index: AdAq2q78IdxvQLPKQ322Hb2GbRwNjAAAGruwAAAwq2A=
Date: Thu, 8 Jan 2015 00:47:24 +0000
Message-ID: <87F60714EC601C4C83DFF1D2E3D390A04AB3F3@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21230.002
X-TM-AS-Result: No--0.329100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t080mVv1027751

This patchset is an alternative to Ezequiel's series[1].

This patchset separate SPI NAND code and Parallel NAND code, make SPI NAND have
its own spi_nand_scan, read, write, BBM mechanism, so that it would be better
for code maintenance in the future.   

TODO - 
      1. This patchset is validated only on Micron SPI NAND device MT29F2G01AAAED
      by run mtdtest program, and mount UBIFS on SPI NAND, further testing on 
      other Manufactory SPI NAND is needed.
      2. Although this patchset's framework separate SPI NAND and Parall NAND code, 
      some code do is common that can share by SPI NAND and Parallel NAND at same 
      time. For view the code structure might be more make sense as below diagram, 
      so that SPI NAND and Parallel NAND can have their own specific code and meanwhile 
      can share Common code. But may bring a lot change for current code, I am glad 
      to discuss this structure if any guys are interested.

      |------------------------------------------------------------------|
      |                         MTD/NAND folder                         |
      | |-------------|  |---------------|  |-------------------------|  |
      | | Common code |  | SPI NAND code |  |  Parallel NAND code     |  |
      | |-------------|  | --------------|  |-------------------------|  |
      | | Nand_bch.c  |  |spi_nand_base.c|  |  parallel_nand_base.c   |  |  
      | | Nand_ecc.c  |  |   .........   |  |specific controllers code|  |
      | | Nand_bbt.c  |  |               |  |                         |  |
      |------------------------------------------------------------------|


This series is based on v3.19-rc1.
[1] http://lists.infradead.org/pipermail/linux-mtd/2014-December/056763.html

Peter Pan (3):
  mtd: spi-nand framework                   
  mtd: spi-nand: support spi-nand devices
  mtd: spi-nand: add devicetree binding

Documentation/devicetree/bindings/mtd/spi-nand.txt |   22 +
drivers/mtd/Kconfig                                |    2 +
drivers/mtd/Makefile                               |    1 +
drivers/mtd/spi-nand/Kconfig                       |    7 +
drivers/mtd/spi-nand/Makefile                      |    3 +
drivers/mtd/spi-nand/spi-nand-base.c               | 2034 ++++++++++++++++++++
drivers/mtd/spi-nand/spi-nand-bbt.c                | 1279 ++++++++++++
drivers/mtd/spi-nand/spi-nand-device.c             |  281 +++
include/linux/mtd/spi-nand.h                       |  317 +++
9 files changed, 3946 insertions(+)
create mode 100644 Documentation/devicetree/bindings/mtd/spi-nand.txt
create mode 100644 drivers/mtd/spi-nand/Kconfig
create mode 100644 drivers/mtd/spi-nand/Makefile
create mode 100644 drivers/mtd/spi-nand/spi-nand-base.c
create mode 100644 drivers/mtd/spi-nand/spi-nand-bbt.c
create mode 100644 drivers/mtd/spi-nand/spi-nand-device.c
create mode 100644 include/linux/mtd/spi-nand.h

-- 
1.9.1
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
