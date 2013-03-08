Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424Ab3CHQfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:35:23 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:12702 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933220Ab3CHQfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:35:22 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19MaAshA/fdiomHfC3QIoyy
Date: Fri, 8 Mar 2013 08:35:07 -0800
From: Tony Lindgren <tony@atomide.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: drop "select MACH_NOKIA_RM696"
Message-ID: <20130308163507.GC26093@atomide.com>
References: <1362738596.5994.48.camel@x61.thuisdomein>
 <20130308161159.GE14552@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308161159.GE14552@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Aaro Koskinen <aaro.koskinen@iki.fi> [130308 08:16]:
> On Fri, Mar 08, 2013 at 11:29:56AM +0100, Paul Bolle wrote:
> > When support was added for Nokia N9 (RM-696), with commit
> > 63fc5f3bb3d0ca9ab4767a801b518aa6335f87ad ("ARM: OMAP: add minimal
> > support for Nokia RM-696"), a select statement for MACH_NOKIA_RM696 was
> > added to the tree. But there's no Kconfig symbol with that name. That
> > symbol would be superfluous, since support for that machine piggybacks
> > on MACH_NOKIA_RM680. So drop that select.
> 
> This is needed because of arch/arm/tools/mach-types. See
> include/generated/mach-types.h.
> 
> If you have just CONFIG_MACH_NOKIA_RM680 and run the kernel on RM-696,
> then machine_is_nokia_rm696() will return false. If I rememeber correctly,
> this broke at least early printk / uncompressor output at the time.
> 
> I guess people may still want to use machine_is_... macros e.g. for
> debugging.

I think the righ fix is to just add

config MACH_NOKIA_RM680
	bool

to the mach-omap2/Kconfig like we have for n8x0 also.

Regards,

Tony
