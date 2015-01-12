Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbbALJkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:40:08 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:65374 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbbALJkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:40:05 -0500
MIME-Version: 1.0
In-Reply-To: <20141202161227.GH30256@lukather>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
	<1416527684-19017-2-git-send-email-bparrot@ti.com>
	<CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
	<20141201163639.GI25249@lukather>
	<CAAVeFuLTupDenZdSi8KO+dYsf-ekcqjsDaQ2GEzYpBG34oF7Zw@mail.gmail.com>
	<CACRpkdZcNcPBYQM438CZJx1gYst9BFBSTj-3Qv2aPGF9pdWa5g@mail.gmail.com>
	<20141202161227.GH30256@lukather>
Date: Mon, 12 Jan 2015 10:40:04 +0100
Message-ID: <CACRpkdYuRSi8B7jr2F1zYZB4OHvpH9EXOmU0qGa9+O77gcNA7g@mail.gmail.com>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mark Brown <broonie@kernel.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Benoit Parrot <bparrot@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 5:12 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Tue, Dec 02, 2014 at 03:29:46PM +0100, Linus Walleij wrote:
>> On Tue, Dec 2, 2014 at 3:13 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
>> > On Tue, Dec 2, 2014 at 1:36 AM, Maxime Ripard
>> > <maxime.ripard@free-electrons.com> wrote:
>>
>> >> The only thing I'd like to have would be that the request here would
>> >> be non-exclusive, so that a later driver would still be allowed later
>> >> on to request that GPIO later on and manage it itself (ideally using
>> >> the usual gpiod_request function).
>> >
>> > Actually we have a plan (and I have some code too) to allow multiple
>> > consumers per GPIO. Although like Benoit I wonder why you would want
>> > to hog a GPIO and then request it properly later. Also, that probably
>> > means we should abandon the hog since it actively drives the line and
>> > would interfere with the late requested. How to do that correctly is
>> > not really clear to me.
>>
>> I don't get the usecase. A hogged GPIO is per definition hogged.
>> This sounds more like "initial settings" or something, which is another
>> usecase altogether.
>
> We do have one board where we have a pin (let's say GPIO14 of the bank
> A) that enables a regulator that will provide VCC the bank B.
>
> Now, both banks are handled by the same driver, but in order to have a
> working output on the bank B, we do need to set GPIO14 as soon as
> we're probed.
>
> Just relying on the usual deferred probing introduces a circular
> dependency between the gpio-regulator that needs to grab its GPIO from
> a driver not there yet, and the gpio driver that needs to enable its
> gpio-regulator.
>
> GPIO hogging needs to be the ideal solution for that, since we can
> just enforce the GPIO14 value as the driver is probed, which provides
> the guarantee that any driver using the bank B will actually drive the
> GPIO it might use.
>
> However, an exclusive request will prevent any representation of this
> as a regulator, which sounds a bit weird, since it really is just
> that.

Well that's elegant...

I think it's a hog in this case though, not a GPIO regulator,
definately not both. But let's check Mark's opinion on this.

Yours,
Linus Walleij
