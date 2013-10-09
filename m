Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab3JIPZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:25:35 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:27411
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339Ab3JIPZd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:25:33 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Wed, 9 Oct 2013 08:25:27 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] clk/zynq/clkc: Add 'fclk-enable' feature
References: <1381242972-14752-1-git-send-email-soren.brinkmann@xilinx.com>
 <20131008153816.GB4981@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20131008153816.GB4981@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <fe3858e7-e3e2-4806-aeca-a2a4676e09aa@CO1EHSMHS007.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 04:38:17PM +0100, Mark Rutland wrote:
> On Tue, Oct 08, 2013 at 03:36:11PM +0100, Soren Brinkmann wrote:
> > In some use cases Zynq's FPGA clocks are used as static clock
> > generators for IP in the FPGA part of the SOC for which no Linux driver
> > exists and would control those clocks. To avoid automatic
> > gating of these clocks in such cases a new property - fclk-enable - is
> > added to the clock controller's DT description to accomodate such use
> > cases. It's value is a bitmask, where a set bit results in enabling
> > the corresponding FCLK through the clkc.
> > 
> > FPGA clocks are handled following the rules below:
> > 
> > If an FCLK is not enabled by bootloaders, that FCLK will be disabled in
> > Linux. Drivers can enable and control it through the CCF as usual.
> > 
> > If an FCLK is enabled by bootloaders AND the corresponding bit in the
> > 'fclk-enable' DT property is set, that FCLK will be enabled by the clkc,
> > resulting in an off by one reference count for that clock. Ensuring it
> > will always be running.
> > 
> > The default value for 'fclk-enable' is '0xf' (all FCLK's enabled by the
> > bootloader are enabled through the clkc.
> 
> Why? Juding by the diff that's not what the code currently does, so why
> not leave it as 0, and only set it where required as a work-around?
The default is set as described here:
[...]
> > +	ret = of_property_read_u32(np, "fclk-enable", &fclk_enable);
> > +	if (ret)
> > +		fclk_enable = 0xf;
> > +

The default has been chosen this way, because it avoids trouble with
customers. Customers expect the FPGA clocks to be running, once they
configured them in the FPGA tools. If Linux gates them off for some
reason, it creates confusion and often ends up in customer support.
But in general I agree. It is kind of a work around and having zero as
default would be desirable. I'd leave this to Michal.

	Sören


