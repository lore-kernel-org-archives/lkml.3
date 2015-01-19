Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbbASIzC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:55:02 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:34476 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbbASIy7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:54:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFu+K0W96mi0=QR8JGSe9BpH2nC5WV_9qbSvm6LJGA8gc7Q@mail.gmail.com>
References: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
	<20150116111108.GG30960@localhost>
	<a4610e13d0094d40b7e0574992509ec6@BN1AFFO11FD044.protection.gbl>
	<CAAVeFu+K0W96mi0=QR8JGSe9BpH2nC5WV_9qbSvm6LJGA8gc7Q@mail.gmail.com>
Date: Mon, 19 Jan 2015 09:54:58 +0100
Message-ID: <CACRpkdZ4CekD2xeJYM+UUtuGuwS2uB++XprSueWnshEVk=79Fw@mail.gmail.com>
Subject: Re: [PATCH v4] gpio: lib-sysfs: Add 'wakeup' attribute
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Johan Hovold <johan@kernel.org>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 5:20 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Sat, Jan 17, 2015 at 1:49 AM, Sören Brinkmann <soren.brinkmann@xilinx.com> wrote:
>> On Fri, 2015-01-16 at 12:11PM +0100, Johan Hovold wrote:

>>> Implementing proper wakeup support for unclaimed GPIOs would take some
>>> work (if at all desired), but that is not a reason to be adding custom
>>> implementations that violates the kernel's power policies and new ABIs
>>> that would need to be maintained forever.
(...)
>>> Meanwhile you can (should) use gpio-keys if you need to wake your system
>>> on gpio events.
>>
>> We had that discussion and I don't think GPIO keys is the right solution
>> for every use-case.
>
> Sorry, it has been a while - can you remind us of why?

There are such cases. Of course keys should be handled by GPIO-keys
and these will trigger the right wakeup events in such cases.

This is for more esoteric cases: we cannot have a kernel module for
everything people want to do with GPIOs, and the use case I accept
is GPIOs used in automatic control etc, think factory lines or doors.
We can't have a "door" driver or "punch arm" or "fire alarm" driver
in the kernel. Those are userspace things.

Still such embedded systems need to be able to go to idle and
sleep to conerve power, and then they need to put wakeups on
these GPIOs.

So it is a feature userspace needs, though as with much of the
sysfs ABI it is very often abused for things like keys and LEDs which
is an abomination but we can't do much about it :(

Yours,
Linus Walleij
