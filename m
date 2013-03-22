Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab3CVBbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:31:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:58414 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab3CVBbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:31:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,888,1355126400"; 
   d="scan'208";a="306691240"
Message-ID: <514BB452.2070906@intel.com>
Date: Fri, 22 Mar 2013 09:30:58 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 14/15] sched: power aware load balance
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-15-git-send-email-alex.shi@intel.com> <514941C5.6080007@linux.vnet.ibm.com> <514ABA19.1080807@intel.com> <514AC7B2.7030400@linux.vnet.ibm.com> <514AD26F.9010905@intel.com> <514AE07A.10100@linux.vnet.ibm.com>
In-Reply-To: <514AE07A.10100@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 06:27 PM, Preeti U Murthy wrote:
>> > did you close all of background system services?
>> > In theory the rq->avg.runnable_avg_sum should be zero if there is no
>> > task a bit long, otherwise there are some bugs in kernel.
> Could you explain why rq->avg.runnable_avg_sum should be zero? What if
> some kernel thread ran on this run queue and is now finished? Its
> utilisation would be say x.How would that ever drop to 0,even if nothing
> ran on it later?

the value get from decay_load():
 sa->runnable_avg_sum = decay_load(sa->runnable_avg_sum,
in decay_load it is possible to be set zero.

and /proc/sched_debug also approve this:

  .tg_runnable_contrib           : 0
  .tg->runnable_avg              : 50
  .avg->runnable_avg_sum         : 0
  .avg->runnable_avg_period      : 47507


-- 
Thanks Alex
