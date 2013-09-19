Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3ISV5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:57:33 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:4663 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797Ab3ISV5c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:57:32 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dIc89bh936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz17326ah1de097h186068h5eeeK8275bhz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Thu, 19 Sep 2013 14:57:22 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v2] clk: si570: Add a driver for SI570 oscillators
References: <1379544219-23579-1-git-send-email-soren.brinkmann@xilinx.com>
 <20130919180512.5246.73360@quantum>
 <20130919211535.GB11537@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130919211535.GB11537@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <f59f4232-0f1a-4ebc-ada2-0edb9faabc53@CO9EHSMHS002.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 02:15:35PM -0700, Guenter Roeck wrote:
> On Thu, Sep 19, 2013 at 11:05:12AM -0700, Mike Turquette wrote:
> > Quoting Soren Brinkmann (2013-09-18 15:43:38)
> > > diff --git a/Documentation/devicetree/bindings/clock/silabs,si570.txt b/Documentation/devicetree/bindings/clock/silabs,si570.txt
> > > new file mode 100644
> > > index 0000000..7ab5c8b
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/clock/silabs,si570.txt
> > > @@ -0,0 +1,38 @@
> > > +Binding for Silicon Labs 570, 571, 598 and 599 programmable
> > > +I2C clock generators.
> > > +
> > > +Reference
> > > +This binding uses the common clock binding[1]. Details about the devices can be
> > > +found in the data sheets[2][3].
> > > +
> > > +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> > > +[2] Si570/571 Data Sheet
> > > +    http://www.silabs.com/Support%20Documents/TechnicalDocs/si570.pdf
> > > +[3] Si598/599 Data Sheet
> > > +    http://www.silabs.com/Support%20Documents/TechnicalDocs/si598-99.pdf
> > > +
> > > +Required properties:
> > > + - compatible: Shall be one of "silabs,si570", "silabs,si571",
> > > +                              "silabs,si598", "silabs,si599"
> > > + - reg: I2C device address.
> > > + - #clock-cells: From common clock bindings: Shall be 0.
> > > + - factory-fout: Factory set default frequency. This frequency is part specific.
> > > +                The correct frequency for the part used has to be provided in
> > > +                order to generate the correct output frequencies. For more
> > > +                details, please refer to the data sheet.
> > > +
> > > +Optional properties:
> > > + - clock-output-names: From common clock bindings. Recommended to be "si570".
> > > + - clock-frequency: Output frequency to generate. This defines the output
> > > +                   frequency set during boot. It can be reprogrammed during
> > > +                   runtime using the common clock framework.
> > > + - temperature-stability-7ppm: Indicate a device with a temperature stability
> > > +                              of 7ppm
> > 
> > Some DT binding bike-shedding:
> > 
> > Should this be "temperature-stability-ppm = <7>;" ? Do you think that
> > this value might change in the future?
> > 
> Valid values are 7, 20, and 50 as far as I know. Problem is that the value is
> not used directly, but only to hint that a specific set of registers shall be
> used.
> 
> Given that, it may in fact be better to use an explicit number. Even though the
> two register sets are specified by <7> in one case and <20,50> in the other
> today, there may at some point be yet another value which might use the 7 ppm
> register set or the 20/50 ppm register set ... or yet another register set.
> An explicit number would cover all future accuracy ranges, not just the
> existing ones.
Okay, I'm convinced. Changing that, I'd also make it a mandatory
property.

	Sören


