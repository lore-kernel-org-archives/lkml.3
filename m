Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbaDJScK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:32:10 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:43708 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758897AbaDJScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:32:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4wEbDhcYa5sK0e6eVKOyHRJA4HSZWsd_83WGbAsviEToQ@mail.gmail.com>
References: <1396960077-30599-1-git-send-email-linus.walleij@linaro.org>
	<CAGsJ_4yfCcQoMmUD08HBJDkXSPUOuUP-Sj9EZAJZ8grpodReiw@mail.gmail.com>
	<CAGsJ_4wEbDhcYa5sK0e6eVKOyHRJA4HSZWsd_83WGbAsviEToQ@mail.gmail.com>
Date: Thu, 10 Apr 2014 20:32:04 +0200
Message-ID: <CACRpkdbz5uP+MNJn22z-GVuonZ_ungNwqfsNT6aB7r0pd0vHxQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: sirf: switch driver to use gpiolib irqchip helpers
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <baohua@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Barry Song <Baohua.Song@csr.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 11:30 AM, Barry Song <baohua@kernel.org> wrote:

>> with this:
>> # cat /proc/interrupts
>>            CPU0
>>  16:        944  irq_sirfsoc   0  sirfsoc_timer0
>> ...
>> 105:          0  sirf-gpio-irq  13  extcon-gpio
>> ...
>>
>> i will do a debug to find why. any idea from you?
>
> hi linus, after reading the source codes of GPIOLIB_IRQCHIP, i think
> the new irq number after applying your patch should not be a problem.
> the reason is that you create irq mapping earlier in
> gpiochip_irqchip_add(), but the old codes did it later on demand in
> sirfsoc_gpio_to_irq().

Yeah it's just some number, it's dynamically allocated to you should
not need to worry about that. It could even change with probe order
due to unpredictable things.

> the real problem here is that we have several gpio banks, but there is
> only one device node, so i think this should be not good and will make
> the gpiochip_irq_reqres(), gpiochip_irq_relres() fail since
> sub-devices can only point its interrupt parent to the only gpio node,
> this makes hwirq bigger than the size of the gpio bank.
>
> so will you wait for me to send a patch to merge all banks into one
> gpio_chip just as i have done by commit
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8daeffb058f78deb0b0ef2cb67ef741c38788bf9
> to merge irq_domain?

Sure I'm standing by.

Bonus points if you rebase my patch on top of it and send it
as patch 2/2 :-D

Yours,
Linus Walleij
