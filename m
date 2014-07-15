Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaGON1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:27:46 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45844 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881AbaGON1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:27:38 -0400
Message-ID: <53C52C46.60207@gmail.com>
Date: Tue, 15 Jul 2014 15:27:34 +0200
From: Pascal Huerst <pascal.huerst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: santosh.shilimkar@ti.com, khilman@deeprootsystems.com,
        linus.walleij@linaro.org, gnurou@gmail.com, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>
Subject: Re: gpio-omap: wakeup mask
References: <53B3F687.5050502@gmail.com> <20140704072752.GC28884@atomide.com> <53BD1683.9030505@gmail.com> <20140709104142.GO28884@atomide.com> <53BD3950.60000@gmail.com> <20140709152441.GZ28884@atomide.com>
In-Reply-To: <20140709152441.GZ28884@atomide.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On 09.07.2014 17:24, Tony Lindgren wrote:
> * Pascal Huerst <pascal.huerst@gmail.com> [140709 05:47]:
>> On 09.07.2014 12:41, Tony Lindgren wrote:
>> 
>>> If you just comment out the _gpio_rmw part above do things work
>>> as expected?
>> 
>> Yes. It only wakes up on gpio 6 not on gpio 11 anymore.
>> 
>>> Then if that works as expected, maybe write only some unused
>>> bits into wkup_en register and see if it still wakes to all
>>> events while it should not?
>> 
>> If I use the following testcode, everything works as expected:
>> 
>> //WARN(true, "WARN: bank->base = %08X\n", bank->base);
>> 
>> if (likely(!(bank->non_wakeup_gpios & gpio_bit))) { 
>> //_gpio_rmw(base, bank->regs->wkup_en, gpio_bit, trigger != 0); 
>> writel(0xABC00000, base + bank->regs->wkup_en);
>> 
>> bank->context.wake_en = readl_relaxed(bank->base + 
>> bank->regs->wkup_en); printk("bank->base = %08X gpio = %i
>> bank->context->wake_en = %08X\n", bank->base, gpio,
>> bank->context.wake_en); }
> 
> Hmm weird. It sounds like something like the following is
> happening:
> 
> 1. The first GPIO bank is always powered, and does not need to set 
> wake-up events

I dont think so. If I apply my hack (commenting the _gpio_rmw() call)
and don't have a wakeup source in the dt, I have to reboot the system,
sonce im not able to wake it up anymore. Or did I miss something?

> 2. When setting the GPIO wake-up events it seems that enabling any 
> wake-up event for the first (16?) bits wakes up the system
> 
> You might want to check this with some spare GPIOs not in the first
> bank and see if you need the wake-up events and if enabling some
> bits enables more than one GPIO for wake-up events.

Im not sure if this makes sense, since only the first gpio bank can
act as a wakeup source. So it should not be possible.


thanks!
pascal
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPFLEYACgkQo7eFcXQQ8U1NcACbBzQiKoU5MO/MLSdrjeg5CaAc
YJcAn3bSthD4ByFOQ31jjOFI1F/HP4Lr
=o4r2
-----END PGP SIGNATURE-----
