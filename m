Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbaGSJMD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 05:12:03 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:55576 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768AbaGSJMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 05:12:01 -0400
Date: Sat, 19 Jul 2014 11:11:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] asm-generic/io.h: Implement generic
 {read,write}s*()
Message-ID: <20140719091156.GA31772@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
 <43703371.jktNRIezc3@wuerfel>
 <20140719084152.GA31564@ravnborg.org>
 <4967546.K5Yf5hcJE1@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4967546.K5Yf5hcJE1@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 11:05:33AM +0200, Arnd Bergmann wrote:
> On Saturday 19 July 2014 10:41:52 Sam Ravnborg wrote:
> > > > 
> > > > This set:
> > > > #define inb_p(addr)     inb(addr)
> > > > #define inw_p(addr)     inw(addr)
> > > > #define inl_p(addr)     inl(addr)
> > > > #define outb_p(x, addr) outb((x), (addr))
> > > > #define outw_p(x, addr) outw((x), (addr))
> > > > #define outl_p(x, addr) outl((x), (addr))
> > > > 
> > > > Should have a comment that say they are deprecated.
> > > > Especially the "b" variants still have many users.
> > > 
> > > Are they? I don't remember ever seeing a reason to deprecate
> > > them. We could perhaps enclose them in #ifdef CONFIG_ISA, but
> > > there may also be some drivers that use the same code for ISA
> > > and PCI, and it doesn't really hurt on PCI.
> > 
> > It is my understanding that inl and inl_p are the same these days.
> > A quick grep indicate that only m68k define the
> > _p variant different from the other.
> > But I failed to find and description of the difference between the
> > two which is why I assumed they were identical and thus no need for both.
> 
> I don't know why m68k needs it, it's really an x86-specific
> thing, see slow_down_io() in arch/x86/include/asm/io.h.

I had missed the x86 versions when grepping.
Hmm, and with the macro tricks they play in asm/io.h this
file is not at all grep friendly.

So xxx_p is for pause (or something like that).
This also matches that m68k do some tricks with delay() in the _p variants.
Thanks for the explanation.

	Sam
