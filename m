Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaH2Rba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:31:30 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:39729 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbaH2Rb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:31:28 -0400
Date: Fri, 29 Aug 2014 11:31:02 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
Message-ID: <20140829173102.GA30917@obsidianresearch.com>
References: <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com>
 <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl>
 <53F5D8D9.7040604@suse.de>
 <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl>
 <CAGVrzcYWN83tznwvw1M9V_mwWgobs2kwtRvEj4stqE=XGC10fg@mail.gmail.com>
 <20140825174610.GA13737@obsidianresearch.com>
 <53FB9AC4.8010704@gmail.com>
 <660fe929-1f16-4e22-8bd3-0388cd363978@BY2FFO11FD038.protection.gbl>
 <540099AF.4020005@suse.de>
 <e52ebd6c-2f0d-4ea9-a01f-882212956ace@BL2FFO11FD029.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e52ebd6c-2f0d-4ea9-a01f-882212956ace@BL2FFO11FD029.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 08:35:36AM -0700, Sören Brinkmann wrote:

> The compatible string is listed as optional property for PHYs. So, not
> having one is an option, I guess. But, I'd also prefer to at least keep
> the -c22 one, since I saw problems when I tried using -c45 (the Zed phy
> should support it...).

-c45 and -c22 use a completely different MDIO protocol, Zed doesn't
have a 10GE port, so it certainly doesn't use -c45.

If there is no compatible string at all the defined default is to use
-c22.

> Also, so far, we haven't had any phy nodes in our Zynq dts files and
> Ethernet worked, so the auto-detection there works pretty well
> apparently. But it may be problematic if more than a single PHY is on
> the MDIO bus, I'd assume.

Phy autodetection has always worked in some cases, but for DT ethernet
bindings it is expected that there is an option to specify an explicit
MDIO bus, and a phy-handle phandle to point to the phy. The phy should
be explicitly called out with the fixed MDIO address specified to
avoid sketchy MDIO address auto probing.

This provides the framework to specify interrupts and register
overrides for the phy in the DT.

Jason
