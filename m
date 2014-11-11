Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaKKSSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:18:30 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58242 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaKKSS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:18:27 -0500
Date: Tue, 11 Nov 2014 19:18:25 +0100
From: Johan Hovold <johan@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Johan Hovold <johan@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 19/22] dt/bindings: add micrel,rmii_ref_clk_sel_25_mhz to
 eth-phy binding
Message-ID: <20141111181825.GH29789@localhost>
References: <1415727460-20417-1-git-send-email-johan@kernel.org>
 <1415727460-20417-20-git-send-email-johan@kernel.org>
 <20141111175741.GF25295@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111175741.GF25295@leverpostej>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 05:57:42PM +0000, Mark Rutland wrote:
> On Tue, Nov 11, 2014 at 05:37:37PM +0000, Johan Hovold wrote:
> > Add "micrel,rmii_ref_clk_sel_25_mhz" to Micrel ethernet PHY binding
> > documentation.
> > 
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  Documentation/devicetree/bindings/net/micrel.txt | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/micrel.txt b/Documentation/devicetree/bindings/net/micrel.txt
> > index a1bab5eaae02..9b08dd6551dd 100644
> > --- a/Documentation/devicetree/bindings/net/micrel.txt
> > +++ b/Documentation/devicetree/bindings/net/micrel.txt
> > @@ -19,6 +19,11 @@ Optional properties:
> >  
> >                See the respective PHY datasheet for the mode values.
> >  
> > + - micrel,rmii_ref_clk_sel_25_mhz: rmii_ref_clk_sel bit selects 25 MHz mode
> > +
> > +		Whether 25 MHz (rather than 50 Mhz) clock mode is selected
> > +		when the rmii_ref_clk_sel bit is set.
> 
> s/_/-/ in property names please.

Ouch, copied from variable name, sorry.

> That said, I don't follow the meaning. Does this cause the kernel to do
> something different, or is is simply that a 25MHz ref clock is wired up?

Yes, the driver currently sets this configuration bit based on a common
clock binding.

However, it turns out the meaning of the bit is reversed on some PHY
variants. On most PHYs 50 MHz mode is selected by setting this bit,
whereas on the PHYs that need this new property, setting it selects 25
MHz mode instead.

> Surely that should be described via the common clock bindings? Or if
> internal through a clock-frequency property?

The driver currently selects the mode using the common clock bindings,
but this new property is needed to properly handle those PHY variants on
which the clock configuration bit has the reverse meaning.

Thanks,
Johan
