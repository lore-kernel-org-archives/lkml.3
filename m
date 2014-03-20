Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbaCTKXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:23:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61436 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308AbaCTKXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <1394481265-7275-1-git-send-email-geert@linux-m68k.org>
References: <1394481265-7275-1-git-send-email-geert@linux-m68k.org>
Date: Thu, 20 Mar 2014 11:23:00 +0100
X-Google-Sender-Auth: sBpKxeSQkk0jkM2UcVLO4Q_8ER0
Message-ID: <CAMuHMdVmrEoRkqUB=3mBRNrPEJiR701YUmr8C7HX1O6UxT_NUg@mail.gmail.com>
Subject: Re: [PATCH/RFC] serial_core: Fix pm imbalance on unbind
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Mar 10, 2014 at 8:54 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> When a serial port is closed, uart_close() takes care of shutting down the
> hardware, and powering it down.
>
> When a serial port is unbound while in use, uart_close() bypasses all of
> this, as this is supposed to be done through uart_hangup() (invoked via
> tty_vhangup() in uart_remove_one_port()).
>
> However, uart_hangup() does not set the hardware's power state, leaving it
> powered up.  This may also lead to unbounded nesting counts in clock and
> power management, depending on their internal implementation.
>
> Make sure to power down the port in uart_hangup(), except when the port is
> used as a serial console. For serial consoles, this must be postponed until
> after their deregistration in uart_remove_one_port() (symmetry with
> registration in uart_configure_port(), invoked from uart_add_one_port()).
>
> After this, the module clock used by the sh-sci driver is disabled on
> unbind while the serial port is in use.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

I noticed you have applied all serial patches I've sent, except for this one.
Is there any specific reason you skipped this one?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
