Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbbALB6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 20:58:21 -0500
Received: from mailout.micron.com ([137.201.242.129]:30687 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbbALB6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 20:58:19 -0500
From: =?gb2312?B?UGV0ZXIgUGFuIMXLtrAgKHBldGVycGFuZG9uZyk=?= 
	<peterpandong@micron.com>
To: Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Brian Norris" <computersforpeace@gmail.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?gb2312?B?UWkgV2FuZyDN9cbwIChxaXdhbmcp?= <qiwang@micron.com>,
        =?gb2312?B?RnJhbmsgTGl1IMH1yLogKGZyYW5rbGl1KQ==?= 
	<frankliu@micron.com>,
        =?gb2312?B?TWVsYW5pZSBaaGFuZyDVxdHgIChtZWxhbmllemhhbmcp?= 
	<melaniezhang@micron.com>
Subject: RE: [PATCH 3/3] mtd: spi-nand: add devicetree binding
Thread-Topic: [PATCH 3/3] mtd: spi-nand: add devicetree binding
Thread-Index: AdAq2xIAAWi2EYo2S7+rJwTqE708CAAAgENw//+iloD//1zk8IABa0IA//oSWpA=
Date: Mon, 12 Jan 2015 01:57:27 +0000
Message-ID: <87F60714EC601C4C83DFF1D2E3D390A04AC98F@NTXXIAMBX02.xacn.micron.com>
References: <87F60714EC601C4C83DFF1D2E3D390A04AB425@NTXXIAMBX02.xacn.micron.com>
 <54ADF66F.7090400@imgtec.com>
 <87F60714EC601C4C83DFF1D2E3D390A04AB4EA@NTXXIAMBX02.xacn.micron.com>
 <54AE9E54.2010506@imgtec.com>
In-Reply-To: <54AE9E54.2010506@imgtec.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21242.003
X-TM-AS-Result: No--21.572600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0C1wat8015355

> On 01/08/2015 02:04 AM, Peter Pan ÅË¶° (peterpandong) wrote:
> >>> This commit adds the devicetree binding document that specifies the
> >>> spi nand devices support.
> >>>
> >>> Signed-off-by: Peter Pan <peterpandong@micron.com>
> >>> ---
> >>>  Documentation/devicetree/bindings/mtd/spi-nand.txt | 22
> >> ++++++++++++++++++++++
> >>>  1 file changed, 22 insertions(+)
> >>>  create mode 100644 Documentation/devicetree/bindings/mtd/spi-
> >> nand.txt
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/mtd/spi-nand.txt
> >> b/Documentation/devicetree/bindings/mtd/spi-nand.txt
> >>> new file mode 100644
> >>> index 0000000..9dd3efd
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/mtd/spi-nand.txt
> >>> @@ -0,0 +1,22 @@
> >>> +* NAND driver for MT29F, GD5F and similar SPI NAND flash chips
> >>> +
> >>> +Required properties:
> >>> +- #address-cells, #size-cells : Must be present if the device has
> >> sub-nodes
> >>> +  representing partitions.
> >>> +- compatible : Should be the manufacturer and the name of the chip.
> >> Bear in mind
> >>>
> >>
> >> Unless I'm mistaken, we don't need the chip ID here, as SPI NAND
> allows
> >> to autodetect the device. Any reason why we can't just use a generic
> >> compatible "spi-nand" here?
> >> --
> >> Ezequiel
> >
> > In fact, I don't know how to autodetect the SPI NAND device. Micron
> device and
> > Gigadevice device have different read ID functions. The Chip ID here
> is used to
> > determine which function to use.
> >
> 
> Isn't the difference between the Read ID very minor? One of the vendor
> needs a 2-byte ID read, and the other one needs a 3-byte ID read.
> 
> So you can just try with 2-byte, and if that fails (no vendor ID is
> found on the first byte), you can try with the 3-byte command.
> 
> It's not the most elegant solution, but it's not super awful either.
> --
> Ezequiel

I agree with your idea about try different ways to read ID. It is a better way
to detect the chip if it can work properly.

The difference between the Read ID is that some chips need to send a dummy byte
or address after opcode then read 2 byte, some chips needn't send any data after
opcode but read 3 byte.

I'm concerned maybe chip will get into unknown or vendor specified state if we
send the wrong sequence.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
