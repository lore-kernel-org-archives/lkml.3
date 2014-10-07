Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaJGOOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:14:14 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:40896 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaJGOOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:14:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140930170203.GR28481@sonymobile.com>
References: <1410792254-24126-1-git-send-email-iivanov@mm-sol.com>
	<1410792254-24126-4-git-send-email-iivanov@mm-sol.com>
	<20140924041852.GO10179@sonymobile.com>
	<1411564172.18580.69.camel@iivanov-dev>
	<20140930170203.GR28481@sonymobile.com>
Date: Tue, 7 Oct 2014 16:14:10 +0200
Message-ID: <CACRpkdaRZSyPFTHt4CnCUy6Qhcpkvqc4F9P90oA0Dj7PhtXOwg@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] pinctrl: Qualcomm SPMI PMIC GPIO pin controller driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        David Collins <collinsd@codeaurora.org>,
        Wu Fenglin <fenglinw@qti.qualcomm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 7:02 PM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
> On Wed 24 Sep 06:09 PDT 2014, Ivan T. Ivanov wrote:

>> I am unable to make this work. of_gpio_simple_xlate() didn't know that
>> GPIO range is offset with 1. Requesting last GPIO return error. And
>> debug output looks weird, for example:
>>
>> # cat /sys/kernel/debug/gpio
>> ...
>> GPIOs 220-255, platform/0.c000.gpios, 0.c000.gpios:
>> ...
>>
>> # cat /sys/kernel/debug/pinctrl/0.c000.gpios/gpio-ranges
>> GPIO ranges handled:
>> 1: 0.c000.gpios GPIOS [221 - 256] PINS [0 - 35]
>>
>> Advice, please.
>
> Looking at of_gpio_simple_xlate() shows that you're right. It doesn't seem to
> be possible to have a gpiochip that is not 0-based. Then I guess you have to
> have your own "off-by-one-xlate".
>
> @Linus, any comments on this? All documentation states that we have
> gpio1-gpioXX in these chips, so we have to expose it as such or things will be
> messy.

I remember that drivers/pinctrl/nomadik/pinctrl-abx500.c had the
same problem, but I don't remember how we solved it sadly :-/

Yours,
Linus Walleij
