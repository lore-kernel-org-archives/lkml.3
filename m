Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485AbaGSJGO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 05:06:14 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55494 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbaGSJGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 05:06:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] asm-generic/io.h: Implement generic {read,write}s*()
Date: Sat, 19 Jul 2014 11:05:33 +0200
Message-ID: <4967546.K5Yf5hcJE1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140719084152.GA31564@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com> <43703371.jktNRIezc3@wuerfel> <20140719084152.GA31564@ravnborg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IsdIxwsS3zw+UsMDzHydNtLFCV2rkzfnVtwiKxWQ2uF
 uoTzbItt+8p6GHHJaBRZOFW6tOUAjGAMQP1YgpMCQK4IHEvArY
 19F00581yxFonB3U95f2Krbh4WPoUs5Yb6Z5kd26DvTZP3nZFj
 gp7fthL9iiF4sagyzrn4QlfDRjW9xtFuKRMtQQievVin9OrgK6
 0MIRM35A2NSuy8sKaf6JQBa/60r3yYTUNlEOVQVpTlJZtiJXNk
 +7IYaHzIzGkabVn6oIE9RNiN3DE+hsMtY+K7KnXb1Ha3j9la1e
 fZibgSnjpJLVK4pT3w5BXEfHhK0blRZsU1uD/7HmUWNsdKFgdx
 NDYNS8ROum4iosz/RAS0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 July 2014 10:41:52 Sam Ravnborg wrote:
> > > 
> > > This set:
> > > #define inb_p(addr)     inb(addr)
> > > #define inw_p(addr)     inw(addr)
> > > #define inl_p(addr)     inl(addr)
> > > #define outb_p(x, addr) outb((x), (addr))
> > > #define outw_p(x, addr) outw((x), (addr))
> > > #define outl_p(x, addr) outl((x), (addr))
> > > 
> > > Should have a comment that say they are deprecated.
> > > Especially the "b" variants still have many users.
> > 
> > Are they? I don't remember ever seeing a reason to deprecate
> > them. We could perhaps enclose them in #ifdef CONFIG_ISA, but
> > there may also be some drivers that use the same code for ISA
> > and PCI, and it doesn't really hurt on PCI.
> 
> It is my understanding that inl and inl_p are the same these days.
> A quick grep indicate that only m68k define the
> _p variant different from the other.
> But I failed to find and description of the difference between the
> two which is why I assumed they were identical and thus no need for both.

I don't know why m68k needs it, it's really an x86-specific
thing, see slow_down_io() in arch/x86/include/asm/io.h.

	Arnd
