Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaIHN2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:28:52 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:45591 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaIHN2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:28:51 -0400
Date: Mon, 8 Sep 2014 15:28:43 +0200
From: Robert Richter <rric@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Robert Richter <rrichter@cavium.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64, defconfig: Increase NR_CPUS default to 64
Message-ID: <20140908132843.GY4703@rric.localhost>
References: <1410176689-20020-1-git-send-email-rric@kernel.org>
 <3450151.nDuN2aF2Xl@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3450151.nDuN2aF2Xl@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.09.14 15:00:47, Arnd Bergmann wrote:
> On Monday 08 September 2014 13:44:48 Robert Richter wrote:
> > From: Robert Richter <rrichter@cavium.com>
> > 
> > Raising the current maximum limit to 64. This is needed for Cavium's
> > Thunder systems that will have at least 48 cores per die.
> > 
> > The change keeps the current memory footprint in cpu mask structures.
> > It does not break existing code. Setting the maximum to 64 cpus still
> > boots systems with less cpus.
> > 
> > Mark's Juno happily booted with a NR_CPUS=64 kernel.
> > 
> > Tested on our Thunder system with 48 cores. We could see interrupts to
> > all cores.
> > 
> > Cc: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Robert Richter <rrichter@cavium.com>
> > 
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> FWIW, have you tried what happens when you increase the number further?
> We have architectures on which we support thousands of CPUs, so I wonder
> if there is a point at which this stops working on ARM64.
> 
> Are you able to compile and boot a kernel built with e.g. NR_CPUS=256 or
> 4096 on your hardware?

We haven't tried this so far, but it's definitely on our list testing
this.

-Robert
