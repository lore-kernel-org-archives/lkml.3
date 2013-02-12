Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab3BLM3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:29:15 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:56357 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815Ab3BLM3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:29:11 -0500
MIME-Version: 1.0
In-Reply-To: <51192CC5.9060300@wwwdotorg.org>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
	<1359822572-26009-8-git-send-email-acourbot@nvidia.com>
	<CACRpkdbib-+pvMiLQN=f6d-1dhK2OK3znJeGoL7rDxDQYuJRuA@mail.gmail.com>
	<CAAVeFu+phNtzzj7rw96g9iH8sj9gGqd5SfAqtkDHvu3PeL_oQA@mail.gmail.com>
	<20130209091729.978C73E1A18@localhost>
	<CACRpkdagLssOG3FW8Qr1zqFabGMgdupADwg1=c0eQ7e76_XM5A@mail.gmail.com>
	<51192CC5.9060300@wwwdotorg.org>
Date: Tue, 12 Feb 2013 13:29:10 +0100
Message-ID: <CACRpkdaHuv7CXCy15-o94G0r0+2BStsi34ZVbBAhyGj=U3xgOg@mail.gmail.com>
Subject: Re: [PATCH 6/9] gpiolib: use descriptors internally
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 6:39 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 02/11/2013 07:09 AM, Linus Walleij wrote:

>> However if you take this all the way to the descriptor API
>> it will make the consumer (driver) API for GPIO descriptors deviate
>> from what is today used for clocks, regulators and pins.
>>
>> With all the resulting confusion for users.
>> I've seen worse subsystem deviations though.
>
> Sorry I haven't looked at the specific APIs this discussion refers to,
> but clients of the GPIO descriptor API are going to need to distinguish
> "fail" from "deferred probe", so at least some initial get-like API will
> need to pass back some error detail...

Right, so in some other patch I stated that this would lead
to a GPIO descriptor fetch interface such as this:

int gpiod_get(struct gpiod_desc **gpiod, struct device *dev, const char *name);

Rather than the more established:

struct gpio_desc *gpiod_get(struct device *dev, const char *name);

And I'm worried about the lack of consistency.

While I do get the point... I chatted with Grant about it and
I want to talk to some toolchain people about this to see if
pointers containing potential error codes can somehow be
"flagged" by the compiler so we can enforce error checking on
them. (It may sound a bit utopic...)

Yours,
Linus Walleij
