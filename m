Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaK1AW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 19:22:28 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:49310 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaK1AW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 19:22:27 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 1/3] devicetree: of: Add bindings for chosen
 =?iso-8859-1?Q?node=2C=0D?= stdout-path
To: Mark Rutland <mark.rutland@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "ijc@debian.org" <ijc@debian.org>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
In-Reply-To: <20141127184133.GM857@leverpostej>
References: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org>
	<1417110967-16284-2-git-send-email-leif.lindholm@linaro.org>
	<20141127184133.GM857@leverpostej>
Date: Fri, 28 Nov 2014 00:22:20 +0000
Message-Id: <20141128002220.A5122C40A7F@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 18:41:33 +0000
, Mark Rutland <mark.rutland@arm.com>
 wrote:
> On Thu, Nov 27, 2014 at 05:56:05PM +0000, Leif Lindholm wrote:
> > Add a global binding for the chosen node.
> > Include a description of the stdout-path, and an explicit statement on
> > its extra options in the context of a UART console.
> > 
> > Opening description stolen from www.devicetree.org, and part of the
> > remaining text provided by Mark Rutland.
> > 
> > Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/chosen.txt |   42 ++++++++++++++++++++++++++
> >  1 file changed, 42 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/chosen.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/chosen.txt b/Documentation/devicetree/bindings/chosen.txt
> > new file mode 100644
> > index 0000000..9cd74e9
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/chosen.txt
> > @@ -0,0 +1,42 @@
> > +The chosen node
> > +---------------
> > +
> > +The chosen node does not represent a real device, but serves as a place
> > +for passing data between firmware and the operating system, like boot
> > +arguments. Data in the chosen node does not represent the hardware.
> > +
> > +
> > +stdout-path property
> > +--------------------
> > +
> > +Device trees may specify the device to be used for boot console output
> > +with a stdout-path property under /chosen, as described in ePAPR, e.g.
> > +
> > +/ {
> > +	chosen {
> > +		stdout-path = "/serial@f00:115200";
> > +	};
> > +
> > +	serial@f00 {
> > +		compatible = "vendor,some-uart";
> > +		reg = <0xf00 0x10>;
> > +	};
> > +};
> > +
> > +If the character ":" is present in the value, this terminates the path.
> > +The meaning of any characters following the ":" is device-specific, and
> > +must be specified in the relevant binding documentation.
> > +
> > +For UART devices, the format supported by uart_parse_options() is the
> > +expected one. In this case, the format of the string is:
> 
> Please drop the mention of uart_parse_options and just describe the
> format. Linux internal details are irrelevant to the contract of the
> binding.
> 
> Otherwise this looks good to me!

I've fixed it up and merged it. No need to respin. Thanks!

g.

