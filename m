Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3GDWiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 18:38:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58651 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3GDWiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 18:38:12 -0400
Message-ID: <1372977465.21065.136.camel@cumari.coelho.fi>
Subject: Re: [RFC] clk: add flags to distinguish xtal clocks
From: Luciano Coelho <coelho@ti.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Date: Fri, 5 Jul 2013 01:37:45 +0300
In-Reply-To: <20130704222538.10823.2559@quantum>
References: <1372971912-10877-1-git-send-email-coelho@ti.com>
	 <20130704222538.10823.2559@quantum>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-04 at 15:25 -0700, Mike Turquette wrote:
> Quoting Luciano Coelho (2013-07-04 14:05:12)
> > Add a flag that indicate whether the clock is a crystal or not.  Since
> > no clocks set this flag right now, include an additional flag that
> > indicates whether the type is set or not.  If the CLK_IS_TYPE_DEFINED
> > flag is not set, the value of the CLK_IS_TYPE_XTAL flag is undefined.
> > This ensures backwards compatibility.
> > 
> > Additionally, parse a new device tree binding in clk-fixed-rate to set
> > this flag.
> > 
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> > 
> > I'm not  familiar with the common clock framework and I'm not
> > entirely sure the flags can be used in such a way, but to me it looks
> > reasonable, since some clock consumers may need to know what type of
> > clock is being provided.
> > 
> > Specifically, the wl12xx firmware needs to know if the clock is XTAL
> > or not to handle the stabilization and boosts properly.
> 
> Hi Luciano,

Hi Mike,

> I'd like clarification on one point. Is the same clock input signal used
> on the wifi chip? What I mean is, are there multiple clock inputs and
> XTAL is one, and not-XTAL is another?

This wifi chip can work with a few different clocks and some of them are
XTAL and others are not.  What the chip's firmware can use is one of
these:

19.2MHz (not XTAL)
26.0MHz (not XTAL)
26.0MHz (XTAL)
38.4MHz (not XTAL)
38.4MHz (XTAL)
52.0MHz (not XTAL)

It treats the XTAL clocks differently (but I don't really understand
enough of the details), so the driver needs to configure the firmware
according to these values.


> Or is it the same clock input and basically the problem is that you need
> to know what kind of waveform to expect (e.g. square versus sine)?

It's the same clock input in the chip's perspective.  One clock input
that can be any of the combinations I mentioned above.  Again, I'm not
familiar with clocks, so I guess the square vs. sine explanation is
plausible.  What I could see in the firmware is that it handles the
clocks differently if they're xtal or not.

--
Luca.

