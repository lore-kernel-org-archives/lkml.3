Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab3CUHn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:43:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:14408 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab3CUHn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:43:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="282614932"
Message-ID: <514ABA19.1080807@intel.com>
Date: Thu, 21 Mar 2013 15:43:21 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 14/15] sched: power aware load balance
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-15-git-send-email-alex.shi@intel.com> <514941C5.6080007@linux.vnet.ibm.com>
In-Reply-To: <514941C5.6080007@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 12:57 PM, Preeti U Murthy wrote:
> Neither core will be able to pull the task from the other to consolidate
> the load because the rq->util of t2 and t4, on which no process is
> running, continue to show some number even though they degrade with time
> and sgs->utils accounts for them. Therefore,
> for core1 and core2, the sgs->utils will be slightly above 100 and the
> above condition will fail, thus failing them as candidates for
> group_leader,since threshold_util will be 200.

Thanks for note, Preeti!

Did you find some real issue in some platform?
In theory, a totally idle cpu has a zero rq->util at least after 3xxms,
and in fact, I find the code works fine on my machines.

-- 
Thanks
    Alex
