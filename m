Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaCMLFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:05:18 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:50152 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbaCMLFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:05:14 -0400
Date: Thu, 13 Mar 2014 12:05:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Archs <linux-arch@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Huiqingding <huding@redhat.com>
Subject: Re: [GIT PULL v2] timers updates for 3.15
Message-ID: <20140313110510.GA10424@gmail.com>
References: <1394642174-14315-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394642174-14315-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo, Thomas,
> 
> Please pull the timers/cputime-fix-steal-v3 branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/cputime-fix-steal-v3
> 
> Only the last patch changed to address Peterz concern on arch Kbuild
> layout. This got sorted out by running the script from b119fa61d440f
> to alpabetically sort the entries.
> 
> ---
> The main purpose of this set is to fix a bug on full dynticks configs
> where steal time accounting appears to be zero in /proc/stat even
> after a few seconds of competing guests running busy loops in a same
> host CPU. It's not a regression though as it was there since the
> beginning with full dynticks.
> 
> So patch [4/6] ("cputime: Fix jiffies based cputime assumption on
> steal accounting") is the most important patch of the series. The rest
> is mostly preparatory work to fix the bug plus various cleanups.
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (6):
>       cputime: Fix nsecs_to_cputime() return type cast
>       cputime: Default implementation of nsecs -> cputime conversion
>       cputime: Bring cputime -> nsecs conversion
>       cputime: Fix jiffies based cputime assumption on steal accounting
>       sched: Remove needless round trip nsecs <-> tick conversion of steal time
>       arch: Remove stub cputime.h headers
> 
> 
>  arch/alpha/include/asm/Kbuild         |  7 ++++---
>  arch/alpha/include/asm/cputime.h      |  6 ------
>  arch/cris/include/asm/Kbuild          |  3 ++-
>  arch/cris/include/asm/cputime.h       |  6 ------
>  arch/frv/include/asm/Kbuild           |  5 +++--
>  arch/frv/include/asm/cputime.h        |  6 ------
>  arch/m32r/include/asm/Kbuild          |  5 +++--
>  arch/m32r/include/asm/cputime.h       |  6 ------
>  arch/microblaze/include/asm/Kbuild    |  5 +++--
>  arch/microblaze/include/asm/cputime.h |  1 -
>  arch/mn10300/include/asm/Kbuild       |  3 ++-
>  arch/mn10300/include/asm/cputime.h    |  1 -
>  arch/score/include/asm/Kbuild         |  4 ++--
>  arch/score/include/asm/cputime.h      |  6 ------
>  arch/x86/include/asm/Kbuild           |  1 +
>  arch/x86/include/asm/cputime.h        |  1 -

Does this tree also address the heavy conflicts with tip:core/locking? 
If not then we should probably carry this in a separate branch that 
merges tip:core/locking and tip:timers/core.

Thanks,

	Ingo
