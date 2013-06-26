Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab3FZGYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:24:16 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18294 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751309Ab3FZGYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:24:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Vo6KTbQD9/fQOeXt6C7nE
Date: Tue, 25 Jun 2013 23:24:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Luciano Coelho <coelho@ti.com>
Cc: grant.likely@linaro.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
Message-ID: <20130626062409.GK5523@atomide.com>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
 <1372189024.18889.19.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372189024.18889.19.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luciano Coelho <coelho@ti.com> [130625 12:43]:
> (oh crap, now *really* fixed the ARM mailing list address)
> 
> On Tue, 2013-06-25 at 11:35 +0300, Luciano Coelho wrote:
> > Add device tree bindings documentation for the TI WiLink modules.
> > Currently only the WLAN part of the WiLink6, WiLink7 and WiLink8
> > modules is supported.
> > 
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> > 
> > I created a new directory under net to contain wireless bindings documentation.
> > 
> > The actual implementation in the driver will follow separately.
> > 
> >  .../devicetree/bindings/net/wireless/ti-wilink.txt |   46 ++++++++++++++++++++
> >  1 file changed, 46 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
> > new file mode 100644
> > index 0000000..d8e8bfbb
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
> > @@ -0,0 +1,46 @@
> > +TI WiLink Wireless Modules Device Tree Bindings
> > +===============================================
> > +
> > +The WiLink modules provide wireless connectivity, such as WLAN,
> > +Bluetooth, FM and NFC.
> > +
> > +There are several different modules available, which can be grouped by
> > +their generation: WiLink6, WiLink7 and WiLink8.  WiLink4 is not
> > +currently supported with device tree.
> > +
> > +Currently, only the WLAN portion of the modules is supported with
> > +device tree.
> > +
> > +Required properties:
> > +--------------------
> > +
> > +- compatible: should be "ti,wilink6", "ti,wilink7" or "ti,wilink8"
> > +- interrupt-parent: the interrupt controller
> > +- interrupts: out-of-band WLAN interrupt
> > +	See the interrupt controller's bindings documentation for
> > +	detailed definition.
> > +
> > +Optional properties:
> > +--------------------
> > +
> > +- refclock: the internal WLAN reference clock frequency (required for
> > +  WiLink6 and WiLink7; not used for WiLink8).  Must be one of the
> > +  following:
> > +	0 = 19.2 MHz
> > +	1 = 26.0 MHz
> > +	2 = 38.4 MHz
> > +	3 = 52.0 MHz
> > +	4 = 38.4 MHz, XTAL
> > +	5 = 26.0 MHz, XTAL

This is just the omap refclock, right? If so, you can just pass the
standard clock phandle. I know we don't yet have the DT clocks merged,
but Tero just posted another revision of those.

> > +- tcxoclock: the internal WLAN TCXO clock frequency (required for
> > +  WiLink7 not used for WiLink6 and WiLink8).  Must be one of the
> > +  following:
> > +	0 = 19.200 MHz
> > +	1 = 26.000 MHz
> > +	2 = 38.400 MHz
> > +	3 = 52.000 MHz
> > +	4 = 16.368 MHz
> > +	5 = 32.736 MHz
> > +	6 = 16.800 MHz
> > +	7 = 33.600 MHz

Where does this clock come from? Maybe this can be set based on the
compatible value if it's completely internal?
 
> If this is okay for everyone, can I push this via my tree (which goes to
> linux-wireless->net->linus)? I think it makes more sense to send the
> documentation together with the patch that actually implements the DT
> node parsing in the driver.

If we can use the standard bindings, it might be worth waiting until
we have the DT clocks available as we have the pdata workaround merged
anyways. That's because then we don't need to support the custom
binding later on ;)

Regards,

Tony
