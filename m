Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaAONKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:10:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36897 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaAONJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:09:59 -0500
Date: Wed, 15 Jan 2014 14:09:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [sched] d50dde5a1: LTP sched_setparam* TFAILs
Message-ID: <20140115130938.GF31570@twins.programming.kicks-ass.net>
References: <20140115124739.GB19419@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115124739.GB19419@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 08:47:39PM +0800, Fengguang Wu wrote:
> Hi Dario,
> 
> We notice the below LTP failures since commit d50dde5a1 ("sched: Add
> new scheduler syscalls to support an extended scheduling parameters
> ABI") in tip tree's sched/core branch:
> 
> ltp.sched_setparam02.1.TFAIL
> ltp.sched_setparam02.2.TFAIL
> ltp.sched_setparam02.3.TFAIL
> ltp.sched_setparam03.1.TFAIL
> 
> It seems that the LKP test failures are somehow expected due to the
> change of ABI. However it does mean that these test cases will need to
> be updated.

So with LTP from https://github.com/linux-test-project/ltp.git
and a tip/master build, I get:

root@westmere:/usr/local/src/ltp/testcases/kernel/syscalls/sched_setscheduler# ./sched_setscheduler01 
sched_setscheduler01    1  TPASS  :  expected failure - errno = 3 : No such process
sched_setscheduler01    2  TPASS  :  expected failure - errno = 22 : Invalid argument
sched_setscheduler01    3  TPASS  :  expected failure - errno = 14 : Bad address
sched_setscheduler01    4  TPASS  :  expected failure - errno = 22 : Invalid argument
root@westmere:/usr/local/src/ltp/testcases/kernel/syscalls/sched_setscheduler# ./sched_setscheduler02 
sched_setscheduler02    1  TPASS  :  got EPERM



