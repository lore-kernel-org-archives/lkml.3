Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3GVBTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:19:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51654 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab3GVBTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:19:18 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Subject: RE: [PATCH 0/3] LP3943 MFD driver for a GPIO expander and a PWM
 generator
Thread-Topic: [PATCH 0/3] LP3943 MFD driver for a GPIO expander and a PWM
 generator
Thread-Index: Ac6BzCtrxTzWOkAHRCW02gELsXHkwADdRRiAAEtgrjA=
Date: Mon, 22 Jul 2013 01:19:10 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E83168@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E815BC@DQHE06.ent.ti.com>
 <CACRpkdaJGwPLzzUuHFZye0N5iAwH2Vn8vbdwz6qv9v4F9bmGbg@mail.gmail.com>
In-Reply-To: <CACRpkdaJGwPLzzUuHFZye0N5iAwH2Vn8vbdwz6qv9v4F9bmGbg@mail.gmail.com>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Thanks for your review.

> On Tue, Jul 16, 2013 at 4:38 AM, Kim, Milo <Milo.Kim@ti.com> wrote:
> 
> > LP3943 is an integrated device capable of driving 16 output channels.
> > It supports a GPIO expander and a PWM generator.
> 
> But actually the data sheet describes it as a LED driver with PWM
> chip.
> 
> Do you have use cases not using it for LEDs but other thing or why
> do you want to model the 16 LED lines as GPIO lines?
> Why can't you just have a drivers/leds/* as for any other LED
> chip?

We have two ways to provide LED functions.

(a) Creating LP3943 LED driver.
This is what you mentioned.
LP3943 MFD will consist of GPIO, LED and PWM drivers

(b) Using a LED PWM driver with the PWM generator
With LP3943 PWM driver, we can control LEDs by using LED PWM driver
under drivers/leds/leds-pwm.c
Then, the MFD consists of just two drivers - GPIO and PWM.
LP3943 PWM driver can be used as general usages -
Not only simple LED drivers but also the PWM signal input for a backlight device.
That's why I prefer to the second way.

> Atleast some good explanation of this needs to be found in the
> patch text and also as comments in Kconfig and the code I think.

I should describe the usage of the 'leds-pwm' driver for LED lighting.
Thanks for this guideline.

Regards,
Milo
