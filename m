Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab3BLKQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:16:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60405 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab3BLKQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:16:51 -0500
Message-ID: <1360664208.4485.8.camel@laptop>
Subject: Re: [patch v4 03/18] sched: fix find_idlest_group mess logical
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 11:16:48 +0100
In-Reply-To: <1358996820-23036-4-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <1358996820-23036-4-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
> There is 4 situations in the function:
> 1, no task allowed group;
> 	so min_load = ULONG_MAX, this_load = 0, idlest = NULL
> 2, only local group task allowed;
> 	so min_load = ULONG_MAX, this_load assigned, idlest = NULL
> 3, only non-local task group allowed;
> 	so min_load assigned, this_load = 0, idlest != NULL
> 4, local group + another group are task allowed.
> 	so min_load assigned, this_load assigned, idlest != NULL
> 
> Current logical will return NULL in first 3 kinds of scenarios.
> And still return NULL, if idlest group is heavier then the
> local group in the 4th situation.
> 
> Actually, I thought groups in situation 2,3 are also eligible to host
> the task. And in 4th situation, agree to bias toward local group.

I'm not convinced this is actually a cleanup.. taken together with patch
4 (which is a direct consequence of this patch afaict) you replace one
conditional with 2.

