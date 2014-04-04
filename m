Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaDDU6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:58:07 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:50616
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbaDDU6D convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:58:03 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh936eI1432Izz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
Date: Fri, 4 Apr 2014 13:57:44 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Gerhard Sittig <gsi@denx.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>, <devicetree@vger.kernel.org>,
        Mike Looijmans <mike.looijmans@topic.nl>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/3] i2c: cadence: Document device tree bindings
References: <1396547967-19260-1-git-send-email-soren.brinkmann@xilinx.com>
 <20140404191757.GR11339@book.gsilab.sittig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140404191757.GR11339@book.gsilab.sittig.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <27b560ed-5b34-4b1a-b741-0e5bf6cbb992@VA3EHSMHS010.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 09:17PM +0200, Gerhard Sittig wrote:
> On Thu, 2014-04-03 at 10:59 -0700, Soren Brinkmann wrote:
> > 
> > Add device tree binding documentation for the Cadence I2C controller.
> > 
> > [ ... ]
> > 
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/i2c/i2c-cadence.txt
> > @@ -0,0 +1,21 @@
> > +Binding for the Cadence I2C controller
> > +
> > +Required properties:
> > +  compatible: Compatibility string. Must be 'cdns,i2c-r1p10'.
> > +  clocks: From common clock bindings. Phandle to input clock.
> 
> the usual complaint:  'clocks' items are not just phandles (your
> example even suggests this); either adjust the description to
> something correct, or just refer to the common clock bindings to
> not duplicate their description

I'll figure out something.

> 
> but I guess the I2C controller's binding should explicitly state
> which clocks are required, and you might want to consider
> 'clock-names', too

There is only one clock input. There is no need to overcomplicate things
by adding clock-names.

> 
> > +
> > +Optional properties:
> > +  clock-frequency: Desired operating frequency, in Hz, of the bus (actual may
> > +		   be lower). Defaults to 400000 if not specified.
> 
> is the value default a feature of the Linux implementation, or
> consciously designed to be in the binding spec?  and I agree that
> the default should be the standard I2C speed instead of fast mode

I remove the note regarding the default. It's implementation.

> 
> > +
> > +Example:
> > +
> > +	i2c@e0004000 {
> > +		compatible = "cdns,i2c-r1p10";
> > +		clocks = <&clkc 38>;
> > +		interrupts = <0 25 4>;
> > +		reg = <0xE0004000 0x1000>;
> > +		clock-frequency = <400000>;
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +	};
> 
> use lower case hex digits, consider symbolic identifiers for
> clocks and interrupt flags

I don't care about the case of those hex digits, but where does it say
that they have to be lower case? Will somebody complain about usage of
lower case chars next?

> 
> the example has many more properties than the binding describes,
> the additional items aren't even optional -- you might want to
> refer to a few more common or general bindings

Well, this is common across binding documentation. Can we please get
consistency in this? I see plenty of binding docs that are documented
this way, not mentioning much regarding such common properties.

	Sören


