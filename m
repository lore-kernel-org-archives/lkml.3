Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab3AJTYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:24:35 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:41717 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab3AJTYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:24:33 -0500
Date: Thu, 10 Jan 2013 12:24:17 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130110192417.GA18478@obsidianresearch.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130109231758.GA27065@obsidianresearch.com>
 <20130110071937.GG15212@avionic-0098.adnet.avionic-design.de>
 <201301100917.19577.arnd@arndb.de>
 <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de>
 <20130110182007.GA28004@obsidianresearch.com>
 <20130110185505.GA22944@avionic-0098.adnet.avionic-design.de>
 <20130110190327.GA23110@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110190327.GA23110@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 08:03:27PM +0100, Thierry Reding wrote:

> > > You'd piece a mapping together, each bus requires 16 64k mappings, a
> > > simple 2d array of busnr*16 of pointers would do the trick. A more
> > > clever solution would be to allocate contiguous virtual memory and
> > > split that up..
 
> > Oh, I see. I'm not very familiar with the internals of remapping, so
> > I'll need to do some more reading. Thanks for the hints.
> 
> I forgot to ask. What's the advantage of having a contiguous virtual
> memory area and splitting it up versus remapping each chunk separately?

Not alot, really, but it saves you from the pointer array and
associated overhead. IIRC it is fairly easy to do in the kernel.

Arnd's version is good too, but you would be restricted to aligned
powers of two for the bus number range in the DT, which is probably
not that big a deal either?

Jason
