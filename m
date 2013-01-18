Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab3ARJbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 04:31:49 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:16167 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3ARJbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 04:31:47 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Richard Genoud <richard.genoud@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "Lin, JM" <JM.Lin@atmel.com>
Subject: RE: [v4 PATCH 00/12] atmel spi controller with dmaengine and device
 tree support
Thread-Topic: [v4 PATCH 00/12] atmel spi controller with dmaengine and
 device tree support
Thread-Index: AQHN8ip3XU+oqYrulUus6q2TYGhEYphORhGAgACSq+A=
Date: Fri, 18 Jan 2013 09:31:29 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436413A05E91C@penmbx02>
References: <1358148877-18679-1-git-send-email-wenyou.yang@atmel.com>
 <CACQ1gAit5KvhNqQsw4MznW4zyGPq5WD9BKHm5KhmcXjOmVjEcg@mail.gmail.com>
In-Reply-To: <CACQ1gAit5KvhNqQsw4MznW4zyGPq5WD9BKHm5KhmcXjOmVjEcg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0I9VpJu003314



> -----Original Message-----
> From: Richard Genoud [mailto:richard.genoud@gmail.com]
> Sent: 2013å¹´1æœˆ18æ—¥ 16:46
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Ferre,
> Nicolas; plagnioj@jcrosoft.com; Lin, JM
> Subject: Re: [v4 PATCH 00/12] atmel spi controller with dmaengine and device
> tree support
> 
> 2013/1/14 Wenyou Yang <wenyou.yang@atmel.com>:
> > Hi All,
> >
> > This set of patches is to add dmaengine and device tree support for atmel spi.
> > The work is based on Nicolas and Richard's work.
> > It is tested on at91sam9x5ek, at91sam9m10g45ek, at91sam9263ek and
> at91sam9g20ek.
> >
> > It is based on v3.8-rc3.
> Hi,
> You should rebase it on rc4 because __devinit macros are gone in rc4.
> (cf 54b956b903607f8f8878754dd4352da6a54a1da2 )
> So the patches 05 and 06 will break compilation.
thanks
> 
> >
> > Changelog:
> > v4:
> >         1./ Take Joe Perches's advance, rewrite atmel_spi_is_v2(struct
> atmel_spi *as)
> >              and atmel_spi_use_dma(struct atmel_spi *as),
> >              and remove atmel_spi_use_pdc(struct atmel_spi *as).
> >
> >         2./ Rebase on v3.8-rc3.
> >
> > V3:
> >         1./ Rebase on v3.8-rc2.
> >
> >         2./ Remove some Jean-Christophe's patches which has been
> >             applied on v3.8-rc2.
> >
> >         3./ Remove spi property "cs-gpios" from the SoC dtsi files
> >             to the board dts files to avoid some useless pin conflicts.
> >
> > v2:
> >         1./ Remove the patch :PATCH]mtd: m25p80: change the
> m25p80_read to reading page to page
> >             which purpose to fix the BUG: when run "flashcp /bin/busybox
> /dev/mtdX" in
> >             the at91sam9g25ek with DMA mode, it arises a OOPS.
> >             Now fix it in this patch:
> >             [PATHC] spi/atmel_spi: add dmaengine support changing to fix
> the [BUG].
> >
> >         2./ Remove two patches:
> >             which purpose to read dts property to select SPI IP version
> and DMA mode
> >             Now they will be gat from device tree different compatile.
> >
> >         3./ Fix DMA: when enable both spi0 AND spi1, the spi0 doesn't
> work BUG.
> >
> >         4./ Rebase v3.7-rc8.
> >
> > Best Regards,
> > Wenyou Yang.
> >
> > Nicolas Ferre (5):
> >   spi/atmel_spi: add physical base address
> >   spi/atmel_spi: call unmapping on transfers buffers
> >   spi/atmel_spi: status information passed through controller data
> >   spi/atmel_spi: add flag to controller data for lock operations
> >   spi/atmel_spi: add dmaengine support
> >
> > Richard Genoud (6):
> >   spi/atmel_spi: fix spi-atmel driver to adapt to slave_config changes
> >   spi/atmel_spi: correct 16 bits transfers using PIO
> >   spi/atmel_spi: correct 16 bits transfer with DMA
> >   ARM: at91: add clocks for spi dt entries
> >   ARM: dts: add spi nodes for atmel SoC
> >   ARM: dts: add spi nodes for the atmel boards
> >
> > Wenyou Yang (1):
> >   spi/atmel_spi: update the dt support
> >
> >  arch/arm/boot/dts/at91sam9260.dtsi          |   18 +
> >  arch/arm/boot/dts/at91sam9263.dtsi          |   18 +
> >  arch/arm/boot/dts/at91sam9263ek.dts         |   14 +
> >  arch/arm/boot/dts/at91sam9g20ek_common.dtsi |   14 +
> >  arch/arm/boot/dts/at91sam9g45.dtsi          |   18 +
> >  arch/arm/boot/dts/at91sam9m10g45ek.dts      |   14 +
> >  arch/arm/boot/dts/at91sam9n12.dtsi          |   18 +
> >  arch/arm/boot/dts/at91sam9n12ek.dts         |   14 +
> >  arch/arm/boot/dts/at91sam9x5.dtsi           |   18 +
> >  arch/arm/boot/dts/at91sam9x5ek.dtsi         |   14 +
> >  arch/arm/mach-at91/at91sam9260.c            |    2 +
> >  arch/arm/mach-at91/at91sam9g45.c            |    2 +
> >  arch/arm/mach-at91/at91sam9n12.c            |    2 +
> >  arch/arm/mach-at91/at91sam9x5.c             |    2 +
> >  drivers/spi/spi-atmel.c                     |  809
> ++++++++++++++++++++++++---
> >  15 files changed, 908 insertions(+), 69 deletions(-)
> >
> > --
> > 1.7.9.5
> >
> 
> 
> 
> --
> for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
