Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3LLTPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:15:21 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:57931 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3LLTPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:15:19 -0500
MIME-Version: 1.0
In-Reply-To: <52A7C4BB.6000701@codeaurora.org>
References: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1386295805-13708-3-git-send-email-bjorn.andersson@sonymobile.com>
	<52A24E08.706@codeaurora.org>
	<20131210084140.GF11990@sonymobile.com>
	<52A7C4BB.6000701@codeaurora.org>
Date: Thu, 12 Dec 2013 20:15:18 +0100
Message-ID: <CACRpkdY9Z71VcS6ERiaDbg9P7qPEK_jCVXLvoCDx6YztYCnR2Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] pinctrl: Add msm8x74 configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 2:49 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 12/10/13 00:41, Bjorn Andersson wrote:
>> On Fri 06 Dec 14:22 PST 2013, Stephen Boyd wrote:

>>> Also, do we ever plan to have anything more than the gpio pins and the
>>> sdc pins? It seems like we spend a lot of space describing exactly the
>>> same thing in these structs for each of the 146 gpio pins when we could
>>> just know that range 0 to 146 is gpio pins and have different code for
>>> that part vs the 6 or something sd pins.
>>>
>> We have to have a pingroup list, so I did look at having that list
>> referencing a common object with the gpio/sdc specific data.
>>
>> But just having it in one large blob is the way that other pinctrl
>> drivers does it and hence a common problem to pinctrl and multi-platform
>> arm support.
>
> I don't follow what Linus is recommending. How could
> .gpio_request_enable()/.gpio_disable_free() help us here?

That removes the need to define a single group for each pin that
can be used as GPIO.

It is described in Documentation/pinctrl.txt under the heading
"Pin control interaction with the GPIO subsystem"

On a related key I guess drivers/gpio/gpio-msm-v2.c needs
to be patched to call pinctrl_request_gpio()/
pinctrl_free_gpio()/pinctrl_gpio_direction_input()/
pinctrl_gpio_direction_output() before the GPIO back-end
works at all so there is still time to change this (plus it is
not part of the DT binding or anything so it can be changed
at any time).

Yours,
Linus Walleij
