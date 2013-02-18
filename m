Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab3BRHoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 02:44:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:15727 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab3BRHoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 02:44:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,684,1355126400"; 
   d="scan'208";a="203457469"
Message-ID: <5121DBC4.9070601@intel.com>
Date: Mon, 18 Feb 2013 15:44:04 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 0/15] power aware scheduling
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 01:07 PM, Alex Shi wrote:
> Since the simplification of fork/exec/wake balancing has much arguments,
> I removed that part in the patch set.
> 
> This patch set implement/consummate the rough power aware scheduling
> proposal: https://lkml.org/lkml/2012/8/13/139.

Just review the great summary of the conversation on this proposal.
http://lwn.net/Articles/512487/

One of advantage of this patch is that it bases on the general sched
domain/groups architecture, so, if other hardware platforms, like ARM,
has different hardware setting, it can be represented as specific domain
flags. and then be treated specific in scheduling. The scheduling is
natural and easy to expend to that.

And guess the big.LITTLE arch also can be represented by cpu power, if
so, the 'balance' policy just fit them since it judges if the sched
domain/group is full by domain/group's capacity.

Also adding a answer for policy automatic change feature:
---
The 'balance/powersaving' is automatic power friendly scheduling, since
system will auto bypass power scheduling when cpus utilisation in a
sched domain is beyond the domain's cpu weight (powersaving) or beyond
the domain's capacity (balance).

There is no always enabled power scheduling, since the patchset bases on
'race to idle'.


-- 
Thanks Alex
