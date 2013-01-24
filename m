Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3AXRGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:06:36 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40242 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3AXRGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:06:35 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: "Mohammed, Afzal" <afzal@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA92ABC@DBDE01.ent.ti.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
References: <6dc1c48cac5b2646a55da3079afb72f88e40c3bc.1358937138.git.afzal@ti.com>
 <20130123214053.9205.49804@quantum>
 <C8443D0743D26F4388EA172BF4E2A7A93EA92ABC@DBDE01.ent.ti.com>
Message-ID: <20130124170630.10623.78749@quantum>
User-Agent: alot/0.3.3+
Subject: Re: RE: [PATCH v2 1/2] clk: divider: prepare for minimum divider
Date: Thu, 24 Jan 2013 09:06:30 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mohammed, Afzal (2013-01-24 03:29:15)
> Hi Mike,
> 
> On Thu, Jan 24, 2013 at 03:10:53, Mike Turquette wrote:
> > Quoting Afzal Mohammed (2013-01-23 03:38:52)
> 
> > > Some of clocks can have a limit on minimum divider value that can be
> > > programmed, prepare for such a support.
> 
> > > Add a new field min_div for the basic divider clock and a new dynamic
> > > clock divider registration function where minimum divider value can
> > > be specified. Keep behaviour of existing divider clock registration
> > > functions, static initialization helpers as was earlier.
> 
> > My first question is whether the minimum divider you plan to use is an
> > actual constraint of the hardware (e.g. the clock controller ip only
> > lets program two bits which divide by 4, 5, 6 or 7, where 4 is the
> > minimum divider) or if this is a functional constraint (e.g. the clock
> > hardware can divide by a lower value, but you never want that since it
> > results in non-functional video/audio/whatever).  If this is more of a
> > functional constraint then perhaps a new api like clk_set_min_rate makes
> > more sense.
> 
> It is a functional constraint: divider has 8 bits and it can have
> all possible values (0 to 255) and divider value corresponds to
> value set in the 8 bits. But depending on the modes the minimum
> value that can be configured (to get display working) varies.
> Eg. For raster mode (which the driver is presently supporting), it
> can take a minimum value of 2, while in LIDD (LCD interface display
> driver) mode it can take a min value of 1.
> 
> Here min rate is not a constraint w.r.t divider in LCDC IP, but
> rather min divider.
> 

Just so I understand correctly... you are saying that the functional
constraint is not caused by the clock rate, but instead by the divider
value?  For the different modes (raster vs LIDD) is the clock rate the
same, or is the clock rate different?

What is the clock output rate of the divider in raster mode?  What is
the clock output rate of the divider in LIDD mode?

Thanks,
Mike

> As it is the case, you prefer a clk_divider_set_min_div()?
> 
> > 
> > Secondly, have you looked into using the rate-table option provided by
> > the basic divider clock?  Can you explain how this is not a good fit for
> > your needs?  Perhaps there are too many divisor values so the table
> > would be large?
> 
> Divider values can range from 2-255 (254 possible values), so I believe
> it is not a suitable candidate here (also divider to values have 1-to-1
> mapping)
> 
> Regards
> Afzal
