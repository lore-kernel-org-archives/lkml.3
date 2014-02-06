Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbaBFLqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:46:31 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.116]:26465 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756081AbaBFLq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:46:29 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-14.tower-193.messagelabs.com!1391687186!10777890!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Guenter Roeck <linux@roeck-us.net>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
CC: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: RE: [PATCH 0/8] da9055: Driver initialisation fixes, add DT support
Thread-Topic: [PATCH 0/8] da9055: Driver initialisation fixes, add DT support
Thread-Index: AQHPItX1UYPlsXnnXUG/ucZmMBjnFpqoG//w
Date: Thu, 6 Feb 2014 11:46:25 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A03376B7E368A@SW-EX-MBX02.diasemi.com>
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
 <20140206005406.GC1308@roeck-us.net>
In-Reply-To: <20140206005406.GC1308@roeck-us.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s16BkYvU004728

On Thu, Feb 06, 2014 at 00:54:11AM +0000, Guenter Roeck wrote:

> Adam,
> 
> You don't really explain what the problem actually is. Can you elaborate ?

Sorry, yes. For the conflicting device Ids, both the PMIC and the CODEC used
the same I2C Id string, which meant if you tried to intiate both together on the
same bus, then the second would fail.

For the removal of platform_get_irq_byname(), the reason for this was that it
was conflicting with regmap_irq_get_virq() when the IRQ value returned from
platform_get_irq_byname() was being passed to regmap_irq_get_virq(). The result
for the code was that it would try to request a threaded IRQ using an invalid
IRQ number (have also described this further in patch 0004 mail thread,
https://lkml.org/lkml/2014/2/6/126).

> 
> Also, I have been using platform_get_irq() to get the interrupt resource
> in mfd client drivers and similar situations. Wouldn't this work here as well
> if you don't want to use platform_get_irq_byname() ?

What I could've done is use platform_get_irq_byname() and avoided using
regmap_irq_get_virq() as I would already have the correct VIRQ to pass to
request_threaded_irq(), but I figured that using regmap_irq_get_virq() made
more sense at the time, and was unable to use both.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
