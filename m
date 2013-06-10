Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3FJJEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:04:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42932 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab3FJJEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:04:05 -0400
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
Thread-Index: AQHOVrs+awgkY/qffE2oH2hm7rW75JkpeXoAgAVE88A=
Date: Mon, 10 Jun 2013 09:02:23 +0000
Deferred-Delivery: Mon, 10 Jun 2013 09:02:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EAD887C@DBDE04.ent.ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
 <51B1958C.3050704@ti.com>
In-Reply-To: <51B1958C.3050704@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5A94FlX002686

On Fri, Jun 07, 2013 at 13:40:52, Nori, Sekhar wrote:
> Hi Avinash,
> 
> On 5/22/2013 12:40 PM, Philip Avinash wrote:
> > GPIO Davinci driver converted to platform driver to support DT booting.
> > In this patch series
> > - Cleaned gpio Davinci driver code with proper commenting style and appropriate
> >   variable names.
> > - Create platform driver for GPIO Davinci in da8xx and dm* platforms and removed
> >   gpio related member updation in davinci_soc_info structure.
> > - DT support added for da850 board and tested on da850 EVM.
> > - Remove soc_info reference in the gpio davinci driver and start uses
> >   gpiolib interface.
> 
> Can you please document which platforms this series was tested on and how?

This series being tested on da850 EVM. Tested by setting VPIF_DOUT[12] as GPIO
pin [2] and reading GPIO status from GPIO[7,4]

GPIO[7,4] will reflect the status switch number 8 of the S7 dip switch in DA850 EVM.

Testing Procedure

Requirement GPIO SYSFS support [1]

#echo 116 > /sys/class/gpio/export
setting GPIO[7,4] as input GPIO
#echo "in" > /sys/class/gpio/gpio116/direction
#mount -t debugfs debugfs /sys/kernel/debug
Reading GPIO pin status
#cat /sys/kernel/debug/gpio
#echo 116 > /sys/class/gpio/unexport


1. Enable GPIO SYSFS support through menconfig
--- GPIO Support
	[ ]   Debug GPIO calls
               [ ]   /sys/class/gpio/... (sysfs interface)
 
2. Patch for pinmux support for GPIO[7,4] is available at
https://github.com/avinashphilip/am335x_linux/commits/linux_davinci_v3.10_soc_gpio


Thanks
Avinash

> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
