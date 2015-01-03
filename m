Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbbACPf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 10:35:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41929 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbbACPf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 10:35:26 -0500
Date: Sat, 3 Jan 2015 09:34:46 -0600
From: Nishanth Menon <nm@ti.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Santosh <ssantosh@kernel.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH V2 2/2] ARM: l2c: AM437x: Introduce support for cache
 filter programming
Message-ID: <20150103153446.GA23591@kahuna>
References: <1420220628-23742-1-git-send-email-nm@ti.com>
 <1420220628-23742-3-git-send-email-nm@ti.com>
 <CA+Ln22Epd8VpA9DQPFYBdjewUY3ejODhaRHgBSNZAQCYjx5saw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+Ln22Epd8VpA9DQPFYBdjewUY3ejODhaRHgBSNZAQCYjx5saw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:40-20150103, Tomasz Figa wrote:
> Hi Nishanth,
> 
> 2015-01-03 2:43 GMT+09:00 Nishanth Menon <nm@ti.com>:
> > AM437x generation of processors support programming the PL310 L2Cache
> > controller's address filter start and end registers using a secure
> > montior service.
> 
> typo: s/montior/monitor/
> 
> [snip]

Uggh.. yes indeed. I will post a v3 updating the comments. If the
following is ok.
> 
> > +               base = omap4_get_l2cache_base();
> > +               filter_start = (reg == L310_ADDR_FILTER_START) ? val :
> > +                              readl_relaxed(base + L310_ADDR_FILTER_START);
> > +               filter_end = (reg == L310_ADDR_FILTER_END) ? val :
> > +                              readl_relaxed(base + L310_ADDR_FILTER_END);
> > +               omap_smc1_2(AM43X_MON_L2X0_SETFILTER_INDEX, filter_start,
> > +                           filter_end);
> > +               return;
> 
> I don't have any significant comments about this patch in particular,
> but just noticed that you need to do read-backs here (and the typo
> thanks to the spell checker of my mailing app). Maybe you should
> consider switching to the .configure() API I introduced in my series?
> This would let you get rid of the hardcoded static mapping.

Yeah, I have two choices there.. Either I provide the fundamental
write function for the generic l2c code to use OR I provide a
duplicate of resultant l2c_configure(aux write) + l2c310_configure.

To allow for reuse of improvements or anything like errata
implementations in the future, OMAP L2C implementation has chosen to provide the
low level code and allow the higherlevel configure/write/whatever of the
future to stay in arch/arm/mm/cache-l2x0.c. The write_sec operation is
not too complicated enough to warrant a replication of l2c310_configure.

So, I prefer the current implementation than providing a .configure
handler for outer_cache.configure from SoC level.

Let me know if anyone has a strong objection to this.

-- 
Regards,
Nishanth Menon
