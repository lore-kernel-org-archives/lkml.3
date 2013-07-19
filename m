Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062Ab3GSJ3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:29:32 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35381 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759890Ab3GSJ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:29:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130711161353.GV11243@lukather>
References: <1373121329.13289.2.camel@phoenix>
	<20130711161353.GV11243@lukather>
Date: Fri, 19 Jul 2013 11:29:30 +0200
X-Google-Sender-Auth: S0Jx6Cnrw3vKbRy0DUvsFx9CK_o
Message-ID: <CAMuHMdWP6NtXxmesakPKmxAk1MS2eByEHALAnQQHf8MJcCfk0g@mail.gmail.com>
Subject: Re: [PATCH RFT] irqchip: sun4i: Remove wrong irq_ack callback implementation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Axel Lin <axel.lin@ingics.com>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 6:13 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Sat, Jul 06, 2013 at 10:35:29PM +0800, Axel Lin wrote:
>> According to the datasheet[1], the Interrupt IRQ Pending Registers are
>> read-only. The implementation of sun4i_irq_ack() looks wrong because it writes
>> to these read-only registers.
>
> Right, but the datasheet also says that these registers are "clear"
> register, which might indicate that it's actually R/W.

I guess it means that the flags are cleared automatically on read?
That's not so uncommon for interrupt pending registers.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
