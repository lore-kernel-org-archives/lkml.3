Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3K2V4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 16:56:21 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54108 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3K2V4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 16:56:18 -0500
Date: Fri, 29 Nov 2013 22:56:16 +0100
From: Andreas Mohr <andi@lisas.de>
To: venkata koppula <vmrkoppula@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Copying large files eats all of the RAM
Message-ID: <20131129215616.GA32242@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKK=TUJ=ebu3+hBQmm+5=uooCFo9y3oAS_JfSn_KOtfxCLBvQQ@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> My laptop has 4GB of ram, before I issue the command around 1.5GB of
> memory
> is used, when I issue the cp command around 3.7GB of memory is used.
> And the cp command takes a lot of time to copy.
> 
> I am not able to launch other applications(take a lot of time) and
> even compiz freezes frequently. my laptop has Ubuntu installed on it.
> 
> Is this the problem with only my system or it is a common problem with
> Linux?.
> 
> Is there any way to stop any copy command to use all of my memory.

The purpose of a good operating system is *exactly* to optimize the
*all* RAM is used, *all* the time optimum to the highest degree.
Or would you want to have your power supply used to power useless
memory that's sitting idle?

It's probably a good idea to read up on the many sites which explain
important OS caching mechanisms.

That said, there may of course be situations where too much
competition/contention for resources occurs, or where calculation of the
kept-free-for-reuse memory amount is sub-optimal, leaving overly scarce
amounts of memory available for immediate use.
But that should be a matter of optimizing core kernel algorithms
even more than they already are.

And it's also known that for certain situations (e.g. trying to push very large
amounts of data over a lowly USB 1.1 USB stick connection),
Linux does (or did?) tend to have issues with that cached data piling up
in somewhat negative ways prior to getting flushed over the connection,
thereby causing system performance to degrade (I'm not in the know of
how much that still applies to very new Linux kernel versions).

But in your case that might simply be a problem of your particular
hardware (IRQ issues, improperly implemented drivers, ...).
Some benchmarking activities might be able to provide more details
(e.g. hdparm -tT, bonnie++ results, memory performance tests, etc.).

cat /proc/slabinfo
ought to provide an initial overview of which cache elements
manage to keep the largest memory areas in service.

HTH,

Andreas Mohr
