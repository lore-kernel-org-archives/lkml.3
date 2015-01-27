Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbbA0PaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:30:15 -0500
Received: from smtp2.ore.mailhop.org ([54.186.57.195]:52858 "EHLO
	smtp2.ore.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbbA0PaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:30:12 -0500
X-Mail-Handler: DuoCircle Outbound SMTP
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@duocircle.com (see https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information for abuse reporting information)
X-MHO-User: U2FsdGVkX1+FX26Btkcmv3WEOsoNRuAo
Date: Tue, 27 Jan 2015 07:26:53 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: N900 v3.19-rc5 arm atags_to_fdt.c is broken
Message-ID: <20150127152653.GI28663@atomide.com>
References: <201501232239.55801@pali>
 <201501232336.36187@pali>
 <20150126161454.GE28663@atomide.com>
 <201501261723.10505@pali>
 <20150126170323.GF28663@atomide.com>
 <alpine.LFD.2.11.1501261318590.1322@knanqh.ubzr>
 <20150127133739.GB25306@amd>
 <alpine.LFD.2.11.1501271014160.1322@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501271014160.1322@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre <nicolas.pitre@linaro.org> [150127 07:19]:
> On Tue, 27 Jan 2015, Pavel Machek wrote:
> 
> > 
> > > > > I would say, problem is because omap3-n900 binary DT is too large
> > > 
> > > I agree.
> > > 
> > > > OK if that's the case, then your patch makes sense to me. It also
> > > > seems we can have the temporary stack be larger than the initial
> > > > stack just for atags_to_fdt.
> > > 
> > > The stack size isn't the issue, but rather its location.  We need to 
> > > position it away from the DT data.  The DT size is known and we could 
> > > use that, plus some room for the insertion of new data coming from the
> > > ATAG conversion.
> > > 
> > > Something like the following would be a more robust solution:
> > 
> > Tested-by: Pavel Machek <pavel@ucw.cz>
> > 
> > (Note, that in 3.19 dts for n900 got too big, so we are actually
> > triggering old bugs. That means that this is a regression fix, and
> > should go in ASAP).
> 
> It is queued here:
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8294/1

Thanks for fixing that one!

Regards,

Tony
