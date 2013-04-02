Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761763Ab3DBNiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:38:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:10960 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760446Ab3DBNiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:38:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,393,1363158000"; 
   d="scan'208";a="312367494"
Message-ID: <515ADF41.8070207@intel.com>
Date: Tue, 02 Apr 2013 21:38:09 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
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


>> +	nr_running = rq->nr_running ? rq->nr_running : 1;
> 
> This can be cleaned up with proper min/max().

yes, thanks
> 
>> +
>> +	return rt_util + cfs_util * nr_running;
> 
> Should this nr_running consider tasks in cfs_rq only?  Also it seems
> there's no upper bound so that it can possibly exceed FULL_UTIL.

Yes.
we need to consider task number:nr_running, otherwise cpu utilization
will never beyond FULL_UTIL, then we can not know if the cpu is overload.
So we need the possible maximum utilization bigger than FULL_UTIL.
> 


-- 
Thanks
    Alex
