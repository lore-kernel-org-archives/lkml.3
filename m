Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab3A2IoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:44:07 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:55287 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab3A2IoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:44:04 -0500
Date: Tue, 29 Jan 2013 09:44:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        lkp@linux.intel.com
Subject: Re: aim7 performance regression by commit 5a50508 report from LKP
Message-ID: <20130129084400.GA5350@gmail.com>
References: <20130129082537.GS12678@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129082537.GS12678@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:

> [...]

Very nice measurements and analysis, thanks!

> As stated above, anybody can have a chance to own the lock in 
> mutex once somebody release the lock. Well, there is only one 
> to own the lock in rwsem write lock, and the one is known 
> already: the one in the head of wait list. That would result 
> to more contention in rwsem write lock case, especially if the 
> one _will_ own the lock is not running now.

I think we should allow lock-steal between rwsem writers - that 
will not hurt fairness as most rwsem fairness concerns relate to 
reader vs. writer fairness.

Am I correct to assume that all relevant users in this workload 
are down_write() users?

You can see the type of lock use in:

   perf record -g
   perf report

I bet that allowing rwsem writer lock-steal would improve other 
workloads as well.

Thanks,

	Ingo
