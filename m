Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaILNcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:32:03 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53107 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753319AbaILNcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:32:01 -0400
Date: Fri, 12 Sep 2014 14:31:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: mvebu: rename ARM_ERRATA_753970
Message-ID: <20140912133142.GJ12361@n2100.arm.linux.org.uk>
References: <1396777049.30640.9.camel@x220> <53418889.2050002@free-electrons.com> <1396805315.7723.8.camel@x220> <1401094871.25902.20.camel@x220> <20140620202100.GG21711@titan.lakedaemon.net> <20140620205340.GX32514@n2100.arm.linux.org.uk> <1403514104.12982.20.camel@x220> <20140623090714.GH32514@n2100.arm.linux.org.uk> <1403516086.12982.35.camel@x220> <1410520205.31130.33.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410520205.31130.33.camel@x220>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 01:10:05PM +0200, Paul Bolle wrote:
> ARM_ERRATA_753970 was renamed to PL310_ERRATA_753970 in v3.2, through
> commit fa0ce4035d48 ("ARM: 7162/1: errata: tidy up Kconfig options for
> PL310 errata workarounds"). Two selects were added in v3.15 that still
> use the previous name. Rename these. Make these select statements depend
> on CACHE_L2X0, like all other select statements for PL310_ERRATA_753970
> do, to be safe we don't inadvertently start to allow pointless
> configurations in the future.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> v3: add CACHE_L2X0 dependency, as Russell requested.
> 
> Tested with "git grep" and fiddling with "make ARCH=arm [...]config".
> Please shout if that's deemed insufficient.
> 
> Note that I promised this v3 over two months ago. Taking two months to
> update this patch is not really something to be proud of. On the other
> hand: no one bothered to prod me for this v3 or send in a proper fix
> themselves. Add to this that I first reported these selects for an
> outdated Kconfig symbol in April. So I begin to wonder whether these
> selects statements are really needed to begin with.

I wonder whether we should deal with this a different way: rather than
having this stuff as a configuration option, have the work-arounds
default to being enabled, and have kernel command parameters to disable
them should that be necessary.

I expect the normal case is that everyone normally runs with these
errata workarounds enabled (especially with a single zImage kernel), so
there will be relatively few who need to disable them.  Plus, this gives
flexibility on single zImage to turn the errata workarounds off without
needing to rebuild.

The other major advantage is less Kconfig options with dependencies
which seem all to easily to result in select abuse.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
