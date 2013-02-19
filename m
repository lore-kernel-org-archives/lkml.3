Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3BSFKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:10:06 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:34748
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161Ab3BSFKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:10:05 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I4015Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 19 Feb 2013 13:10:09 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>, Pavel Machek <pavel@denx.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Simon Horman <horms+renesas@verge.net.au>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH 8/9] [HACK] ARM: imx: work around v7_cpu_resume link error
Message-ID: <20130219051006.GB3108@S2101-09.ap.freescale.net>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
 <1360882071-4072668-9-git-send-email-arnd@arndb.de>
 <20130215110720.GL17833@n2100.arm.linux.org.uk>
 <alpine.LFD.2.03.1302152336520.6419@syhkavp.arg>
 <20130218055541.GK6782@S2101-09.ap.freescale.net>
 <alpine.LFD.2.03.1302181204050.6419@syhkavp.arg>
 <20130219014238.GA3108@S2101-09.ap.freescale.net>
 <alpine.LFD.2.03.1302182245400.6419@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1302182245400.6419@syhkavp.arg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 11:11:30PM -0500, Nicolas Pitre wrote:
> On Tue, 19 Feb 2013, Shawn Guo wrote:
> 
> > On Mon, Feb 18, 2013 at 12:06:32PM -0500, Nicolas Pitre wrote:
> > > Try the following instead.  It makes the code simpler and easier to 
> > > debug.
> > > 
> > It works now.  Thanks, Nico.  Care to send a patch for it?  I'd like
> > to apply it.
> 
> ----- >8
> 
> FRom: Nicolas Pitre <nicolas.pitre@linaro.org>
> Date: Mon, 18 Feb 2013 12:06:32 -0500 (EST)
> Subject: ARM: mach-imx: move early resume code out of the .data section
> 
> Building the kernel with allyesconfig fails because the i.mx early
> resume code located in the .data section is unable to fixup the bl
> relocation as the branch target gets too far away.
> 
> The idea of having code in the .data section allows for easy access to 
> nearby data using relative addressing while the MMU is off. However it 
> is probably best to move the code back to the .text section where it 
> belongs and fixup the data access instead.  This solves the bl reloc
> issue (at least until this becomes a general problem) and simplifies
> the code as well.
> 
> Signed-off-by: Nicolas Pitre <nico@linaro.org>

Applied as a fix for 3.9-rc, thanks.

Shawn

