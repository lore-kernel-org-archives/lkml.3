Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3AaCcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 21:32:45 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56387 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab3AaCcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 21:32:42 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: "Coelho, Luciano" <coelho@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: "Poddar, Sourav" <sourav.poddar@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Subject: RE: [PATCH] arm: dts: omap4-sdp: Add I2c pinctrl data
Thread-Topic: [PATCH] arm: dts: omap4-sdp: Add I2c pinctrl data
Thread-Index: AQHN/UkIJ7Wq2boU4Uip5G4oxQAW/ZhhDo8AgAAEAQCAAHreAP//qPWAgAAE7gCAAX/+0A==
Date: Thu, 31 Jan 2013 02:32:27 +0000
Message-ID: <F3DBB1B3EF102E4994C89758CFCA32412C1B46@DBDE01.ent.ti.com>
References: <1359371865-27907-1-git-send-email-sourav.poddar@ti.com>
	 <1359527158.14894.37.camel@cumari.coelho.fi> <5108C052.3070604@ti.com>
	 <F3DBB1B3EF102E4994C89758CFCA32412C16DD@DBDE01.ent.ti.com>
	 <5108DE5F.5090803@ti.com> <1359536770.14894.38.camel@cumari.coelho.fi>
In-Reply-To: <1359536770.14894.38.camel@cumari.coelho.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0V2WqqM017861

On Wed, Jan 30, 2013 at 14:36:10, Coelho, Luciano wrote:
> On Wed, 2013-01-30 at 14:18 +0530, Santosh Shilimkar wrote:
> > On Wednesday 30 January 2013 02:13 PM, Kumar, Anil wrote:
> > > Hi Sourav,
> > >
> > > On Wed, Jan 30, 2013 at 12:10:18, Poddar, Sourav wrote:
> > >> Hi Luciano,
> > >> On Wednesday 30 January 2013 11:55 AM, Luciano Coelho wrote:
> > >>> Hi Sourav,
> > >>>
> > >>> On Mon, 2013-01-28 at 16:47 +0530, Sourav Poddar wrote:
> > >>>> Booting 3.8-rc4 om omap 4430sdp results in the following error
> > >>>>
> > >>>> omap_i2c 48070000.i2c: did not get pins for i2c error: -19
> > >>>> [    1.024261] omap_i2c 48070000.i2c: bus 0 rev0.12 at 100 kHz
> > >>>> [    1.030181] omap_i2c 48072000.i2c: did not get pins for i2c error: -19
> > >>>> [    1.037384] omap_i2c 48072000.i2c: bus 1 rev0.12 at 400 kHz
> > >>>> [    1.043762] omap_i2c 48060000.i2c: did not get pins for i2c error: -19
> > >>>> [    1.050964] omap_i2c 48060000.i2c: bus 2 rev0.12 at 100 kHz
> > >>>> [    1.056823] omap_i2c 4807a000.i2c: did not get pins for i2c error: -19
> > >>>> [    1.064025] omap_i2c 4807a000.i2c: bus 3 rev0.12 at 400 kHz
> > >>>>
> > >>>> This happens because omap4 dts file is not adapted to use i2c through pinctrl
> > >>>> framework. Populating i2c pinctrl data to get rid of the error.
> > >>>>
> > >>>> Tested on omap4430 sdp with 3.8-rc4 kernel.
> > >>>>
> > >>>> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> > >>>> Reported-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > >>>> ---
> > >>> Could you do the same thing for panda? I'm getting the same kind of
> > >>> errors with it:
> > >
> > > omap4 uses pinctrl-single driver for pinmux with DT. Currently
> > > pinctrl-single driver is getting up after I2C driver. So I2c cannot
> > > use pinctrl. The below patch solve this issue
> > >
> > > http://www.gossamer-threads.com/lists/linux/kernel/1669067
> > >
> > > Can you try with this ? it may solve it.
> > >
> > OMAP i2c driver already takes care of -EPROBE_DEFER. The issue
> > as you see from the log is not probe failure but missing the
> > pin information in DT blob. And thats what patch does.
> 
> Yes, Santosh is right.  I tried this patch, but it didn't fix the
> warnings.

Sorry, I misunderstood this issue.

Anil 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
