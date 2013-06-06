Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3FFAje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 20:39:34 -0400
Received: from gloria.sntech.de ([95.129.55.99]:54271 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab3FFAjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 20:39:33 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 3/3] clk: dt: binding for basic divider clock
Date: Thu, 6 Jun 2013 02:09:43 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Mike Turquette <mturquette@linaro.org>, Matt Sealey <neko@bakuhatsu.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org> <CAHCPf3tZAbdVZPuKOjxJbCOAE76Pa6wMVHjnBRPhSpj0aMBMHg@mail.gmail.com> <20130604192243.10233.76496@quantum>
In-Reply-To: <20130604192243.10233.76496@quantum>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306060209.43486.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 4. Juni 2013, 21:22:43 schrieb Mike Turquette:
> Quoting Matt Sealey (2013-06-04 10:39:53)
> 
> > On Tue, Jun 4, 2013 at 12:11 PM, Stephen Boyd <sboyd@codeaurora.org> 
wrote:
> > > On 06/03/13 10:53, Mike Turquette wrote:
> > >> +Required properties:
> > >> +- compatible : shall be "divider-clock".
> > >> +- #clock-cells : from common clock binding; shall be set to 0.
> > >> +- clocks : link to phandle of parent clock
> > >> +- reg : base address for register controlling adjustable divider
> > >> +- mask : arbitrary bitmask for programming the adjustable divider
> > >> +
> > >> +Optional properties:
> > >> +- clock-output-names : From common clock binding.
> > >> +- table : array of integer pairs defining divisors & bitfield values
> > >> +- shift : number of bits to shift the mask, defaults to 0 if not
> > >> present +- index_one : valid divisor programming starts at 1, not
> > >> zero +- index_power_of_two : valid divisor programming must be a
> > >> power of two +- allow_zero : implies index_one, and programming zero
> > >> results in +  divide-by-one
> > > 
> > > It's preferred that property names have dashes instead of underscores.
> > 
> > I think I have a suggestion or two here..
> > 
> > I mailed one to Mike earlier, I have had some mailing list problems
> > which I think are solved now..
> > 
> > If you provide a mask for programming the divider, surely the "shift"
> > property is therefore redundant. Unless some device has a completely
> > strange way of doing things and uses two seperated bitfields for
> > programming in the same register, the shift value is simply a function
> > of ffs() on the mask, isn't it? It is nice to put the information
> > specifically in the device tree, but where a shift is not specified
> > it'd probably be a good idea to go about deriving that value that way
> > anyway, right, and if we're doing that.. why specify it?
> 
> Shift is optional.  Also I think the integer values in a DTS are
> 32-bits, so if some day someone had a clock driver that needed to write
> to a 64-bit register then shift might be useful there, combined with a
> 32-bit mask.  Or perhaps dtc will have a 64-bit value for that case?  I
> don't know.
> 
> I certainly do see your point about only using the mask, and the
> original clock basic types did this a while back before the shift+width
> style came into vogue.
> 
> If other reviewers also want to use a pure 32-bit mask and no shift then
> I'll drop it in the next round.

I would object to dropping the shift :-)

If you look at the two clk extensions in my rockchip patches you can see that 
they use a different regiment to set values.

Using the lower 16 bits to set the value and the upper 16 bit to mark which 
values are changed, i.e. (mask << shift + 16) | (val << shift).

(I'm not sure, if the naming or solution could be improved though)


Heiko
