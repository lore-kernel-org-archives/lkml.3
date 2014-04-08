Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbaDHR2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:28:21 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:52576 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856AbaDHR2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:28:19 -0400
Date: Tue, 8 Apr 2014 11:27:52 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH v2 2/5] ARM: zynq: dt: Convert to preprocessor includes
Message-ID: <20140408172752.GC27776@obsidianresearch.com>
References: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com>
 <1396653256-28397-3-git-send-email-soren.brinkmann@xilinx.com>
 <53423E75.3020008@monstr.eu>
 <53429754.8080105@topic.nl>
 <534298E7.2020409@monstr.eu>
 <20140407171012.GC9952@obsidianresearch.com>
 <20140407180228.GN12170@pengutronix.de>
 <53439F3F.2030801@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53439F3F.2030801@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 09:03:27AM +0200, Michal Simek wrote:

> > If in doubt follow common mainline practice. Although using includes
> > for DT is not necessarily common practice, readability of DTs is
> > really important IMHO.
> 
> Let me give you one example. When you add xilinx intc controller
> to zynq HW design which uses gic with headers you are using
> then you will find out that sensitivity for both controllers
> are just different.
> This is just one case I am aware of. I expect there will be one more.

I'm not sure I see the problem here, just because some bindings can't
use the standard shared constants doesn't mean the GIC bindings and
users should avoid them. The binding documentation is supposed to make
it clear what is correct.

It is just as easy to get confused with numbers, does 4 mean
XILINX_INTC_IRQ_RISING or IRQ_TYPE_LEVEL_HIGH ?

> Using dtc preprocessor and macros improve DTS readability but at the same
> time force other users to copy all necessary files from the kernel
> to that projects which is just hassle.

You can run the DTS through cpp before you export it out of the kernel
environment, then you get a flat file with no includes.

The shared kernel conventions are more important than constraints from
outside projects.

Jason
