Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaICKuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:50:22 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.112]:24581 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066AbaICKuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:50:20 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-8.tower-194.messagelabs.com!1409741417!18877281!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        "Lee Jones" <lee.jones@linaro.org>, Axel Lin <axel.lin@ingics.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>,
        Support Opensource <Support.Opensource@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mfd: da9052: Avoid setting read_flag_mask for
 da9052-i2c driver
Thread-Topic: [PATCH] mfd: da9052: Avoid setting read_flag_mask for
 da9052-i2c driver
Thread-Index: AQHPuVVRn2UBiyep9UC8mpS+x6e+UZvl4NIAgAAjh/CACU0hoA==
Date: Wed, 3 Sep 2014 10:50:15 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB51374D@SW-EX-MBX01.diasemi.com>
References: <1408195420.21225.2.camel@phoenix>
 <20140828112052.GL24579@lee--X1>
 <2E89032DDAA8B9408CB92943514A0337AB51182B@SW-EX-MBX01.diasemi.com>
In-Reply-To: <2E89032DDAA8B9408CB92943514A0337AB51182B@SW-EX-MBX01.diasemi.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s83AobLl021686

On August 28, 2014 14:38, Adam Thomson wrote:

> On August 28, 2014 12:21, Lee Jones wrote:
> 
> > Steve, Adam,
> >
> > > Current code init regmap with &da9052_regmap_config for both da9052-spi and
> > > da9052-i2c drivers. da9052-spi sets the read_flag_mask.
> > > The same setting may be applied for da9052-i2c if da9052-spi driver is loaded
> > > first because they actually use the same regmap_config setting.
> > > Fix this issue by using a local variable for regmap_config in da9052-spi driver,
> > > so the settings in spi driver won't impact the settings in i2c driver.
> > > Also makes da9052_regmap_config const to avoid similar issue.
> > >
> > > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> > > ---
> > > Hi Adam and Steve,
> > > Any chance to test this patch?
> >
> > ** Look here **
> 
> Lee, Axel,
> 
> This was on my to-do list but hadn't yet responded. Will try and find some time
> in the next week to see if we can verify this.

Hi Axel, Lee,

I don't think I'm going to have time to test this soon. In terms of the change it looks fine to me, although I don't think you can run both SPI and I2C at the same time for this driver (I tried a quick test to instantiate both and saw issues with regulator initialisation for the second instance). Anyway, here's my ack for the change.

Acked-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
