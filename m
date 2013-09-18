Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3IRRFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:05:31 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:36427
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870Ab3IRRF0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:05:26 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Wed, 18 Sep 2013 10:05:18 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] arm: zynq: Enable arm_global_timer
References: <1379004640-15117-1-git-send-email-soren.brinkmann@xilinx.com>
 <1379004640-15117-3-git-send-email-soren.brinkmann@xilinx.com>
 <20130915124036.A66A8C42C3C@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130915124036.A66A8C42C3C@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <9c796de2-4f19-4104-ae69-60f963a65d03@CH1EHSMHS028.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 01:40:36PM +0100, Grant Likely wrote:
> On Thu, 12 Sep 2013 09:50:40 -0700, Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> > Zynq is based on an ARM Cortex-A9 MPCore, which features the
> > arm_global_timer in its SCU. Therefore enable the timer for Zynq.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  arch/arm/boot/dts/zynq-7000.dtsi | 8 ++++++++
> >  arch/arm/mach-zynq/Kconfig       | 1 +
> >  2 files changed, 9 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> > index e32b92b..eaacb39 100644
> > --- a/arch/arm/boot/dts/zynq-7000.dtsi
> > +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> > @@ -92,6 +92,14 @@
> >  			};
> >  		};
> >  
> > +		global_timer: global_timer@f8f00200 {
> 
> Nit: node names and property names use '-' not '_'. Plus the generic
> names principle suggests the node should be names 'timer' not
> 'global_timer'. The following would be fine:
That is really good to know. When I wrote this line, I read through a
couple of other dtses and was unable to identify a consistent system
behind node/label names.

> 
> 		global_timer: timer@f8f00200 {
All right, I'll change it to this.

	
	Thanks,
	Sören


