Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaAXQwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:52:06 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41734 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaAXQwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:52:03 -0500
MIME-Version: 1.0
In-Reply-To: <52E29310.1040600@saunalahti.fi>
References: <52E29310.1040600@saunalahti.fi>
Date: Fri, 24 Jan 2014 08:52:02 -0800
X-Google-Sender-Auth: MzXzgUmNUJXciraaW7Q-065FlJI
Message-ID: <CALaWCOOB0oT=ehmRbqt1zrp4Ln1w2-rL1scZGVy+PmPBtMTQww@mail.gmail.com>
Subject: Re: Keyboard dead for a bunch of LG laptops
From: Shawn N <shawnn@chromium.org>
To: Joonas Saarinen <jza@saunalahti.fi>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the bug report + bisect.

On Fri, Jan 24, 2014 at 8:21 AM, Joonas Saarinen <jza@saunalahti.fi> wrote:
> Hello, people! There's still lingering an interesting regression where the
> internal keyboard of various older LG laptops is dead. It is tracked here:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=58991
>
> Downstream:
> https://bugzilla.redhat.com/show_bug.cgi?id=969550
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1243904
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1256776
>
> Late last year, I personally did a git bisect on LG LW25 which ended up
> pointing at an atkbd patch:
>
> be2d7e4233a4fe439125b825470020cef83407d5
> Input: atkbd - fix multi-byte scancode handling on reconnect
>
> Full description about that patch and some discussion:
> https://groups.google.com/forum/#!topic/fa.linux.kernel/rUpZ8-HaQIM
>
> Could it be that? The boot parameter i8042.dumbkbd=1 can be used to still
> make the keyboard functional. Of course that workaround leaves the keyboard
> a bit gimped (no lock LEDs, for example).
>
> So, some questions:
>
> 1) What exactly happened? Is there something common with these LG machines'
> BIOS or keyboard controller firmware which causes the problem?
>

It's hard to guess, it seems like a bug / quirk of the KB controller
implementation. It looks like ATKBD_CMD_ENABLE is not re-enabling the
keyboard after ATKBD_CMD_RESET_DIS is received. I will try to acquire
a LG LW25 laptop to debug.

> 2) How could this happen? I thought the i8042 keyboard was one of the
> simplest devices in a PC. It's quite serious if it stops working like this.
>

There are many independent KB controller implementations that use this
driver, each with different bugs / quirks. It's the danger of
modifying such a widely-used driver.

> 3) Should something be done? Those are of course aging (Core 1 Duo era)
> machines, but I think Linux has always strived to work well with all sorts
> of hardware, old and new.
>

I'm not sure what to do here, I will leave the decision to
"management" whether to revert. Meanwhile, I will acquire an LG laptop
that demonstrates this problem, and debug to get a better idea about
the failure case.

>
> Joonas

Shawn
