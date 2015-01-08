Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbbAHCpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:45:40 -0500
Received: from mailout.micron.com ([137.201.242.129]:31043 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbbAHCpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:45:39 -0500
From: =?utf-8?B?UWkgV2FuZyDnjovotbcgKHFpd2FuZyk=?= <qiwang@micron.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        =?utf-8?B?RnJhbmsgTGl1IOWImOe+pCAoZnJhbmtsaXUp?= 
	<frankliu@micron.com>,
        =?utf-8?B?TWVsYW5pZSBaaGFuZyDlvKDnh5UgKG1lbGFuaWV6aGFuZyk=?= 
	<melaniezhang@micron.com>,
        =?utf-8?B?UGV0ZXIgUGFuIOa9mOagiyAocGV0ZXJwYW5kb25nKQ==?= 
	<peterpandong@micron.com>
Subject: RE: [PATCH 0/3] An alternative to SPI NAND
Thread-Topic: [PATCH 0/3] An alternative to SPI NAND
Thread-Index: AdAq2q78IdxvQLPKQ322Hb2GbRwNjAAAGruwAAAwq2D//3/+gP//ZSPQ
Date: Thu, 8 Jan 2015 02:45:01 +0000
Message-ID: <71CF8D7F32C5C24C9CD1D0E02D52498A7714DD2A@NTXXIAMBX02.xacn.micron.com>
References: <87F60714EC601C4C83DFF1D2E3D390A04AB3F3@NTXXIAMBX02.xacn.micron.com>
 <20150108010257.GP9759@ld-irv-0074>
In-Reply-To: <20150108010257.GP9759@ld-irv-0074>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21230.002
X-TM-AS-Result: No--6.047300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t082jlpK028314

Hi Brian,

On Thu, Jan 08, 2015 at 9:03:24AM +0000, Brian Norris wrote:
>
>On Thu, Jan 08, 2015 at 12:47:24AM +0000, Peter Pan æ½˜æ ‹ (peterpandong)
>wrote:
>> Documentation/devicetree/bindings/mtd/spi-nand.txt |   22 +
>> drivers/mtd/Kconfig                                |    2 +
>> drivers/mtd/Makefile                               |    1 +
>> drivers/mtd/spi-nand/Kconfig                       |    7 +
>> drivers/mtd/spi-nand/Makefile                      |    3 +
>> drivers/mtd/spi-nand/spi-nand-base.c               | 2034
>++++++++++++++++++++
>> drivers/mtd/spi-nand/spi-nand-bbt.c                | 1279 ++++++++++++
>
>I can already tell by the diffstat that I don't like this. We probably
>don't need 3000 new lines of code for this, but we especially don't want
>to duplicate nand_bbt.c. It won't take a lot of work to augment
>nand_bbt.c to make it shareable. (I can whip that patch up if needed.)

Yes, I agree with you, Nand_bbt.c do can be shared by Parallel NAND and
SPI NAND. Actually, we are working at this now. Will send patches to you
Once we finished it.

But for the 2000 new lines code in spi-nand-base.c, frankly speaking, I 
still no idea how to decrease the code lines. 

I separate code of the SPI NAND and Parallel NAND that different with 
Ezequiel Garcia patches, because I think this framework could be easier 
to maintain it, in the future, SPI NAND may have more specific features 
that will be difficult to reuse the code of Nand_base.c but just remap 
command to SPI NAND from Parallel NAND.

So we write a new spi-nand-base.c, to implement read/write/erase function,
that will cause many code lines as you see. If you have other suggestion, 
please let me know. 

>
>I'll still take a look at the rest of the code eventually, but just
>wanted to give my 2 cents up front.
>
>> drivers/mtd/spi-nand/spi-nand-device.c             |  281 +++
>> include/linux/mtd/spi-nand.h                       |  317 +++
>> 9 files changed, 3946 insertions(+)
>> create mode 100644 Documentation/devicetree/bindings/mtd/spi-nand.txt
>> create mode 100644 drivers/mtd/spi-nand/Kconfig
>> create mode 100644 drivers/mtd/spi-nand/Makefile
>> create mode 100644 drivers/mtd/spi-nand/spi-nand-base.c
>> create mode 100644 drivers/mtd/spi-nand/spi-nand-bbt.c
>> create mode 100644 drivers/mtd/spi-nand/spi-nand-device.c
>> create mode 100644 include/linux/mtd/spi-nand.h
>

Qi Wang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
