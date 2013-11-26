Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3KZL5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:57:32 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:41089 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab3KZL53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:57:29 -0500
Date: Tue, 26 Nov 2013 12:57:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] remove CONFIG_SCHED_HRTICK
Message-ID: <20131126115726.GA5628@gmail.com>
References: <20131123143639.GA2735@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123143639.GA2735@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> It's equivalent to CONFIG_HIGH_RES_TIMERS now that all architectures 
> use the generic helpers it relies on.

So the SCHED_HRTICK variable documents the scheduler's dependencies 
here. It currently indeed clones CONFIG_HIGH_RES_TIMERS, but that's 
just how it's implemented today.

If we were to enable this feature more widely in the future (it's 
expensive right now so disabled by default at the moment) then it will 
be much easier to just change.

That said, while checking the background of the changes here ran 
across two ARM commits that I don't really like:

  commit c9218b163959fafa76ffbee0baa3ef269838f410
  Author: Russell King <rmk+kernel@arm.linux.org.uk>
  Date:   Sat Apr 27 23:31:10 2013 +0100

      ARM: Allow selection HZ values

this commit introduced a nonsensical duplication:

  +config SCHED_HRTICK
  +       def_bool HIGH_RES_TIMERS
 
   config SCHED_HRTICK
          def_bool HIGH_RES_TIMERS

Plus:

  commit b28748fb5d21d5d64c9ce31579ffbbd41f317042
  Author: Russell King <rmk+kernel@arm.linux.org.uk>
  Date:   Sun Feb 17 14:40:33 2013 +0000

    ARM: add SCHED_HRTICK config option
    
    As we don't include kernel/Kconfig.hz as this defines HZ values
    unsuitable for ARM platforms, add the SCHED_HRTICK to properly configure
    the scheduler for hrtimer operation.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

... so if kernel/Kconfig.hz is 'unsuitable for ARM platforms' how 
about fixing it properly and making init/Kconfig.hz suitable for ARM, 
instead of duplicating its options in arch/arm/Kconfig in a messy 
fashion?

Thanks,

	Ingo
