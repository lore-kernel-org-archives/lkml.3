Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaHKEUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 00:20:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:38661 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaHKEUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 00:20:05 -0400
Message-ID: <1407730744.4508.67.camel@pasglop>
Subject: Re: [tip:timers/core] timekeeping: Fixup typo in
 update_vsyscall_old definition
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: john.stultz@linaro.org
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, sfr@canb.auug.org.au,
        linuxppc-dev@ozlabs.org
Date: Mon, 11 Aug 2014 14:19:04 +1000
In-Reply-To: <tip-953dec21aed4038464fec02f96a2f1b8701a5bce@git.kernel.org>
References: <1406349439-11785-1-git-send-email-john.stultz@linaro.org>
	 <tip-953dec21aed4038464fec02f96a2f1b8701a5bce@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 00:31 -0700, tip-bot for John Stultz wrote:
> Commit-ID:  953dec21aed4038464fec02f96a2f1b8701a5bce
> Gitweb:     http://git.kernel.org/tip/953dec21aed4038464fec02f96a2f1b8701a5bce
> Author:     John Stultz <john.stultz@linaro.org>
> AuthorDate: Fri, 25 Jul 2014 21:37:19 -0700
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 30 Jul 2014 09:26:25 +0200
> 
> timekeeping: Fixup typo in update_vsyscall_old definition
> 
> In commit 4a0e637738f0 ("clocksource: Get rid of cycle_last"),
> currently in the -tip tree, there was a small typo where cycles_t
> was used intstead of cycle_t. This broke ppc64 builds.

There's another bug in there... You fix timespec vs. timespec64 for the
first argument of update_vsyscall_old but not the second one ...
(wall_to_monotonic).

Also, in e2dff1ec0 you claim this is "minor", you seem to forget that
arch/powerpc also deals with 32-bit kernels which use the same time
keeping code, so we have a pretty serious regressions here...

BTW. Is there some documentation you can point me to to figure out what
replace that "_OLD" stuff so we can update to whatever is "new" ?

Cheers,
Ben.


