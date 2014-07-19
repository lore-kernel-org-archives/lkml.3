Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbaGSHix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 03:38:53 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:63209 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaGSHiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 03:38:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] asm-generic/io.h: Implement generic {read,write}s*()
Date: Sat, 19 Jul 2014 09:38:33 +0200
Message-ID: <43703371.jktNRIezc3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140718210631.GA22109@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com> <20140718205953.GA21964@ravnborg.org> <20140718210631.GA22109@ravnborg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:KiSHmGDiSv+u6P1FfnMVL6VoPU/OH/il0UV1KU/DZwb
 PKCReSWyblhbMBMSRHu1CYxjStZXrjLhLIxUw9ZatA0emfQQjR
 9Tb+zTijbv5oTHaSOQ+q4HN2LKgGrIStp6o62yiS20QuHSFWdY
 ogSXVDpaPhFyEGtO7PWN7rV+DBRI/kIRG6TUt5DV5yzfPdOjcz
 06y1aRr2SOMvlCIMzAT4PftB4S2AiT9QEbF38JWbAnB3XxF1q2
 Ce9D5RicMw4shxBV09it7VSPRhFj+GkkVwicbS9Ri5S5vjpgX5
 eZ8LWTnzHSf5VB1hAkpwUHnhFzgKtxsGcNahyyPPP5DJHNRTu8
 xydHRzOgoAoLl2B/SN4Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2014 23:06:31 Sam Ravnborg wrote:
> > 
> > All these things are not introduced by your patch but now that
> > you show some love and care for this file maybe we could take
> > the next step and bring more order to the current semi chaos?
> 
> And I just noticed...
> 
> These are never used - and only defined a few places:
> #define inb_p(addr)     inb(addr)
> #define inw_p(addr)     inw(addr)
> #define inl_p(addr)     inl(addr)
> #define outb_p(x, addr) outb((x), (addr))
> #define outw_p(x, addr) outw((x), (addr))
> #define outl_p(x, addr) outl((x), (addr))
> 
> Likewise for these:
> #define insb_p(port,to,len)     insb(port,to,len)
> #define insw_p(port,to,len)     insw(port,to,len)
> #define insl_p(port,to,len)     insl(port,to,len)
> 
> #define outsb_p(port,from,len)  outsb(port,from,len)
> #define outsw_p(port,from,len)  outsw(port,from,len)
> #define outsl_p(port,from,len)  outsl(port,from,len)
> 
> 
> 
> This set:
> #define inb_p(addr)     inb(addr)
> #define inw_p(addr)     inw(addr)
> #define inl_p(addr)     inl(addr)
> #define outb_p(x, addr) outb((x), (addr))
> #define outw_p(x, addr) outw((x), (addr))
> #define outl_p(x, addr) outl((x), (addr))
> 
> Should have a comment that say they are deprecated.
> Especially the "b" variants still have many users.

Are they? I don't remember ever seeing a reason to deprecate
them. We could perhaps enclose them in #ifdef CONFIG_ISA, but
there may also be some drivers that use the same code for ISA
and PCI, and it doesn't really hurt on PCI.

	Arnd
