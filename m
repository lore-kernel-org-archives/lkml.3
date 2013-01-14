Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3ANGqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 01:46:48 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:39616 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3ANGqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 01:46:46 -0500
MIME-Version: 1.0
In-Reply-To: <20130114002608.GV23505@n2100.arm.linux.org.uk>
References: <50efad8d.84fc440a.589e.ffff9546SMTPIN_ADDED_BROKEN@mx.google.com>
	<CACRpkdYSaFsastx-WWC7sBu8NteAc2hCDZMz4-yMc8+=2dyBVw@mail.gmail.com>
	<50f107aa.894e420a.596a.ffffe3f6SMTPIN_ADDED_BROKEN@mx.google.com>
	<CACRpkdaJd48WOzP_iURATb=c+V6==2-AB2Y9oFyh=E3oe1eT0Q@mail.gmail.com>
	<20130114002608.GV23505@n2100.arm.linux.org.uk>
Date: Mon, 14 Jan 2013 07:46:45 +0100
Message-ID: <CACRpkdbVPeva08nL_FP7qw0MeKLz6h40kPHAz_W95ZBGraOnpg@mail.gmail.com>
Subject: Re: [PATCH] ARM: PL011: Add support for Rx DMA buffer polling
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Chanho Min <chanho.min@lge.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, chanho0207@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 1:26 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> [Me]
>> But it may very well be that the single request can not be
>> enabled for the PL011 for it to work properly.
>
> What you describe above is exactly the problem I see on the Versatile
> platform with it's PL080 and PL011.  I made the comment that this setup
> can't work properly as it stands.  And I don't think that setting a
> timer which fires every jiffy count is really a solution to the problem.
> That's an expensive way of having a per-jiffy callback for something
> that's probably going to remain idle most of the time.

OK then that's what we can expect from an unmodified PL011.

> Not only that, but a 1 jiffy timeout even for slower baud rates is
> just utterly silly.
>
> The point of using DMA is to move the workload off the CPU onto hardware,
> so that the CPU can go off and do other stuff.  If it's having to poll
> it once every jiffy, then...

Agreed.

Chanho, have you considered just leaving RX DMA undefined
and only use DMA for TX?

I know sometimes a programmer will get assigned to "implement
DMA for IP block <foo>", and usually they want to deliver, but
sometimes you have to come back and say "you know that
is not such a good idea".

>> You may not be able to turn this off, and in that case this
>> kind of code is the only way forward indeed.
>
> Unless there's something inbetween the PL080 and PL011 to do that.
> The peripherals themselves don't have any means of controlling this.

We have it working perfectly on U300 and Ux500 but I think
it must be thanks to some hardware modifications.

On the Ux500 it is strictly required since it is used for megabit
rate chips like Bluetooth, and we get successful DMA support
on these.

> The solution I came up with on Versatile was to just not enable
> receive DMA - at all.

Then I suspect I can reproduce it with the PB11MPCore
and PL081 also given some time. I probably just did the tests
the wrong way.

Yours,
Linus Walleij
