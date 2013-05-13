Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab3EMNAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:00:50 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:58743 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab3EMNAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:00:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130513125452.GA9769@samfundet.no>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
	<alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
	<alpine.DEB.2.00.1305122244300.5463@ayla.of.borg>
	<20130513125452.GA9769@samfundet.no>
Date: Mon, 13 May 2013 15:00:49 +0200
X-Google-Sender-Auth: 5uFgrIXa15Z4gKESWlt_0UTD89k
Message-ID: <CAMuHMdXtYCgCfdowx8v1ZwEfv-Bd1=_XK-UG+8k72YAdyTCJ+g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.10-rc1 (avr)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 2:54 PM, Hans-Christian Egtvedt
<egtvedt@samfundet.no> wrote:
> Around Sun 12 May 2013 22:45:01 +0200 or thereabout, Geert Uytterhoeven wrote:
>> On Sun, 12 May 2013, Geert Uytterhoeven wrote:
>>> However, the full list of errors isn't that unmanageable, so I'm following
>>> up with a digested list...
>>
>> (.init.text+0x540): undefined reference to `atmel_default_console_device': 1 errors in 1 logs
>>       v3.10-rc1/avr32/avr32-allnoconfig
>>       Patch sent last February
>
> I recall to have acked patch(es) related to the serial (console) driver.

Sure, but so far arch/avr doesn't fall under my jurisdiction, so I
haven't sent it
upstream yet ;-)

Anyway, it seems I have accumulated too many patches for exotic
arches, so I plan
to create an exotic-arch-fixes branch, to be pulled by Linus in a few rcs...

> It is caused by CONFIG_SERIAL_ATMEL no set in .config, but the machine code
> still writes to atmel_default_console_device when you call
> at32_setup_serial_console().
>
> Two ways to fix, either select the SERIAL_ATMEL symbol or ifdef around the
> atmel_default_console_device assignment in the machine code.

Yep, my patch did the latter.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
