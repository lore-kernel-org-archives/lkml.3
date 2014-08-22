Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbaHVQVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:21:09 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:50993 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaHVQVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:21:07 -0400
Date: Fri, 22 Aug 2014 10:20:48 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
Message-ID: <20140822162048.GB8477@obsidianresearch.com>
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com>
 <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl>
 <53F5D8D9.7040604@suse.de>
 <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 08:49:19AM -0700, Sören Brinkmann wrote:

> So my thinkings:
>  - the compatible string with the -c22 is used and documented in the phy
>    bindings, it should be there.

Yes

>  - the ID based strings seem to be not needed since, IIUC, the core
>    reads the ID from the PHY and uses it, so I just left it out not
>    trying to figure out how to obtain the correct ID

It is certainly optional, I added the property to solve some obscure
problems with probing, but I've noticed people using it more broadly.
I suspect it also speeds up booting a tiny bit.

>  - the marvell compatible strings are used in our vendor tree. They
>    aren't used anywhere but in our vendor tree. I though keeping them is
>    nice since it identifies the PHY fully. And in case that level of
>    detail is needed at some point it is already there.

DT is complex enough already, don't include useless compatible strings
in mainline - people will see and tend to blindly copy. Ideally your
vendor tree would use the standard property :|

Jason
