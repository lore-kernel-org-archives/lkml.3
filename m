Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3BUNdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 08:33:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38869 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3BUNdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 08:33:14 -0500
Message-ID: <1361453587.26780.18.camel@laptop>
Subject: Re: [patch v5 09/15] sched: add power aware scheduling in
 fork/exec/wake
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Date: Thu, 21 Feb 2013 14:33:07 +0100
In-Reply-To: <5124DC76.2010801@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
	   <1361164062-20111-10-git-send-email-alex.shi@intel.com>
	  <1361353360.10155.9.camel@laptop> <5124BCEB.8030606@intel.com>
	 <1361367371.10155.32.camel@laptop> <5124DC76.2010801@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 22:23 +0800, Alex Shi wrote:
> > But but but,... nr_running is completely unrelated to utilization.
> > 
> 
> Actually, I also hesitated on the name, how about using nr_running to
> replace group_util directly?


The name is a secondary issue, first you need to explain why you think
nr_running is a useful metric at all.

You can have a high nr_running and a low utilization (a burst of
wakeups, each waking a process that'll instantly go to sleep again), or
low nr_running and high utilization (a single process cpu bound
process).

There is absolutely no relation between utilization and nr_running,
building something on that assumption is just wrong and broken.



