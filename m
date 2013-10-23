Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3JWLgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:36:53 -0400
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:38017 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab3JWLgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:36:52 -0400
Message-ID: <1382528150.21526.25.camel@porter.coelho.fi>
Subject: Re: [RFC] clk: add flags to distinguish xtal clocks
From: Luca Coelho <luca@coelho.fi>
To: Mike Turquette <mturquette@linaro.org>
Cc: balbi@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Date: Wed, 23 Oct 2013 14:35:50 +0300
In-Reply-To: <20131023092427.11662.41825@quantum>
References: <1372971912-10877-1-git-send-email-coelho@ti.com>
	 <20130704222538.10823.2559@quantum>
	 <1372977465.21065.136.camel@cumari.coelho.fi>
	 <20130704231953.10823.94331@quantum>
	 <1373010853.21065.159.camel@cumari.coelho.fi>
	 <1375105842.20048.18.camel@cumari.coelho.fi>
	 <20131007074424.7445.52119@quantum> <20131008152743.GB13128@radagast>
	 <1381919067.11885.19.camel@porter.coelho.fi>
	 <20131023092427.11662.41825@quantum>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-23 at 02:24 -0700, Mike Turquette wrote:
> Quoting Luca Coelho (2013-10-16 03:24:27)
> > Hi,
> > 
> > Sorry for the delayed response.
> > 
> > On Tue, 2013-10-08 at 10:27 -0500, Felipe Balbi wrote:
> > > Fixing Luca's address since he left TI
> > 
> > Thanks, Felipe! I wouldn't have seen this otherwise.
> > 
> > 
> > > On Mon, Oct 07, 2013 at 12:44:24AM -0700, Mike Turquette wrote:
> > > > Quoting Luciano Coelho (2013-07-29 06:50:42)
> > > > > Hi Mike,
> > > > > 
> > > > > On Fri, 2013-07-05 at 10:54 +0300, Luciano Coelho wrote:
> > > > > > On Thu, 2013-07-04 at 16:19 -0700, Mike Turquette wrote:
> > > > > > > Quoting Luciano Coelho (2013-07-04 15:37:45)
> > > > > > > > On Thu, 2013-07-04 at 15:25 -0700, Mike Turquette wrote:
> > > > > > > > > Or is it the same clock input and basically the problem is that you need
> > > > > > > > > to know what kind of waveform to expect (e.g. square versus sine)?
> > > > > > > > 
> > > > > > > > It's the same clock input in the chip's perspective.  One clock input
> > > > > > > > that can be any of the combinations I mentioned above.  Again, I'm not
> > > > > > > > familiar with clocks, so I guess the square vs. sine explanation is
> > > > > > > > plausible.  What I could see in the firmware is that it handles the
> > > > > > > > clocks differently if they're xtal or not.
> > > > > > > 
> > > > > > > OMAP has a similar thing where sys_clkin (the fast reference clock for
> > > > > > > the chip) can be 19.2, 26, 38.4, etc. This is easy to handle since only
> > > > > > > the rates matter.
> > > > > > 
> > > > > > Right, this part is easy and I already have the code for that.  What I'm
> > > > > > missing is a way to pass this XTAL flag to the chip.
> > > > > > 
> > > > > > 
> > > > > > > In your case you need some extra metadata to know what to do. I'm really
> > > > > > > not sure if CLK_IS_TYPE_XTAL is the most useful form this metadata can
> > > > > > > take. It would be best to know if the waveform is what you really need
> > > > > > > to know, or perhaps something else. For instance you might be affected
> > > > > > > by some clock signal stabilization time. Can you talk to your hardware
> > > > > > > guys and figure it out? I'd rather model the actual needs instead of
> > > > > > > just tossing a flag in there.
> > > > > > 
> > > > > > I get your point.  I have tried to investigate how this flag is used by
> > > > > > the firmware and I could see that it is used to set different "buffer
> > > > > > gains" and "delays" when waking up (I guess this means when the clock is
> > > > > > starting, so probably related to stabilization time).  They specify two
> > > > > > "modes", "boost" and "normal" and use different delay values for each.
> > > > > 
> > > > > I tried but I couldn't find any more information on how exactly this
> > > > > works.  But since this change is really simple and there seems to be
> > > > > other people who need the same information, couldn't we add it as is and
> > > > > try to figure out more specific information about the clocks later on?
> > > > > 
> > > > > Even if XTAL is not that useful if we know the other details, at least
> > > > > it wouldn't hurt to have the flag there anyway.
> > > > 
> > > > Luca,
> > > > 
> > > > By any chance did you come to a different solution for this problem? I
> > > > can take the patch, but I do not feel like we're solving the right
> > > > problem the right way.
> > 
> > Unfortunately I didn't find any better solution for this.  From the
> > WiLink firmware's point of view, there was not much information about
> > the details of stabilization time requirements and such.
> > 
> >  
> > > > If not I will take it for 3.13.
> > 
> > That would be great! As I mentioned above, the XTAL/non-XTAL flag
> > wouldn't hurt, even if in most cases it may not provide the necessary
> > details for the clock code.  But at least for the WiLink hardware it is
> > very useful. ;)
> 
> Why is the CLK_IS_TYPE_DEFINED necessary?

This is just for backwards compatibility.  Currently all the other
clocks don't set the XTAL/non-XTAL flag (even if they *are* XTAL), so if
the CLK_IS_TYPE_DEFINED is not set, we know we can't trust the
XTAL/no-XTAL flag.


> Also we're adding a property to the fixed-rate binding so
> Documentation/devicetree/bindings/clock/fixed-clock.txt needs to be
> updated.

Yeah, you're right.  Unfortunately, I won't have the time to resubmit
this patch any time soon. :(

--
Luca.

