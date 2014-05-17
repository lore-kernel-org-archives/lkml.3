Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783AbaEQJr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 05:47:56 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:51523 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757009AbaEQJrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 05:47:55 -0400
Date: Sat, 17 May 2014 10:46:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: remove ARM710 specific assembler code
Message-ID: <20140517094636.GP3693@n2100.arm.linux.org.uk>
References: <1364507176.1345.45.camel@x61.thuisdomein> <8309592.drxAj71PnZ@wuerfel> <1400059550.31197.12.camel@x220> <4305975.PvMXZQ020k@wuerfel> <1400232598.20342.16.camel@x220> <20140516125545.GO3693@n2100.arm.linux.org.uk> <20140517092337.GA67711@MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140517092337.GA67711@MacBook-Pro.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 10:23:37AM +0100, Catalin Marinas wrote:
> On Fri, May 16, 2014 at 01:55:46PM +0100, Russell King - ARM Linux wrote:
> > There was a CPU called the ARM710, it was ARMv3 and it had no Thumb support.
> > 
> > There is also a CPU called the ARM710T, which is ARMv4 and has Thumb support.
> > 
> > These are two completely different CPUs, the former was removed along with
> > the removal of ARMv3 support.  The latter remains because we still support
> > ARMv4.
> 
> BTW, while clearly this patch was removing code for the wrong reasons, I
> think we should set a longer term timeline for getting rid of some of
> old features. Let's say in 10 years time we remove everything ARMv4,
> another 10 years ARMv5 and so on. We could make these milestones shorter
> but it really depends on what people use, we should not force them out
> of the kernel if still in use.

I still use StrongARM based machines here, and I don't see that changing
unless some suitably designed ARM boards come my way which (a) offer the
same features and (b) out perform it.

The problem is that there's lots of ARM boards which satisfy (b) - the
iMX6 stuff clearly does - but hardly anything which satisfies (a).

There's also been some recent effort with SA1100 SoC code, so there's
also other interest there still.

So, ARMv4 is still very much in use with modern kernels.

The difference between what you're proposing and what happened to ARMv3
is that ARMv3 was broken for quite some time (we read from some of the
CP15 registers which are read-only in ARMv3) and no one ever raised a
problem with that.  So, after a sufficient period of time, it got removed
- and no one batted an eyelid.  That's the correct way to do it - allow
code to age, and if no one notices it's been broken, then it can be
removed.

That process is slightly broken by the automated build testing we now
have (provided people are looking at the results.)

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
