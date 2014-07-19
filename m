Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbaGSImE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 04:42:04 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:44231 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaGSImB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 04:42:01 -0400
Date: Sat, 19 Jul 2014 10:41:52 +0200
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
Message-ID: <20140719084152.GA31564@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
 <20140718205953.GA21964@ravnborg.org>
 <20140718210631.GA22109@ravnborg.org>
 <43703371.jktNRIezc3@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43703371.jktNRIezc3@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > This set:
> > #define inb_p(addr)     inb(addr)
> > #define inw_p(addr)     inw(addr)
> > #define inl_p(addr)     inl(addr)
> > #define outb_p(x, addr) outb((x), (addr))
> > #define outw_p(x, addr) outw((x), (addr))
> > #define outl_p(x, addr) outl((x), (addr))
> > 
> > Should have a comment that say they are deprecated.
> > Especially the "b" variants still have many users.
> 
> Are they? I don't remember ever seeing a reason to deprecate
> them. We could perhaps enclose them in #ifdef CONFIG_ISA, but
> there may also be some drivers that use the same code for ISA
> and PCI, and it doesn't really hurt on PCI.

It is my understanding that inl and inl_p are the same these days.
A quick grep indicate that only m68k define the
_p variant different from the other.
But I failed to find and description of the difference between the
two which is why I assumed they were identical and thus no need for both.


	Sam
