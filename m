Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaFWJeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:34:50 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:53195 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbaFWJes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:34:48 -0400
Message-ID: <1403516086.12982.35.camel@x220>
Subject: Re: [PATCH v2] ARM: mvebu: rename ARM_ERRATA_753970
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Jun 2014 11:34:46 +0200
In-Reply-To: <20140623090714.GH32514@n2100.arm.linux.org.uk>
References: <201404052101.19381.arnd@arndb.de>
	 <201404052104.11363.arnd@arndb.de> <1396777049.30640.9.camel@x220>
	 <53418889.2050002@free-electrons.com> <1396805315.7723.8.camel@x220>
	 <1401094871.25902.20.camel@x220>
	 <20140620202100.GG21711@titan.lakedaemon.net>
	 <20140620205340.GX32514@n2100.arm.linux.org.uk>
	 <1403514104.12982.20.camel@x220>
	 <20140623090714.GH32514@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2014 09:34:46.0133 (UTC) FILETIME=[5EBFCA50:01CF8EC6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 10:07 +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 23, 2014 at 11:01:44AM +0200, Paul Bolle wrote:
> > Dropped the "if CACHE_PL310" fragments used in v1. No need to use "if
> > CACHE_L2X0" instead. Both CACHE_PL310 and CACHE_L2X0 will be
> > (indirectly) selected if MACH_ARMADA_375 or MACH_ARMADA_38X are set.
> 
> Yes there is.  We've recently seen the selection of CACHE_L2X0 be removed
> from platforms, while leaving the selection of the errata behind.  The
> result is Kconfig warnings.  My commit above ensures that this doesn't
> happen in the future by adding the proper dependencies onto those errata
> selects.

The entries I touched read (in summary):
config MACH_MVEBU_V7
        bool
        select CACHE_L2X0

config MACH_ARMADA_370
        bool "Marvell Armada 370 boards" if ARCH_MULTI_V7
        select MACH_MVEBU_V7
        help
          [...].

config MACH_ARMADA_375
        bool "Marvell Armada 375 boards" if ARCH_MULTI_V7
        select MACH_MVEBU_V7
        help
          [...].

So the choice I faced was between: 
- using "select PL310_ERRATA_753970 if CACHE_L2X0": that matches all
  current occurrences of "select PL310_ERRATA_*" but adds a superfluous
  dependency on CACHE_L2X0
- using just "select PL310_ERRATA_753970": sufficient, but will break
  if CACHE_L2X0 isn't selected through MACH_MVEBU_V7 anymore.

I chose to just "select PL310_ERRATA_753970" but adding "if CACHE_L2X0"
is fine with me too.

> Please do the same.

Will do later today.

Thanks,


Paul Bolle

