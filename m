Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851Ab3JOVfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:35:07 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:38438 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759122Ab3JOVfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:35:05 -0400
MIME-Version: 1.0
In-Reply-To: <201310152132.00409.arnd@arndb.de>
References: <1380635719-31171-1-git-send-email-zonque@gmail.com>
	<CACRpkdYhQ+-d1COcvmg_hEJ==cTFpKLNDnvF8kdK4QgXzHenEA@mail.gmail.com>
	<201310152132.00409.arnd@arndb.de>
Date: Tue, 15 Oct 2013 23:35:03 +0200
Message-ID: <CACRpkdbeHco4iykPeH=NF3hWzWm3UxfAaaTvM4y74NfSbJi2Jw@mail.gmail.com>
Subject: Re: [PATCH] drivers: misc: add gpio wakeup driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Mack <zonque@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 9:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 11 October 2013, Linus Walleij wrote:

>> It *may* be that we have many GPIO drivers that do not accept
>> that you request an interrupt on them before you have done
>> request_gpio() followed by gpio_to_irq() on the pin. Then this
>> shall be treated like a bug and the GPIO driver fixed to handle
>> this. (That was the outcome of this discussion.)
>
> I haven't followed that discussion, but it's good to hear that
> you made some progress there. I find it a bit worrying that you
> say the behavior may be dependent on the gpio driver, but maybe
> I didn't fully understand what the resolution is.

It's some consensus on how to do this, but the existing drivers
need to be augmented to implement it according to that
consensus, especially those using device tree.

If noone else helps I guess it goes on top of the pile of stuff
for the GPIO maintainer to fix...

Yours,
Linus Walleij
