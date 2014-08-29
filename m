Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbaH2XWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 19:22:24 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:57986 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaH2XWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 19:22:22 -0400
Date: Fri, 29 Aug 2014 17:22:03 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
Message-ID: <20140829232203.GA17664@obsidianresearch.com>
References: <53F5D8D9.7040604@suse.de>
 <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl>
 <CAGVrzcYWN83tznwvw1M9V_mwWgobs2kwtRvEj4stqE=XGC10fg@mail.gmail.com>
 <20140825174610.GA13737@obsidianresearch.com>
 <53FB9AC4.8010704@gmail.com>
 <660fe929-1f16-4e22-8bd3-0388cd363978@BY2FFO11FD038.protection.gbl>
 <540099AF.4020005@suse.de>
 <e52ebd6c-2f0d-4ea9-a01f-882212956ace@BL2FFO11FD029.protection.gbl>
 <20140829173102.GA30917@obsidianresearch.com>
 <5400C53D.70501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5400C53D.70501@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 11:23:57AM -0700, Florian Fainelli wrote:
> On 08/29/2014 10:31 AM, Jason Gunthorpe wrote:
> > On Fri, Aug 29, 2014 at 08:35:36AM -0700, Sören Brinkmann wrote:
> > 
> >> The compatible string is listed as optional property for PHYs. So, not
> >> having one is an option, I guess. But, I'd also prefer to at least keep
> >> the -c22 one, since I saw problems when I tried using -c45 (the Zed phy
> >> should support it...).
> > 
> > -c45 and -c22 use a completely different MDIO protocol, Zed doesn't
> > have a 10GE port, so it certainly doesn't use -c45.
> 
> Most recent 1GbE PHYs should also implement clause 45. It is a nice
> improvement if you are using lot of transactions, otherwise clause 45
> over clause 22 is suitable and supported by the PHY library (for EEE in
> particular).

Oh, that is interesting, I haven't actually seen one of those yet..

Hum. So that is messy, even if the Zed phy supports the C45 format,
the macb driver (and by my reading, the Zynq hardware) lacks the
capability to generate C45 frames.

It could be supported, but you'd have to use the GPIO bitbang MDIO
driver to talk to the phy.

So... that makes the compatible string for the phy even more
confusing. 'Describe The HW' says it should have both c22 and c45
listed - however we don't have software support in Linux to negotiate
c22 and c45 support between the phy bus driver and attached phy :(

Jason
