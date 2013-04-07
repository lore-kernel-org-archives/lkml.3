Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab3DGHax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 03:30:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:41326 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab3DGHaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 03:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,423,1363158000"; 
   d="scan'208";a="313857536"
Message-ID: <5161208F.1040209@intel.com>
Date: Sun, 07 Apr 2013 15:30:23 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515BEC5F.60001@intel.com> <5160E355.6000701@linux.vnet.ibm.com>
In-Reply-To: <5160E355.6000701@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> According to these data, 90us == 90000 is the inflection point on my box
> for 22 MB 32 clients item, other test items show different float, so
> 80~90us is the conclusion.

Thanks a lot for the testing!
> 
> Now the concern is how to deal with this issue, the results may changed
> on different deployment, static value is not acceptable, so we need
> another new knob here?
> 
> I'm not sure whether you have take a look at the wake-affine throttle
> patch I sent weeks ago, it's purpose is throttle the wake-affine to not
> work too frequently.

Yes. In the patch your directly set the target cpu to this_cpu when no
wake_affine. Maybe this is the key points, not the wake_affine cost give
the improvement. Basically I agree with this. but if so, it is a bit
blind. but, but, The interesting point is the blind target cpu setting
has the best performance in our current testing. :)

> 
> And since the aim problem is caused by the imbalance which is the
> side-effect of frequently succeed wake-affine, may be the throttle patch
> could help to address that issue too, if it is, then we only need to add
> one new knob.

As to the aim7 problem, I need apologise to you all!
The aim7 regression exist with the patch v2 that base on 3.8 kernel, not
with this v3 version base on 3.9.

After the lock-stealing RW sem patch introduced in 3.9 kernel, the aim7
has recovered the cpu task imbalance, So on balanced 3.9 kernel, this v3
version won't bring extra imbalance on aim7. no clear regression on
aim7, no extra imbalance on aim7.

So, I referenced a old testing result without double confirming, tried
to resolve a disappeared problem. I am sorry and applogize to you all.

And this burst patch doesn't need on 3.9 kernel. Patch 1,2,4,5,6,7 are
enough and valid.

-- 
Thanks Alex
