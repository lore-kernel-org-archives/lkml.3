Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbaHYRqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:46:35 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:44184 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256AbaHYRqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:46:33 -0400
Date: Mon, 25 Aug 2014 11:46:10 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
Message-ID: <20140825174610.GA13737@obsidianresearch.com>
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com>
 <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl>
 <53F5D8D9.7040604@suse.de>
 <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl>
 <CAGVrzcYWN83tznwvw1M9V_mwWgobs2kwtRvEj4stqE=XGC10fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVrzcYWN83tznwvw1M9V_mwWgobs2kwtRvEj4stqE=XGC10fg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 01:47:09PM -0700, Florian Fainelli wrote:

> >  - the ID based strings seem to be not needed since, IIUC, the core
> >    reads the ID from the PHY and uses it, so I just left it out not
> >    trying to figure out how to obtain the correct ID
> 
> It is not needed, but it is one way to specify a PHY device if you do
> not know what compatible string to use instead.

No, it is a way to specify a PHY device if the kernel can't auto probe
the Phy ID.

Last I checked, the kernel doesn't support plain text compatible
strings for phys - everything is driven on the phy id, either auto
probed or specified in the DT.

> >  - the marvell compatible strings are used in our vendor tree. They
> >    aren't used anywhere but in our vendor tree. I though keeping them is
> >    nice since it identifies the PHY fully. And in case that level of
> >    detail is needed at some point it is already there.
> 
> And this is the recommended way to do it in case we ever need to key a
> software decision based on the hardware.

All compatible strings need to be documented.

.. and they need to encode more information than you get from the phy
id - die revsision, package option, functional options, voltage
codes. Etc.

.. and they actually need to be *right*

An example: The kernel reports 88E1318S for all four chips in that
family, AFAIK you have to read the package marking to figure out which
you have (it is the same die, with options switched on/off at
packaging time). People have already posted patches trying to
helpfully add a 'marvell,88E1318S' compatible string based on kernel
output. Except it is wrong, it isn't actually the '8S version in the
HW.

Even worse, Marvell has a whole series of socket compatible phys. Just
because the board the DT author looked at has a '318, doesn't mean
that every board ever made will. We've actually already been switching
between the 318 and 318S for production depending on which has part
availability.

Basically: don't try to override self-discoverable hardware in DT
without a really good reason.

Jason
