Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbbATGPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 01:15:52 -0500
Received: from mailout.micron.com ([137.201.242.129]:37362 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbATGPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 01:15:51 -0500
From: =?utf-8?B?UGV0ZXIgUGFuIOa9mOagiyAocGV0ZXJwYW5kb25nKQ==?= 
	<peterpandong@micron.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        =?utf-8?B?UWkgV2FuZyDnjovotbcgKHFpd2FuZyk=?= <qiwang@micron.com>,
        =?utf-8?B?RnJhbmsgTGl1IOWImOe+pCAoZnJhbmtsaXUp?= 
	<frankliu@micron.com>,
        =?utf-8?B?TWVsYW5pZSBaaGFuZyDlvKDnh5UgKG1lbGFuaWV6aGFuZyk=?= 
	<melaniezhang@micron.com>
Subject: RE: [PATCH 0/3] An alternative to SPI NAND
Thread-Topic: [PATCH 0/3] An alternative to SPI NAND
Thread-Index: AdAq2q78IdxvQLPKQ322Hb2GbRwNjAAAGruwAAAwq2D//3/+gP/sYmMg
Date: Tue, 20 Jan 2015 06:15:14 +0000
Message-ID: <87F60714EC601C4C83DFF1D2E3D390A04AD5FC@NTXXIAMBX02.xacn.micron.com>
References: <87F60714EC601C4C83DFF1D2E3D390A04AB3F3@NTXXIAMBX02.xacn.micron.com>
 <20150108010257.GP9759@ld-irv-0074>
In-Reply-To: <20150108010257.GP9759@ld-irv-0074>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21264.003
X-TM-AS-Result: No--6.956200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0K6FwZY008816

> On Thu, Jan 08, 2015 at 12:47:24AM +0000, Peter Pan æ½˜æ ‹ (peterpandong)
> wrote:
> > Documentation/devicetree/bindings/mtd/spi-nand.txt |   22 +
> > drivers/mtd/Kconfig                                |    2 +
> > drivers/mtd/Makefile                               |    1 +
> > drivers/mtd/spi-nand/Kconfig                       |    7 +
> > drivers/mtd/spi-nand/Makefile                      |    3 +
> > drivers/mtd/spi-nand/spi-nand-base.c               | 2034
> ++++++++++++++++++++
> > drivers/mtd/spi-nand/spi-nand-bbt.c                | 1279
> ++++++++++++
> 
> I can already tell by the diffstat that I don't like this. We probably
> don't need 3000 new lines of code for this, but we especially don't
> want
> to duplicate nand_bbt.c. It won't take a lot of work to augment
> nand_bbt.c to make it shareable. (I can whip that patch up if needed.)

Qi Wang and I have started to work on make nand_bbt.c shareable.
nand_bbt.c need some member of nand_chip. Like what you said, if we want
to remove nand_chip from nand_bbt.c, "We'd just need to parameterize a few
relevant device details into a new nand_bbt struct, rather than using
struct nand_chip directly."

We can put struct nand_bbt pointer in either nand_chip or mtd_info structure.
If put nand_bbt in nand_chip, we need to change the parameter of nand_chip->scan_bbt
function from mtd_info to nand_bbt. Using nand_bbt struct will cause some member
in both nand_chip and nand_bbt struct.

Brain, do you have any suggest about this?
> 
> I'll still take a look at the rest of the code eventually, but just
> wanted to give my 2 cents up front.
> 
> > drivers/mtd/spi-nand/spi-nand-device.c             |  281 +++
> > include/linux/mtd/spi-nand.h                       |  317 +++
> > 9 files changed, 3946 insertions(+)
> > create mode 100644 Documentation/devicetree/bindings/mtd/spi-nand.txt
> > create mode 100644 drivers/mtd/spi-nand/Kconfig
> > create mode 100644 drivers/mtd/spi-nand/Makefile
> > create mode 100644 drivers/mtd/spi-nand/spi-nand-base.c
> > create mode 100644 drivers/mtd/spi-nand/spi-nand-bbt.c
> > create mode 100644 drivers/mtd/spi-nand/spi-nand-device.c
> > create mode 100644 include/linux/mtd/spi-nand.h
> 
> Brian
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
