Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab3GEHyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 03:54:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39517 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089Ab3GEHyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 03:54:52 -0400
Message-ID: <1373010853.21065.159.camel@cumari.coelho.fi>
Subject: Re: [RFC] clk: add flags to distinguish xtal clocks
From: Luciano Coelho <coelho@ti.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Date: Fri, 5 Jul 2013 10:54:13 +0300
In-Reply-To: <20130704231953.10823.94331@quantum>
References: <1372971912-10877-1-git-send-email-coelho@ti.com>
	 <20130704222538.10823.2559@quantum>
	 <1372977465.21065.136.camel@cumari.coelho.fi>
	 <20130704231953.10823.94331@quantum>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-04 at 16:19 -0700, Mike Turquette wrote:
> Quoting Luciano Coelho (2013-07-04 15:37:45)
> > On Thu, 2013-07-04 at 15:25 -0700, Mike Turquette wrote:
> > > Or is it the same clock input and basically the problem is that you need
> > > to know what kind of waveform to expect (e.g. square versus sine)?
> > 
> > It's the same clock input in the chip's perspective.  One clock input
> > that can be any of the combinations I mentioned above.  Again, I'm not
> > familiar with clocks, so I guess the square vs. sine explanation is
> > plausible.  What I could see in the firmware is that it handles the
> > clocks differently if they're xtal or not.
> 
> OMAP has a similar thing where sys_clkin (the fast reference clock for
> the chip) can be 19.2, 26, 38.4, etc. This is easy to handle since only
> the rates matter.

Right, this part is easy and I already have the code for that.  What I'm
missing is a way to pass this XTAL flag to the chip.


> In your case you need some extra metadata to know what to do. I'm really
> not sure if CLK_IS_TYPE_XTAL is the most useful form this metadata can
> take. It would be best to know if the waveform is what you really need
> to know, or perhaps something else. For instance you might be affected
> by some clock signal stabilization time. Can you talk to your hardware
> guys and figure it out? I'd rather model the actual needs instead of
> just tossing a flag in there.

I get your point.  I have tried to investigate how this flag is used by
the firmware and I could see that it is used to set different "buffer
gains" and "delays" when waking up (I guess this means when the clock is
starting, so probably related to stabilization time).  They specify two
"modes", "boost" and "normal" and use different delay values for each.

As I said, I don't know almost anything about clocks, so all this
doesn't make much sense to me.  But maybe you can get an idea?

--
Cheers,
Luca.

