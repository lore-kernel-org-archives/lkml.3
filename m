Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab3A2BcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:32:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:34794 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab3A2BcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:32:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,555,1355126400"; 
   d="scan'208";a="277739064"
Message-ID: <510726C0.6040909@intel.com>
Date: Tue, 29 Jan 2013 09:32:48 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
References: <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com>  <510493E4.8060602@intel.com> <1359261385.5803.46.camel@marge.simpson.net>  <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com>  <1359301903.5805.11.camel@marge.simpson.net>  <1359350266.5783.39.camel@marge.simpson.net>  <20130128095501.GB6109@pd.tnic>  <1359369884.5783.117.camel@marge.simpson.net>  <20130128112922.GA29384@pd.tnic> <1359372743.5783.136.camel@marge.simpson.net>
In-Reply-To: <1359372743.5783.136.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> then the above no_node-load_balance thing suffers a small-ish dip at 320
>> tasks, yeah.
> 
> No no, that's not restricted to one node.  It's just overloaded because
> I turned balancing off at the NODE domain level.
> 
>> And AFAICR, the effect of disabling boosting will be visible in the
>> small count tasks cases anyway because if you saturate the cores with
>> tasks, the boosting algorithms tend to get the box out of boosting for
>> the simple reason that the power/perf headroom simply disappears due to
>> the SOC being busy.
>>
>>> 640     100294.8        98      38.7    570.9   2.6118
>>> 1280    115998.2        97      66.9    1132.8  1.5104
>>> 2560    125820.0        97      123.3   2256.6  0.8191
>>
>> I dunno about those. maybe this is expected with so many tasks or do we
>> want to optimize that case further?
> 
> When using all 4 nodes properly, that's still scaling.  Here, I

Without node regular balancing, only waking balance left in
select_task_rq_fair for aim7 testing, (I just assume you used shared
workfile, most of testing is cpu density and only few exec/fork load).

Since, waking balance just happened in same llc domain. guess that is
the reason for this.

> intentionally screwed up balancing to watch the low end.  High end is
> expected wreckage.


