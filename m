Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab3FKGvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:51:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35494 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab3FKGvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:51:14 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/11] Convert GPIO Davinci to platform driver
Thread-Topic: [PATCH 00/11] Convert GPIO Davinci to platform driver
Thread-Index: AQHOVrs+awgkY/qffE2oH2hm7rW75JkpeXoAgAVE88CAAMlDgIAAmNlA
Date: Tue, 11 Jun 2013 06:49:27 +0000
Deferred-Delivery: Tue, 11 Jun 2013 06:49:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EAD9BD5@DBDE04.ent.ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
 <51B1958C.3050704@ti.com>
 <518397C60809E147AF5323E0420B992E3EAD887C@DBDE04.ent.ti.com>
 <51B6A9F5.5020300@ti.com>
In-Reply-To: <51B6A9F5.5020300@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5B6pJ5p010008

On Tue, Jun 11, 2013 at 10:09:17, Nori, Sekhar wrote:
> 
> On 6/10/2013 2:32 PM, Philip, Avinash wrote:
> > On Fri, Jun 07, 2013 at 13:40:52, Nori, Sekhar wrote:
> >> Hi Avinash,
> >>
> >> On 5/22/2013 12:40 PM, Philip Avinash wrote:
> >>> GPIO Davinci driver converted to platform driver to support DT booting.
> >>> In this patch series
> >>> - Cleaned gpio Davinci driver code with proper commenting style and appropriate
> >>>   variable names.
> >>> - Create platform driver for GPIO Davinci in da8xx and dm* platforms and removed
> >>>   gpio related member updation in davinci_soc_info structure.
> >>> - DT support added for da850 board and tested on da850 EVM.
> >>> - Remove soc_info reference in the gpio davinci driver and start uses
> >>>   gpiolib interface.
> >>
> >> Can you please document which platforms this series was tested on and how?
> > 
> > This series being tested on da850 EVM. Tested by setting VPIF_DOUT[12] as GPIO
> > pin [2] and reading GPIO status from GPIO[7,4]
> > 
> > GPIO[7,4] will reflect the status switch number 8 of the S7 dip switch in DA850 EVM.
> > 
> > Testing Procedure
> > 
> > Requirement GPIO SYSFS support [1]
> > 
> > #echo 116 > /sys/class/gpio/export
> > setting GPIO[7,4] as input GPIO
> > #echo "in" > /sys/class/gpio/gpio116/direction
> > #mount -t debugfs debugfs /sys/kernel/debug
> > Reading GPIO pin status
> > #cat /sys/kernel/debug/gpio
> > #echo 116 > /sys/class/gpio/unexport
> > 
> > 
> > 1. Enable GPIO SYSFS support through menconfig
> > --- GPIO Support
> > 	[ ]   Debug GPIO calls
> >                [ ]   /sys/class/gpio/... (sysfs interface)
> >  
> > 2. Patch for pinmux support for GPIO[7,4] is available at
> > https://github.com/avinashphilip/am335x_linux/commits/linux_davinci_v3.10_soc_gpio
> 
> Can you check interrupt generation too since there are significant
> changes in that area? You can generate an interrupt using the MMC/SD
> card detect pin (inserting an MMC/SD card into the slot should generate
> an interrupt). You can also write a new value to any GPIO pin. That will
> also trigger an interrupt.

I have tested GPIO interrupt with GPIO[7,4] by inserting a kernel module in DA850 EVM.
For GPIO interrupt generation DIP switch position changed.

Source code for GPIO test kernel module is shared at
https://github.com/avinashphilip/am335x_linux/commit/affc0c1841beacd8430af689f7f12dcab0cbaf28

> 
> It will be nice if you can test this series on DM365 as well (read/write
> as well as interrupt).

Don't have any DM365 board for testing.

Thanks
Avinash

> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
