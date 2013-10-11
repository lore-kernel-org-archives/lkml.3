Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab3JKMy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:54:27 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51117 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3JKMyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:54:25 -0400
MIME-Version: 1.0
In-Reply-To: <5257E3C6.3050507@gmail.com>
References: <1380635719-31171-1-git-send-email-zonque@gmail.com>
	<CACRpkdYhQ+-d1COcvmg_hEJ==cTFpKLNDnvF8kdK4QgXzHenEA@mail.gmail.com>
	<5257E3C6.3050507@gmail.com>
Date: Fri, 11 Oct 2013 14:54:24 +0200
Message-ID: <CACRpkdZWPP+8qJJM60rJvLR7xQvfaHcs-XkabD9zvubTEHFWyA@mail.gmail.com>
Subject: Re: [PATCH] drivers: misc: add gpio wakeup driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Mack <zonque@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
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

On Fri, Oct 11, 2013 at 1:40 PM, Daniel Mack <zonque@gmail.com> wrote:

>> Since what the driver will then eventually provide is to
>> flag an IRQ line as wakeup, I wonder if this should not just
>> simply go into the interrupt core, or atleast of/irq.c.
>
> But for that, the IRQ line must be requested exclusively and handled as
> well, no? If not, how would you handle cases where an interrupt is
> marked as wakeup source by the core, but used by another driver which
> calls disable_irq_wake() on it for whatever reason?

Does this driver handle that?

It rather looks like it hogs both the GPIO and IRQ from anyone
else who want it...

Yours,
Linus Walleij
