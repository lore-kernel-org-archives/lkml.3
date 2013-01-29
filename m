Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3A2BgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:36:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:40404 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab3A2BgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:36:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,555,1355126400"; 
   d="scan'208";a="249467120"
Message-ID: <510727B2.703@intel.com>
Date: Tue, 29 Jan 2013 09:36:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Mike Galbraith <efault@gmx.de>,
        torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
References: <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com> <510493E4.8060602@intel.com> <1359261385.5803.46.camel@marge.simpson.net> <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com> <1359301903.5805.11.camel@marge.simpson.net> <1359350266.5783.39.camel@marge.simpson.net> <20130128095501.GB6109@pd.tnic> <1359369884.5783.117.camel@marge.simpson.net> <20130128112922.GA29384@pd.tnic>
In-Reply-To: <20130128112922.GA29384@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Benchmark       Version Machine Run Date
> AIM Multiuser Benchmark - Suite VII     "1.1"   performance     Jan 28 08:09:20 2013
> 
> Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
> 1       438.8           100     13.8    3.8     7.3135
> 5       2634.8          99      11.5    7.2     8.7826
> 10      5396.3          99      11.2    11.4    8.9938
> 20      10725.7         99      11.3    24.0    8.9381
> 40      20183.2         99      12.0    38.5    8.4097
> 80      35620.9         99      13.6    71.4    7.4210
> 160     57203.5         98      16.9    137.8   5.9587
> 320     81995.8         98      23.7    271.3   4.2706
> 
> then the above no_node-load_balance thing suffers a small-ish dip at 320
> tasks, yeah.
> 
> And AFAICR, the effect of disabling boosting will be visible in the
> small count tasks cases anyway because if you saturate the cores with
> tasks, the boosting algorithms tend to get the box out of boosting for
> the simple reason that the power/perf headroom simply disappears due to
> the SOC being busy.

Sure. and according to the context of serial email. guess this result
has boosting enabled, right?


> 
>> 640     100294.8        98      38.7    570.9   2.6118
>> 1280    115998.2        97      66.9    1132.8  1.5104
>> 2560    125820.0        97      123.3   2256.6  0.8191
> 
> I dunno about those. maybe this is expected with so many tasks or do we
> want to optimize that case further?
> 


-- 
Thanks Alex
