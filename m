Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaAIHwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:52:06 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:4741 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204AbaAIHv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:51:57 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehcb8kz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h1155h)
Date: Thu, 9 Jan 2014 15:41:38 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <rob@landley.net>
Subject: Re: [PATCH] ARM: imx6q: Add missing esai_ahb clock to current clock
 tree
Message-ID: <20140109074137.GA14809@MrMyself>
References: <1389236699-10387-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140109035810.GB21717@S2101-09.ap.freescale.net>
 <20140109034940.GA14480@MrMyself>
 <20140109065740.GD21717@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140109065740.GD21717@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 02:57:42PM +0800, Shawn Guo wrote:
> On Thu, Jan 09, 2014 at 11:49:41AM +0800, Nicolin Chen wrote:
> > On Thu, Jan 09, 2014 at 11:58:12AM +0800, Shawn Guo wrote:
> > > >  static struct clk *clk[clk_max];
> > > > @@ -355,6 +355,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
> > > >  	clk[ecspi5]       = imx_clk_gate2("ecspi5",        "ecspi_root",        base + 0x6c, 8);
> > > >  	clk[enet]         = imx_clk_gate2("enet",          "ipg",               base + 0x6c, 10);
> > > >  	clk[esai]         = imx_clk_gate2("esai",          "esai_podf",         base + 0x6c, 16);
> > > > +	clk[esai_ahb]     = imx_clk_gate2("esai_ahb",      "ahb",               base + 0x6c, 16);
> > > 
> > > Hmm, having two clocks operating on the same gate bit will get us
> > > problem in clock disabling.  Clock enabling is fine, since either
> > > one who calls clk_enable() first will just set the gate bit.  But in
> > > case that clk_enable() is called on both clocks, and then when either
> > > clock calls clk_disable(), the gate bit will be cleared and thus breaks
> > > the other one that might still be in use.
> > 
> > Understood. But how could we handle this situation? The only way I can figure
> > out is to make sure the driver open/close them at the same time, it's not a
> > perfect way though.
> 
> Hmm, we generally leave the gate bit to the clock used to access
> register, because usually it's the first one to be on and the last one
> to be off.

Then we should attach CLK_IGNORE_UNUSED to clk[esai] since clk[esai_ahb] is
the clock used to access memory, shouldn't we?

Thank you.
Nicolin



