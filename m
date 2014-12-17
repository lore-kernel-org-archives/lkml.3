Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaLQWaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:30:24 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:54581 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaLQWaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:30:20 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Steven Miao <realmz6@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips <linux-mips@linux-mips.org>
Subject: Re: rfc: remove early_printk from a few arches? (blackfin, m68k, mips)
References: <1418849927.28384.1.camel@perches.com>
	<CAJiQ=7DE1ojVRW6LqZg2LiqTQ0cgDY_a0nMGn=_Rs1mkuEgwoA@mail.gmail.com>
Date: Wed, 17 Dec 2014 22:30:16 +0000
In-Reply-To: <CAJiQ=7DE1ojVRW6LqZg2LiqTQ0cgDY_a0nMGn=_Rs1mkuEgwoA@mail.gmail.com>
	(Kevin Cernekee's message of "Wed, 17 Dec 2014 13:30:02 -0800")
Message-ID: <yw1xk31phptz.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Cernekee <cernekee@gmail.com> writes:

> On Wed, Dec 17, 2014 at 12:58 PM, Joe Perches <joe@perches.com> wrote:
>> It seems like early_printk can be configured into
>> a few architectures but also appear not to be used.
>>
>> $ git grep -w "early_printk"
> [snip]
>> arch/mips/kernel/Makefile:obj-$(CONFIG_EARLY_PRINTK)    += early_printk.o
>
> Nowadays I try to use OF_EARLYCON whenever possible, but when that has
> been unavailable, I have used arch/mips/kernel/early_printk.c to get
> console output before the serial driver is initialized.  It runs very
> early in the boot sequence and has very few dependencies, which makes
> it useful for board bringup.

EARLY_PRINTK on MIPS is enabled just after prom_init(), well before
OF_EARLYCON is usable.  I'd prefer if it stayed that way.

-- 
Måns Rullgård
mans@mansr.com
