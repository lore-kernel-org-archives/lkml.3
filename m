Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3JKLk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:40:59 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:44410 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3JKLk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:40:57 -0400
Message-ID: <5257E3C6.3050507@gmail.com>
Date: Fri, 11 Oct 2013 13:40:54 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH] drivers: misc: add gpio wakeup driver
References: <1380635719-31171-1-git-send-email-zonque@gmail.com> <CACRpkdYhQ+-d1COcvmg_hEJ==cTFpKLNDnvF8kdK4QgXzHenEA@mail.gmail.com>
In-Reply-To: <CACRpkdYhQ+-d1COcvmg_hEJ==cTFpKLNDnvF8kdK4QgXzHenEA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 11.10.2013 13:11, Linus Walleij wrote:
> On Tue, Oct 1, 2013 at 3:55 PM, Daniel Mack <zonque@gmail.com> wrote:

>> +Example:
>> +
>> +       wake_up {
>> +               compatible = "gpio-wakeup";
>> +               gpios = <&gpio0 19 0>;
>> +       };
> 
> This will not work if that GPIO chip is not capable of supporting
> interrupts on that GPIO line right?

Of course. It's the IRQ that wakes up the system, after all :)

> We have recently had a very long discussion about this: such
> GPIO chips will also be marked "interrupt-controller" and you
> should be able to just state interrupt-parent and
> interrupts = <>; for this. (And it should accept an array.)

Well, but that's not very intuitive. I was aiming for a drop-in
replacement for what I currently use for this purpose: a fake GPIO key
input device which is marked as wakeup source (linux,wakeup). Schematics
and everything else use GPIO notation, and so should the DTB binding here.

> Since what the driver will then eventually provide is to
> flag an IRQ line as wakeup, I wonder if this should not just
> simply go into the interrupt core, or atleast of/irq.c.

But for that, the IRQ line must be requested exclusively and handled as
well, no? If not, how would you handle cases where an interrupt is
marked as wakeup source by the core, but used by another driver which
calls disable_irq_wake() on it for whatever reason?


Thanks,
Daniel

