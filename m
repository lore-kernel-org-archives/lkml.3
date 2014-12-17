Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaLQCxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 21:53:21 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:46611 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaLQCxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 21:53:19 -0500
MIME-Version: 1.0
In-Reply-To: <2063145.N1Hk6vVF2S@wuerfel>
References: <1418342706-14755-2-git-send-email-rjui@broadcom.com>
 <1628217.66frkAqHMc@wuerfel> <548F5433.5090901@broadcom.com> <2063145.N1Hk6vVF2S@wuerfel>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 17 Dec 2014 11:52:58 +0900
Message-ID: <CAAVeFu+ZUJ7TJEPQ7Krxw92_giTW_FuD16xmV4vi8D-=O0fO9Q@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] gpio: Cygnus: define Broadcom Cygnus GPIO binding
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ray Jui <rjui@broadcom.com>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>, Joe Perches <joe@perches.com>,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 6:57 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 15 December 2014 13:35:47 Ray Jui wrote:
>>
>> Like I said previously, dynamic GPIO allocation works fine in the
>> kernel, as long as all of our GPIO clients in the kernel use gpiod based
>> API, which is what we will enforce going forward. The only problem is
>> with some of our customers who use GPIO through sysfs and expect fixed
>> global GPIO numbers. Thinking about this more, it's probably not that
>> difficult to add a script for those customers to convert/map the GPIO
>> numbers based on readings parsed from sysfs, so I guess that's fine.
>>
>
> I think we discussed the user space interface a number of times
> in the past, but I forgot the outcome. Either there is already
> a way to name gpio lines uniquely in sysfs, or there should be
> one.
>
> Can you reach the gpio interfaces using /sys/devices/0001234.bus/1234566.gpiocontroller/...?

No, but it seems like this is exactly the solution we need. We could
have an "export" node there that takes a relative GPIO number and
exports it under
/sys/devices/0001234.bus/1234566.gpiocontroller/exported/ the same way
the current sysfs exporter does. Then for convenience we could also
allow exported GPIOs to take names to be used under the shorter
/sys/class/gpio/ (named GPIOs is another request we pushed back many
times but that keeps coming).

Let's see if I can come with a patch. That would at least give us
something to reply to the many people that hit this issue.
