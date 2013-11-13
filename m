Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab3KMOib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:38:31 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53910 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab3KMOi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:38:29 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-doc@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] clk: add specified-rate clock
Date: Wed, 13 Nov 2013 15:38:26 +0100
Message-ID: <1874762.a1UESS7e53@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <52838D3D.6060007@imgtec.com>
References: <1368189862-17119-1-git-send-email-james.hogan@imgtec.com> <5867382.IN2EZ2ivg4@flatron> <52838D3D.6060007@imgtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 of November 2013 14:31:25 James Hogan wrote:
> On 13/11/13 14:18, Tomasz Figa wrote:
> > Hi James, Mike,
> > 
> > On Wednesday 13 of November 2013 14:09:56 James Hogan wrote:
> >> On 29/05/13 18:39, Mike Turquette wrote:
> >>> Quoting James Hogan (2013-05-10 05:44:22)
> >>>> The frequency of some SoC's external oscillators (for example TZ1090's
> >>>> XTAL1) are configured by the board using pull-ups/pull-downs of
> >>>> configuration pins, the logic values of which are automatically latched
> >>>> on reset and available in an SoC register. Add a generic clock component
> >>>> and DT bindings to handle this.
> >>>>
> >>>> It behaves similar to a fixed rate clock (read-only), except it needs
> >>>> information about a register field (reg, shift, width), and the
> >>>> clock-frequency is a mapping from register field values to clock
> >>>> frequencies.
> >>>>
> >>>
> >>> James,
> >>>
> >>> Thanks for sending this!  It looks mostly good and is a useful clock
> >>> type to support.  Comments below.
> >>
> >> Hi Mike,
> >>
> >> Sorry for slight delay getting back to you. I had another think about
> >> this stuff yesterday...
> >>
> > 
> > Just a random idea that came to my mind while reading this thread:
> > 
> > What about modelling this as a set of fixed rate clocks fed into
> > a read-only mux?
> 
> Yes, that had occurred to me too. I suppose the arguments against would be:
> * it doesn't describe the hardware, there is no mux, just a fixed rate
> clock with a discoverable frequency.

For me, a set of configuration pins that select clock frequency sounds
like a mux. I'd rather say that there are no physical clocks that would
be its inputs, but that's probably just an implementation detail.

> * it would sort of work for my small case of only having 9 possible
> frequencies (although it would be a bit verbose), but wouldn't scale
> nicely or be extendible to if the frequency was encoded more
> continuously in the register value. E.g. if the frequency was 1MHz *
> (the register value - 1) or something crazy like that.

I guess you would need an implementation specific code to calculate the
frequency in such cases, which is not what you suggested above (but
rather "a mapping from register field values to clock frequencies"
inside a property).

Best regards,
Tomasz

