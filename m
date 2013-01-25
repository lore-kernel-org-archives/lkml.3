Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3AYWUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:20:40 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:35071 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3AYWUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:20:38 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: "Mohammed, Afzal" <afzal@ti.com>, Paul Walmsley <paul@pwsan.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA9388C@DBDE01.ent.ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
References: <cover.1358937533.git.afzal@ti.com>
 <871e6890897534b6c3669e252f23bef5ff1247b6.1358937533.git.afzal@ti.com>
 <alpine.DEB.2.00.1301250816010.471@utopia.booyaka.com>
 <C8443D0743D26F4388EA172BF4E2A7A93EA9388C@DBDE01.ent.ti.com>
Message-ID: <20130125222032.10623.47200@quantum>
User-Agent: alot/0.3.3+
Subject: Re: RE: [PATCH v2 1/4] ARM: OMAP2+: dpll: round rate to closest value
Date: Fri, 25 Jan 2013 14:20:32 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mohammed, Afzal (2013-01-25 04:18:22)
> Hi Paul,
> 
> On Fri, Jan 25, 2013 at 13:48:11, Paul Walmsley wrote:
> > On Wed, 23 Jan 2013, Afzal Mohammed wrote:
> 
> > > Currently round rate function would return proper rate iff requested
> > > rate exactly matches the PLL lockable rate. This causes set_rate to
> > > fail if exact rate could not be set. Instead round rate may return
> > > closest rate possible (less than the requested). And if any user is
> > > badly in need of exact rate, then return value of round rate could
> > > be used to decide whether to invoke set rate or not.
> > > 
> > > Modify round rate so that it return closest possible rate.
> > 
> > This doesn't look like the right approach to me.  For some PLLs, an exact 
> > rate is desired.
> 
> If exact rate is required, there is a way to achieve it as mentioned
> in the commit message, i.e. by first invoking round rate over reqd. rate
> and if it doesn't match, bail out w/o invoking set_rate.
> 
> And it seems requirement of CCF w.r.t to round rate is to return closest
> possible rate.

Is MULT_ROUND_UP doing the right thing for you in the clk_divider code?
What is the clock rate requested of the parent PLL?  I just want to make
sure that we're doing the right thing in the basic divider code.

Thanks,
Mike
