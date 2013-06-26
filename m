Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3FZIXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:23:06 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:46854 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751285Ab3FZIXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:23:02 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/a5m7w9Jzkq/uiDOgB/xdv
Date: Wed, 26 Jun 2013 01:22:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Luciano Coelho <coelho@ti.com>
Cc: grant.likely@linaro.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
Message-ID: <20130626082257.GT5523@atomide.com>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
 <1372189024.18889.19.camel@cumari.coelho.fi>
 <20130626062409.GK5523@atomide.com>
 <1372234384.18889.37.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372234384.18889.37.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luciano Coelho <coelho@ti.com> [130626 01:19]:
> Hi Tony,
> 
> On Tue, 2013-06-25 at 23:24 -0700, Tony Lindgren wrote:
> > * Luciano Coelho <coelho@ti.com> [130625 12:43]:
> > > On Tue, 2013-06-25 at 11:35 +0300, Luciano Coelho wrote:
> > > > Add device tree bindings documentation for the TI WiLink modules.
> > > > Currently only the WLAN part of the WiLink6, WiLink7 and WiLink8
> > > > modules is supported.
> > > > 
> > > > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > > > ---
> 
> [...]
> 
> > > > +Optional properties:
> > > > +--------------------
> > > > +
> > > > +- refclock: the internal WLAN reference clock frequency (required for
> > > > +  WiLink6 and WiLink7; not used for WiLink8).  Must be one of the
> > > > +  following:
> > > > +	0 = 19.2 MHz
> > > > +	1 = 26.0 MHz
> > > > +	2 = 38.4 MHz
> > > > +	3 = 52.0 MHz
> > > > +	4 = 38.4 MHz, XTAL
> > > > +	5 = 26.0 MHz, XTAL
> > 
> > This is just the omap refclock, right? If so, you can just pass the
> > standard clock phandle. I know we don't yet have the DT clocks merged,
> > but Tero just posted another revision of those.
> 
> This is an internal clock.  This clock is part of the module that
> contains the WiLink chip.  It is not associated with the clocks in the
> main board (OMAP).
> 
> 
> > > > +- tcxoclock: the internal WLAN TCXO clock frequency (required for
> > > > +  WiLink7 not used for WiLink6 and WiLink8).  Must be one of the
> > > > +  following:
> > > > +	0 = 19.200 MHz
> > > > +	1 = 26.000 MHz
> > > > +	2 = 38.400 MHz
> > > > +	3 = 52.000 MHz
> > > > +	4 = 16.368 MHz
> > > > +	5 = 32.736 MHz
> > > > +	6 = 16.800 MHz
> > > > +	7 = 33.600 MHz
> > 
> > Where does this clock come from? Maybe this can be set based on the
> > compatible value if it's completely internal?
> 
> This is also a completely internal clock.  My "compatible" values are
> based on the WiLink chip itself, not in the module that contains the
> chip.  There are several modules and they are the ones that specify the
> clock frequencies.  This data I'm passing here is just to tell the
> WiLink chip which frequencies the module uses.
> 
> My driver is for the WiLink chip itself, not to the module (in theory).
> So I think having the WiLink values as bindings would be more generic
> than having to specify values for each available module (eg.
> "lsr-research,tiwi-ble") and mapping those values to specific
> frequencies in the driver.
> 
>  
> > > If this is okay for everyone, can I push this via my tree (which goes to
> > > linux-wireless->net->linus)? I think it makes more sense to send the
> > > documentation together with the patch that actually implements the DT
> > > node parsing in the driver.
> > 
> > If we can use the standard bindings, it might be worth waiting until
> > we have the DT clocks available as we have the pdata workaround merged
> > anyways. That's because then we don't need to support the custom
> > binding later on ;)
> 
> I looked into Tero's patches and I considered using the generic clock
> bindings, but I think it doesn't make sense in this case.  The thing is
> that the module is not providing the clocks to the main board.  Neither
> is the WiLink chip consuming clocks from the main board.
> 
> I thought about specifying clock providers and consumers to be used only
> by the module and WiLink chip, but I think it's overkill.  And we would
> also have to find a way to prevent the main clock framework from trying
> to handle them.
> 
> So, my conclusion was that, even though these *are* clocks, from the
> main board's perspective they're just specifications of what the module
> looks like.
> 
> Does this make sense?

OK yes, in that case looks fine to me:

Acked-by: Tony Lindgren <tony@atomide.com>
