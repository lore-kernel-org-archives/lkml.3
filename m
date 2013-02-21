Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3BUBfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 20:35:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:10122 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab3BUBf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 20:35:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,705,1355126400"; 
   d="scan'208";a="204692300"
Message-ID: <512579F6.4080800@intel.com>
Date: Thu, 21 Feb 2013 09:35:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 06/15] sched: log the cpu utilization at rq
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>   <1361164062-20111-7-git-send-email-alex.shi@intel.com>  <1361352643.10155.4.camel@laptop> <5124DED5.5050207@intel.com> <1361373631.10155.40.camel@laptop>
In-Reply-To: <1361373631.10155.40.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 11:20 PM, Peter Zijlstra wrote:
> On Wed, 2013-02-20 at 22:33 +0800, Alex Shi wrote:
>>> There's generally a better value than 100 when using computers..
>> seeing
>>> how 100 is 64+32+4.
>>
>> I didn't find a good example for this. and no idea of your suggestion,
>> would you like to explain a bit more?
> 
> Basically what you're doing ends up being fixed point math, using 100 as
> unit is inefficient, pick a power-of-2 and everything reduces to
> bit-shifts.
> 
> http://en.wikipedia.org/wiki/Fixed-point_arithmetic
> 
> So use 128 or 1024 or whatever and you don't need mult and div
> instructions to represent [0,1]
> 

got it. will reconsider this.

-- 
Thanks Alex
