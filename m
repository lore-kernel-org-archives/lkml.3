Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3J3PB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:01:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41973 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab3J3PB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:01:57 -0400
Date: Wed, 30 Oct 2013 15:01:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>, Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mm: Fix ECC mem policy printk
Message-ID: <20131030150106.GC16735@n2100.arm.linux.org.uk>
References: <8986e8f1a3761e45a7927bdb0e54393c9155e6bf.1383137171.git.michal.simek@xilinx.com> <20131030130728.GA16735@n2100.arm.linux.org.uk> <5271165A.4050509@monstr.eu> <52711869.60703@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52711869.60703@monstr.eu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 03:32:09PM +0100, Michal Simek wrote:
> btw: passing ecc=on through command line will caused that "ECC enabled"
> message will be there even on systems which don't implement this bit.
> It is just side effect for both these solutions.

It is a hint, nothing more.  There is no way to detect whether it's
implemented or even how it has been implemented.

> Isn't there any easy way to test if this bit is implemented or not just
> by setting it up and clear it?

So... let's summerise the message that you're giving.

"My SoC doesn't implement this bit other than to provide ECC at the L1
cache, instead implementing a separate ECC scheme for system memory.
Therefore, I want to change it to describe my implementation, because
my customers are complaining that it says ECC is disabled when that
is not the case.  If it can't describe my setup, I want to remove the
whole facility."

That's a very selfish attitude.  Sorry, but it would be wrong of me
to allow your situation to change what we have beyond the proposed
patch.

I've shown you the ARM architecture reference manual where this bit in
the page tables is described, both older and newer versions.  What we're
doing is in the spirit of the descriptions of bit 9 in the L1 page tables.

I don't think there's any sensible short description which would
adequately describe this setting which would satisfy both your situation
and situations on other SoCs.  We could make the kernel print an entire
paragraph on it, something like:

"ECC might be %sabled.  The exact ECC setting depends on how your SoC
is implemented.  Please refer to your SoCs technical reference manual
for a description of bit 9 in the level one page tables for further
information on how to interpret this statement."

but that would be idiotic.

Of course, we could just print nothing, but the purpose of printing this
is so that _we_ as developers looking at the kernel messages know the
status of this bit, particularly when interpreting oops dumps.  Hiding
this information would make some oops dumps harder to diagnose.  So...
this is a matter for user education if your users are complaining about
it.
