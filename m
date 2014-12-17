Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaLQVaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 16:30:24 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:39352 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaLQVaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:30:23 -0500
MIME-Version: 1.0
In-Reply-To: <1418849927.28384.1.camel@perches.com>
References: <1418849927.28384.1.camel@perches.com>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Wed, 17 Dec 2014 13:30:02 -0800
Message-ID: <CAJiQ=7DE1ojVRW6LqZg2LiqTQ0cgDY_a0nMGn=_Rs1mkuEgwoA@mail.gmail.com>
Subject: Re: rfc: remove early_printk from a few arches? (blackfin, m68k, mips)
To: Joe Perches <joe@perches.com>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Steven Miao <realmz6@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 12:58 PM, Joe Perches <joe@perches.com> wrote:
> It seems like early_printk can be configured into
> a few architectures but also appear not to be used.
>
> $ git grep -w "early_printk"
[snip]
> arch/mips/kernel/Makefile:obj-$(CONFIG_EARLY_PRINTK)    += early_printk.o

Nowadays I try to use OF_EARLYCON whenever possible, but when that has
been unavailable, I have used arch/mips/kernel/early_printk.c to get
console output before the serial driver is initialized.  It runs very
early in the boot sequence and has very few dependencies, which makes
it useful for board bringup.

At least on MIPS, the EARLY_PRINTK implementation registers itself as
a console and works with standard printk() calls.  It doesn't rely on
arch/driver code explicitly calling early_printk().

Side note: looking through kernel/printk/printk.c it looks like
there's a space missing in the description string:

MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
        "print all kernel messages to the console.");

But since CONFIG_PRINTK is a bool option, I don't know if the
description string actually shows up anywhere.  Should it be converted
into a comment?
