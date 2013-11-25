Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3KYOe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:34:26 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40928 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab3KYOeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:34:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2UjnL5bZzNUuJhWY3GpwPD=rJvR2O4Hcpm33G+prSS=BA@mail.gmail.com>
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
	<528BB1F2.4080107@wwwdotorg.org>
	<CAD=FV=XS0dbE7zfgDGVdp84h4fHH6tfO8aN_HNh1LbOjYy51aQ@mail.gmail.com>
	<528BB913.6080409@wwwdotorg.org>
	<CAH9JG2UjnL5bZzNUuJhWY3GpwPD=rJvR2O4Hcpm33G+prSS=BA@mail.gmail.com>
Date: Mon, 25 Nov 2013 15:34:19 +0100
Message-ID: <CACRpkdbyjm0X9RX+8WjqQxBPyRjBOAunkqVcO-0KUd1PTdGavA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized using pinfunc.
From: Linus Walleij <linus.walleij@linaro.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Doug Anderson <dianders@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 1:02 AM, Kyungmin Park <kmpark@infradead.org> wrote:
> On Wed, Nov 20, 2013 at 4:16 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:

>> I think that last point should be addressed by having a driver that owns
>> the GPIO set it to the desired output level, and the implementation of

> Some pins are not connected (NC). At that cases, there's no drivers to
> handle it. To reduce power leakage, it sets proper configuration with
> values instead of reset values.

This is correspondant to the PIN_CONFIG_OUTPUT from
include/linux/pinctrl/pinconf-generic.h

I.e. driving a pin - any pin, even one that cannot do GPIO - high
or low as default.

One could argue that if you can drive the pin high/low using
software then by definition it *is* GPIO. Even if it cannot trigger
IRQs or anything.

The rationale for having it in pinconf-generic is basically for
use cases such that one of the the pin config states the device
pass through may relate to what the documentation calls
the "GPIO mode fallacy" - a state on the pins that is definately
related to the use case of a certain device, but puts the pin
in something the manual calls "GPIO mode" in order to save
power.

But from a use case point of view that is not GPIO, it is the
typically the sleep state of a certain pin when used with a
certain device.

I'll see if I can think of some doc patch to make this more clear...

Yours,
Linus Walleij
