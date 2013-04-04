Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763714Ab3DDGjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:39:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53186 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763445Ab3DDGju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:39:50 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "jacmet@sunsite.dk" <jacmet@sunsite.dk>
Subject: RE: [PATCH v3 0/3] Platform support for EHRPWM & ECAP devices in
 DAVINCI.
Thread-Topic: [PATCH v3 0/3] Platform support for EHRPWM & ECAP devices in
 DAVINCI.
Thread-Index: AQHOKS025VCF1N5DVkK+rONLQqIK75jCS2qAgAH7zpCAAPqkAIAAYs/g
Date: Thu, 4 Apr 2013 06:38:24 +0000
Deferred-Delivery: Thu, 4 Apr 2013 06:38:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EAA7CD5@DBDE01.ent.ti.com>
References: <1364197789-16783-1-git-send-email-avinashphilip@ti.com>
 <515A983D.8040907@ti.com>
 <518397C60809E147AF5323E0420B992E3EAA7C39@DBDE01.ent.ti.com>
 <515D1478.4030700@ti.com>
In-Reply-To: <515D1478.4030700@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r346drJo000791

On Thu, Apr 04, 2013 at 11:19:44, Nori, Sekhar wrote:
> On 4/4/2013 10:09 AM, Philip, Avinash wrote:
> > On Tue, Apr 02, 2013 at 14:05:09, Nori, Sekhar wrote:
> >> On 3/25/2013 1:19 PM, Philip Avinash wrote:
> >>> Add platform support for EHRPWM and ECAP by providing clock nodes and
> >>> device tree nodes.
> >>> This series depends on [1] and [2] and is available for testing at [3].
> >>> Tested for back light support in da850 EVM with EHRPWM PWM device.
> >>>
> >>> [1] http://gitorious.org/linux-davinci/linux-davinci/trees/davinci-for-v3.9/dt-2
> >>> [2] https://gitorious.org/linux-pwm/linux-pwm/trees/for-next
> >>> [3] https://github.com/avinashphilip/am335x_linux/tree/davinci-for-v3.9_soc_pwm
> >>>
> >>> Note:
> >>> DT support for EHRPWM backlight has not been added in da850-evm.dts as there is
> >>> conflicting pin-mux requirement with SPI flash.
> >>
> >> Can you check if this is really true even in newer boards (have a look
> >> at the latest schematics)? I remember this used to be a problem in very
> >> early versions but was fixed later.
> > 
> > On looking schematics, panel has three power controls LCD_BACKLIGHT_PWR, LCD_PANEL_PWR,
> > LCD_PWM0. On latest schematic, LCD_PWM0 is connected to ECAP instance 2. So backlight
> > can control through ECAP2 (not conflicting with SPI1 cs0). Still for controlling
> > backlight, require support for LCD_BACKLIGHT_PWR & LCD_PANEL_PWR. These signals
> 
> By controlling above you mean "switching on/off"? Otherwise this seems
> to be contradicting the statement just before.

Yes these lines should be switching on/off.

> 
> > to be controlled by GPIO 2[8] & GPIO 2[15]. In release platform callbacks used
> > to control GPIO functionality. But with DT support, I have to check how platform
> > callbacks can be used.
> 
> Platform callbacks are not possible with DT.

Ok.

> You can look at what freescale mxsfb.c does. Look for panel-enable-gpios DT binding.

I will use GPIO pin configuration info from DT nodes. From probe GPIO pin make active and
in remove disable GPIO pin.

Thanks
Avinash

> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
