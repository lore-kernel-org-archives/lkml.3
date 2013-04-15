Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab3DOLKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:10:55 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:41660 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510Ab3DOLKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:10:54 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Xie <cxie4@marvell.com>
Date: Mon, 15 Apr 2013 04:10:46 -0700
Subject: RE: [PATCH 3/4] ARM: mmp: bring up pxa988 with device tree support
Thread-Topic: [PATCH 3/4] ARM: mmp: bring up pxa988 with device tree support
Thread-Index: Ac44R2ndRt8hoXhmQlGyjDUXuFLbbgBgmgBA
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE2D0F68CFD9@SC-VEXCH4.marvell.com>
References: <1365651529-11545-1-git-send-email-zhangwm@marvell.com>
 <CAN1soZxhXW=pNGihz6g4arK0zWi7_rzXQyJfuuat0d+Yw+P0Gg@mail.gmail.com>
In-Reply-To: <CAN1soZxhXW=pNGihz6g4arK0zWi7_rzXQyJfuuat0d+Yw+P0Gg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3FBAxoX027833



> -----Original Message-----
> From: Haojian Zhuang [mailto:haojian.zhuang@gmail.com]
> Sent: 2013Äê4ÔÂ13ÈÕ 21:04
> To: Neil Zhang
> Cc: Grant Likely; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; Chao Xie
> Subject: Re: [PATCH 3/4] ARM: mmp: bring up pxa988 with device tree
> support
> 
> On Thu, Apr 11, 2013 at 11:38 AM, Neil Zhang <zhangwm@marvell.com>
> wrote:
> > bring up pxa988 with device tree support.
> >
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > Signed-off-by: Chao Xie <chao.xie@marvell.com>
> > ---
> >  arch/arm/boot/dts/pxa988-dkb.dts          |   36 ++++++
> >  arch/arm/boot/dts/pxa988.dtsi             |  196
> +++++++++++++++++++++++++++++
> >  arch/arm/mach-mmp/Kconfig                 |   25 ++++
> >  arch/arm/mach-mmp/Makefile                |    1 +
> >  arch/arm/mach-mmp/common.c                |   11 ++-
> >  arch/arm/mach-mmp/include/mach/addr-map.h |    6 +
> >  arch/arm/mach-mmp/mmpx-dt.c               |   79
> ++++++++++++
> >  drivers/clk/mmp/Makefile                  |    1 +
> >  8 files changed, 354 insertions(+), 1 deletions(-)  create mode
> > 100644 arch/arm/boot/dts/pxa988-dkb.dts  create mode 100644
> > arch/arm/boot/dts/pxa988.dtsi  create mode 100644
> > arch/arm/mach-mmp/mmpx-dt.c
> >
> > diff --git a/arch/arm/boot/dts/pxa988-dkb.dts
> > b/arch/arm/boot/dts/pxa988-dkb.dts
> > new file mode 100644
> > index 0000000..2cee3ed
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/pxa988-dkb.dts
> > @@ -0,0 +1,36 @@
> > +/*
> > + *  Copyright (C) 2012 Marvell Technology Group Ltd.
> > + *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
> > + *
> > + *  This program is free software; you can redistribute it and/or
> > +modify
> > + *  it under the terms of the GNU General Public License version 2 as
> > + *  publishhed by the Free Software Foundation.
> > + */
> > +
> > +/dts-v1/;
> > +/include/ "pxa988.dtsi"
> > +
> > +
> > +                       gpio@d4019000 {
> > +                               compatible = "mrvl,mmp-gpio";
> Since gpio-pxa driver is updated & merged just now, you need to update this
> as "marvell,mmp-gpio".
> 
Ok, I'll update.

> > +
> > +/* PXA988 */
> > +static const struct of_dev_auxdata pxa988_auxdata_lookup[] __initconst
> = {
> > +       OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000,
> "pxa2xx-uart.0", NULL),
> > +       OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000,
> "pxa2xx-uart.1", NULL),
> > +       OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4036000,
> "pxa2xx-uart.2", NULL),
> > +       OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000,
> "pxa2xx-i2c.0", NULL),
> > +       OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4037000,
> "pxa2xx-i2c.1", NULL),
> > +       OF_DEV_AUXDATA("mrvl,mmp-gpio", 0xd4019000, "pxa-gpio",
> NULL),
> "marvell,mmp-gpio"



Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
