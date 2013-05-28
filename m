Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609Ab3E1PlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:41:19 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11193 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934448Ab3E1PlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:41:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/uEENgoKXK5DenXxFR8gMM93PaBz/x5lw=
Date: Tue, 28 May 2013 11:40:47 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/10] clk: mvebu: restructure SoC clock drivers
Message-ID: <20130528154047.GT31290@titan.lakedaemon.net>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, Sebastian,

In order to avoid losing changes between this series and mvebu/pcie,
I've rebased this series on top of mvebu/pcie and incorporated the
correct conflict resolution into this series.  See below...

On Sat, May 11, 2013 at 03:08:00AM +0200, Sebastian Hesselbarth wrote:
> Marvell EBU SoCs share some common clock functions that register core
> clocks or clock gates from SoC specific data. These clock drivers are
> organized by function and over time the drivers filled up with #ifdefs
> to separate different SoC specific code.
> 
> This patch set first adds a new element to clock gate descriptors to
> allow to pass clk flags per clock gate. (Patch 1)
> 
> Then it restructures MVEBU clock drivers into common clock setup and
> SoC specific files and Kconfig options. The driver's init functions
> are also registered to get called with of_clk_init. (Patches 2, 3-6)
> 
> It then switches Dove, Kirkwood, and Armada 370/XP to make use of
> of_clk_init instead of mvebu_clocks_init. (Patches 7-9)
> 
> Finally, all obsolete files and Kconfig options are removed. (Patch 10)
> 
> It has been tested on CuBox (Dove) and Dockstar (Kirkwood) by me.
> Armada 370 and XP are compile tested only and should get their Tested-by
> from Thomas and Gregory, respectively.
> 
> @Mike: As this only touches MVEBU related code, I suggest to take it
> all through the corresponding ARM branch.
> 
> Sebastian Hesselbarth (10):
>   clk: mvebu: introduce per-clock-gate flags

I updated armada_370_gating_descr[] and armada_xp_gating_descr[] to
incorporate Thomas' pcie changes.

>   clk: mvebu: add common clock functions for core clk and clk gating
>   clk: mvebu: add Dove SoC-centric clock init
>   clk: mvebu: add Kirkwood SoC-centric clock init

>   clk: mvebu: add Armada 370 SoC-centric clock init
>   clk: mvebu: add Armada XP SoC-centric clock init

I then migrated the changes above to these two commits.

>   ARM: dove: move DT boards to SoC-centric clock init
>   ARM: kirkwood: move DT boards to SoC-centric clock init
>   ARM: mvebu: move DT boards to SoC-centric clock init

>   clk: mvebu: desintegrate obsolete file

Obviously, the diffstat changed slightly here.

I'm posting the revised version as replies to patches 1, 5 and 6. Please
let me know if I messed it up.  I'd like to send the PR for these
shortly.

thx,

Jason.
