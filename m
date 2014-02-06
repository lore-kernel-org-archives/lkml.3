Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbaBFNbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:31:31 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.170]:46694 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756492AbaBFNb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:31:27 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-4.tower-39.messagelabs.com!1391693483!11823852!1
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
Thread-Index: AQHPItX1UYPlsXnnXUG/ucZmMBjnFpqoG//wgAAbW4CAAAI1UA==
Date: Thu, 6 Feb 2014 13:31:22 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A03376B7E36D8@SW-EX-MBX02.diasemi.com>
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
 <20140206005406.GC1308@roeck-us.net>
 <2E89032DDAA8B9408CB92943514A03376B7E368A@SW-EX-MBX02.diasemi.com>
 <52F38CA1.8020806@roeck-us.net>
In-Reply-To: <52F38CA1.8020806@roeck-us.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s16DVjLM005276

On Thu, Feb 06, 2014 at 13:23:47PM +0000, Guenter Roeck wrote:

> > What I could've done is use platform_get_irq_byname() and avoided using
> > regmap_irq_get_virq() as I would already have the correct VIRQ to pass to
> > request_threaded_irq(), but I figured that using regmap_irq_get_virq() made
> > more sense at the time, and was unable to use both.
> >
> 
> I may be missing something, but I think the problem may be that you are
> doing two mappings instead of just one. I don't think you need to call
> regmap_irq_get_virq() at all.

Yes, you're correct. The issue was already there in the code and I was
attempting to fix it. When I made the change I figured using only
regmap_irq_get_virq() was the way to go, but seems like I chose the wrong
option. Will make the changes (remove regmap_irq_get_virq()), test on both DT
and non-DT platforms, and then will re-submit the patches.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
