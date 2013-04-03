Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616Ab3DCCPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:15:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:34199 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758033Ab3DCCPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:15:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,397,1363158000"; 
   d="scan'208";a="288525211"
Message-ID: <515B90A5.7080403@intel.com>
Date: Wed, 03 Apr 2013 10:15:01 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v6 10/21] sched: get rq potential maximum utilization
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com> <1364654108-16307-11-git-send-email-alex.shi@intel.com> <87a9phfgox.fsf@sejong.aot.lge.com>
In-Reply-To: <87a9phfgox.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 05:02 PM, Namhyung Kim wrote:
>> > +	cfs_util = (FULL_UTIL - rt_util) > rq->util ? rq->util
>> > +			: (FULL_UTIL - rt_util);
>> > +	nr_running = rq->nr_running ? rq->nr_running : 1;
> This can be cleaned up with proper min/max().
> 
>> > +
>> > +	return rt_util + cfs_util * nr_running;
> Should this nr_running consider tasks in cfs_rq only?

use nr_running of cfs_rq seems better, but when use sched autogroup,
only cfs->nr_running just the active group number, not the total active
task number. :(

  Also it seems
> there's no upper bound so that it can possibly exceed FULL_UTIL.


-- 
Thanks Alex
