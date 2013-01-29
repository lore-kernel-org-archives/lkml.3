Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3A2BQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:16:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:1064 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151Ab3A2BQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:16:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,555,1355126400"; 
   d="scan'208";a="253871454"
Message-ID: <51072327.2000807@intel.com>
Date: Tue, 29 Jan 2013 09:17:27 +0800
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
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>  <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com>  <510493E4.8060602@intel.com> <1359261385.5803.46.camel@marge.simpson.net>  <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com>  <1359301903.5805.11.camel@marge.simpson.net>  <1359350266.5783.39.camel@marge.simpson.net> <510611D2.1020007@intel.com>  <1359353720.5783.51.camel@marge.simpson.net> <1359355337.5783.56.camel@marge.simpson.net>
In-Reply-To: <1359355337.5783.56.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 02:42 PM, Mike Galbraith wrote:
> Back to original 1ms sleep, 8ms work, turning NUMA box into a single
> node 10 core box with numactl.
> 
> monteverdi:/abuild/mike/:[0]# echo powersaving > /sys/devices/system/cpu/sched_policy/current_sched_policy
> monteverdi:/abuild/mike/:[0]# numactl --cpunodebind=0 massive_intr 10 60
> 045286  00043872
> 045289  00043464
> 045284  00043488
> 045287  00043440
> 045283  00043416
> 045281  00044456
> 045285  00043456
> 045288  00044312
> 045280  00043048
> 045282  00043240

Um, no idea why the powersaving data is so low.
> monteverdi:/abuild/mike/:[0]# echo balance > /sys/devices/system/cpu/sched_policy/current_sched_policy
> monteverdi:/abuild/mike/:[0]# numactl --cpunodebind=0 massive_intr 10 60
> 045300  00052536
> 045307  00052472
> 045304  00052536
> 045299  00052536
> 045305  00052520
> 045306  00052528
> 045302  00052528
> 045303  00052528
> 045308  00052512
> 045301  00052520
> monteverdi:/abuild/mike/:[0]# echo performance > /sys/devices/system/cpu/sched_policy/current_sched_policy
> monteverdi:/abuild/mike/:[0]# numactl --cpunodebind=0 massive_intr 10 60
> 045339  00052600
> 045340  00052608
> 045338  00052600
> 045337  00052608
> 045343  00052600
> 045341  00052600
> 045336  00052608
> 045335  00052616
> 045334  00052576


-- 
Thanks Alex
