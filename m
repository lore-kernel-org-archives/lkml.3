Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab3ANH1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 02:27:42 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:58629 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3ANH1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 02:27:38 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbVPeva08nL_FP7qw0MeKLz6h40kPHAz_W95ZBGraOnpg@mail.gmail.com>
References: <50efad8d.84fc440a.589e.ffff9546SMTPIN_ADDED_BROKEN@mx.google.com>
	<CACRpkdYSaFsastx-WWC7sBu8NteAc2hCDZMz4-yMc8+=2dyBVw@mail.gmail.com>
	<50f107aa.894e420a.596a.ffffe3f6SMTPIN_ADDED_BROKEN@mx.google.com>
	<CACRpkdaJd48WOzP_iURATb=c+V6==2-AB2Y9oFyh=E3oe1eT0Q@mail.gmail.com>
	<20130114002608.GV23505@n2100.arm.linux.org.uk>
	<CACRpkdbVPeva08nL_FP7qw0MeKLz6h40kPHAz_W95ZBGraOnpg@mail.gmail.com>
Date: Mon, 14 Jan 2013 16:27:37 +0900
X-Google-Sender-Auth: OkjukcVi71fMM5bHATlUvs2DK88
Message-ID: <CAOAMb1BgcvBb6KHaZbwbh0rq8r1WfAtdCeZJexfaYoOwGfU7Sg@mail.gmail.com>
Subject: Re: [PATCH] ARM: PL011: Add support for Rx DMA buffer polling
From: Chanho Min <chanho.min@lge.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 3:46 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Jan 14, 2013 at 1:26 AM, Russell King - ARM Linux
>> What you describe above is exactly the problem I see on the Versatile
>> platform with it's PL080 and PL011.  I made the comment that this setup
>> can't work properly as it stands.  And I don't think that setting a
>> timer which fires every jiffy count is really a solution to the problem.
>> That's an expensive way of having a per-jiffy callback for something
>> that's probably going to remain idle most of the time.
>
> OK then that's what we can expect from an unmodified PL011.
>
>> Not only that, but a 1 jiffy timeout even for slower baud rates is
>> just utterly silly.
>>
>> The point of using DMA is to move the workload off the CPU onto hardware,
>> so that the CPU can go off and do other stuff.  If it's having to poll
>> it once every jiffy, then...
>
> Agreed.

I agree also. So We hope to suggest a way to reduce such cost.
Rx DMA is required for the fast baud only. PIO is sufficient for the
slow baud rate.
So this feature is optional for the specific port.
1 jiffy timeout is experimental and adjustable. Even 100ms, It will be
better than
remain in the DMA buffer. Also, the polling interval can be adjusted
according to
baud rate as Russel mentioned.

> Chanho, have you considered just leaving RX DMA undefined
> and only use DMA for TX?

No, We need RX DMA to reduce data loss rather than TX DMA.

>> The solution I came up with on Versatile was to just not enable
>> receive DMA - at all.

We just want to use this HW function even if SW support is needed.
Anyway, It was very useful for megabyte rate chips.

Thanks
Chanho
