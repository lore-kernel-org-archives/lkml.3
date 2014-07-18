Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946117AbaGRVGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:06:37 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:39674 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946095AbaGRVGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:06:35 -0400
Date: Fri, 18 Jul 2014 23:06:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] asm-generic/io.h: Implement generic
 {read,write}s*()
Message-ID: <20140718210631.GA22109@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
 <20140718205953.GA21964@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718205953.GA21964@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> All these things are not introduced by your patch but now that
> you show some love and care for this file maybe we could take
> the next step and bring more order to the current semi chaos?

And I just noticed...

These are never used - and only defined a few places:
#define inb_p(addr)     inb(addr)
#define inw_p(addr)     inw(addr)
#define inl_p(addr)     inl(addr)
#define outb_p(x, addr) outb((x), (addr))
#define outw_p(x, addr) outw((x), (addr))
#define outl_p(x, addr) outl((x), (addr))

Likewise for these:
#define insb_p(port,to,len)     insb(port,to,len)
#define insw_p(port,to,len)     insw(port,to,len)
#define insl_p(port,to,len)     insl(port,to,len)

#define outsb_p(port,from,len)  outsb(port,from,len)
#define outsw_p(port,from,len)  outsw(port,from,len)
#define outsl_p(port,from,len)  outsl(port,from,len)



This set:
#define inb_p(addr)     inb(addr)
#define inw_p(addr)     inw(addr)
#define inl_p(addr)     inl(addr)
#define outb_p(x, addr) outb((x), (addr))
#define outw_p(x, addr) outw((x), (addr))
#define outl_p(x, addr) outl((x), (addr))

Should have a comment that say they are deprecated.
Especially the "b" variants still have many users.

	Sam
