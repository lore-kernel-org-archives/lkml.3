Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaKEJLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:11:38 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:49776 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbaKEJLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:11:33 -0500
Message-ID: <1415178691.20372.225.camel@x220>
Subject: Re: [PATCH v3] ARM: mvebu: rename ARM_ERRATA_753970
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 05 Nov 2014 10:11:31 +0100
In-Reply-To: <20140912133142.GJ12361@n2100.arm.linux.org.uk>
References: <1396777049.30640.9.camel@x220>
	 <53418889.2050002@free-electrons.com> <1396805315.7723.8.camel@x220>
	 <1401094871.25902.20.camel@x220>
	 <20140620202100.GG21711@titan.lakedaemon.net>
	 <20140620205340.GX32514@n2100.arm.linux.org.uk>
	 <1403514104.12982.20.camel@x220>
	 <20140623090714.GH32514@n2100.arm.linux.org.uk>
	 <1403516086.12982.35.camel@x220> <1410520205.31130.33.camel@x220>
	 <20140912133142.GJ12361@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Nov 2014 09:11:31.0697 (UTC) FILETIME=[7D5DFE10:01CFF8D8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Fri, 2014-09-12 at 14:31 +0100, Russell King - ARM Linux wrote:
> On Fri, Sep 12, 2014 at 01:10:05PM +0200, Paul Bolle wrote:
> > ARM_ERRATA_753970 was renamed to PL310_ERRATA_753970 in v3.2, through
> > commit fa0ce4035d48 ("ARM: 7162/1: errata: tidy up Kconfig options for
> > PL310 errata workarounds"). Two selects were added in v3.15 that still
> > use the previous name. Rename these. Make these select statements depend
> > on CACHE_L2X0, like all other select statements for PL310_ERRATA_753970
> > do, to be safe we don't inadvertently start to allow pointless
> > configurations in the future.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > v3: add CACHE_L2X0 dependency, as Russell requested.
> > 
> > Tested with "git grep" and fiddling with "make ARCH=arm [...]config".
> > Please shout if that's deemed insufficient.
> > 
> > Note that I promised this v3 over two months ago. Taking two months to
> > update this patch is not really something to be proud of. On the other
> > hand: no one bothered to prod me for this v3 or send in a proper fix
> > themselves. Add to this that I first reported these selects for an
> > outdated Kconfig symbol in April. So I begin to wonder whether these
> > selects statements are really needed to begin with.

Whatever will be done in the long run: no one else said anything about
my v3. It's now nearly seven months since I first reported this issue.
In the mean time three releases contained the bogus selects. Apparently
neither Marvell Armada 375 boards nor Marvell Armada 380/385 boards
actually need to select PL310_ERRATA_753970.

I think I'll send a trivial cleanup shortly.

> I wonder whether we should deal with this a different way: rather than
> having this stuff as a configuration option, have the work-arounds
> default to being enabled, and have kernel command parameters to disable
> them should that be necessary.
> 
> I expect the normal case is that everyone normally runs with these
> errata workarounds enabled (especially with a single zImage kernel), so
> there will be relatively few who need to disable them.  Plus, this gives
> flexibility on single zImage to turn the errata workarounds off without
> needing to rebuild.
> 
> The other major advantage is less Kconfig options with dependencies
> which seem all to easily to result in select abuse.

I have no idea what CACHE_L2X0, ie the L2x0 outer cache controller,
actually does nor what those PL310 errata are all about. So I can't
comment on the feasibility of your idea. Obviously, dropping Kconfig
symbols, and making configuration a bit easier would be one of the
benefits of that idea. But I wouldn't know whether it outweighs the
costs involved.

Thanks,


Paul Bolle

