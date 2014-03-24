Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaCXNgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:36:50 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:55256 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaCXNgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 09:36:48 -0400
MIME-Version: 1.0
In-Reply-To: <9368307.RXEGmQia1C@wuerfel>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com>
	<1395436128-11244-5-git-send-email-robherring2@gmail.com>
	<20140324112203.GD3850@arm.com>
	<9368307.RXEGmQia1C@wuerfel>
Date: Mon, 24 Mar 2014 08:36:46 -0500
Message-ID: <CAL_JsqJh1R8wxReCvTfE7GecZa0vMaAqnGa0ZoRBMace9qtzvQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] tty/serial: add generic serial earlycon
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 6:29 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 24 March 2014 11:22:03 Catalin Marinas wrote:
>> On Fri, Mar 21, 2014 at 09:08:44PM +0000, Rob Herring wrote:
>> > diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
>> > new file mode 100644
>> > index 0000000..241757a
>> > --- /dev/null
>> > +++ b/drivers/tty/serial/earlycon.c
>> [...]
>> > +static void __iomem * __init earlycon_map(unsigned long paddr, size_t size)
>> > +{
>> > +   void __iomem *base;
>> > +#ifdef CONFIG_FIX_EARLYCON_MEM
>> > +   set_fixmap_nocache(FIX_EARLYCON_MEM_BASE, paddr & PAGE_MASK);
>> > +   base = (void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
>> > +   base += paddr & ~PAGE_MASK;
>> > +#else
>> > +   base = ioremap_nocache(paddr, size);
>> > +#endif
>>
>> Just curious why not set_fixmap_io (and plain ioremap)?
>
> Good point. Note that ioremap_nocache() is the same as ioremap()
> on *all* architectures.

I investigated this before adding this to arm64. set_fixmap_io and
set_fixmap_nocache are not the same settings on x86. Whether the
mapping type really matters on x86 or not, I don't know. So I added
the nocache variant to arm64 to avoid a change to x86.

Rob
