Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab3AJVGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 16:06:32 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:52515 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab3AJVGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 16:06:30 -0500
Date: Thu, 10 Jan 2013 14:06:14 -0700
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
Message-ID: <20130110210614.GA21836@obsidianresearch.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130109231758.GA27065@obsidianresearch.com>
 <20130110071937.GG15212@avionic-0098.adnet.avionic-design.de>
 <201301100917.19577.arnd@arndb.de>
 <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de>
 <20130110182007.GA28004@obsidianresearch.com>
 <20130110185505.GA22944@avionic-0098.adnet.avionic-design.de>
 <20130110190327.GA23110@avionic-0098.adnet.avionic-design.de>
 <20130110192417.GA18478@obsidianresearch.com>
 <20130110202007.GA26139@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110202007.GA26139@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 09:20:07PM +0100, Thierry Reding wrote:

> > Arnd's version is good too, but you would be restricted to aligned
> > powers of two for the bus number range in the DT, which is probably
> > not that big a deal either?
> 
> Stephen suggested on IRC that we could try to keep a bit of dynamicity
> in the allocation scheme if we create the bus mapping when the first
> device on the bus is probed and discard the mapping if no devices are
> found.

You probably don't need to mess around with 'discard on empty' the
kernel should only access bus numbers that are in the range of the
subordinate busses of the bridges. So if you establish a mapping on a
bus-by-bus basis at first access, it should be fine and very close to
minimal..

Jason
