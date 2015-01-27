Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbbA0PQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:16:32 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:64744 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbbA0PQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:16:28 -0500
Date: Tue, 27 Jan 2015 10:16:24 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: N900 v3.19-rc5 arm atags_to_fdt.c is broken
In-Reply-To: <20150127133739.GB25306@amd>
Message-ID: <alpine.LFD.2.11.1501271014160.1322@knanqh.ubzr>
References: <201501232239.55801@pali> <201501232336.36187@pali> <20150126161454.GE28663@atomide.com> <201501261723.10505@pali> <20150126170323.GF28663@atomide.com> <alpine.LFD.2.11.1501261318590.1322@knanqh.ubzr> <20150127133739.GB25306@amd>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Pavel Machek wrote:

> 
> > > > I would say, problem is because omap3-n900 binary DT is too large
> > 
> > I agree.
> > 
> > > OK if that's the case, then your patch makes sense to me. It also
> > > seems we can have the temporary stack be larger than the initial
> > > stack just for atags_to_fdt.
> > 
> > The stack size isn't the issue, but rather its location.  We need to 
> > position it away from the DT data.  The DT size is known and we could 
> > use that, plus some room for the insertion of new data coming from the
> > ATAG conversion.
> > 
> > Something like the following would be a more robust solution:
> 
> Tested-by: Pavel Machek <pavel@ucw.cz>
> 
> (Note, that in 3.19 dts for n900 got too big, so we are actually
> triggering old bugs. That means that this is a regression fix, and
> should go in ASAP).

It is queued here:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8294/1


Nicolas
