Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbaFWJHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:07:24 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38805 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754980AbaFWJHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:07:22 -0400
Date: Mon, 23 Jun 2014 10:07:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: mvebu: rename ARM_ERRATA_753970
Message-ID: <20140623090714.GH32514@n2100.arm.linux.org.uk>
References: <201404052101.19381.arnd@arndb.de> <201404052104.11363.arnd@arndb.de> <1396777049.30640.9.camel@x220> <53418889.2050002@free-electrons.com> <1396805315.7723.8.camel@x220> <1401094871.25902.20.camel@x220> <20140620202100.GG21711@titan.lakedaemon.net> <20140620205340.GX32514@n2100.arm.linux.org.uk> <1403514104.12982.20.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403514104.12982.20.camel@x220>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's nice to be ignored...

On Mon, Jun 23, 2014 at 11:01:44AM +0200, Paul Bolle wrote:
> ARM_ERRATA_753970 was renamed to PL310_ERRATA_753970 in v3.2, through
> commit fa0ce4035d48 ("ARM: 7162/1: errata: tidy up Kconfig options for
> PL310 errata workarounds"). Two selects were added in v3.15 that still
> use the previous name. Rename these.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> v2: redone on top of next-21040623, and therefor on top of commit
> a641f3a6abce ("ARM: l2c: fix dependencies on PL310 errata symbols").

And you obviously didn't read the commit or understand it.

> Dropped the "if CACHE_PL310" fragments used in v1. No need to use "if
> CACHE_L2X0" instead. Both CACHE_PL310 and CACHE_L2X0 will be
> (indirectly) selected if MACH_ARMADA_375 or MACH_ARMADA_38X are set.

Yes there is.  We've recently seen the selection of CACHE_L2X0 be removed
from platforms, while leaving the selection of the errata behind.  The
result is Kconfig warnings.  My commit above ensures that this doesn't
happen in the future by adding the proper dependencies onto those errata
selects.

Please do the same.

NAK.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
