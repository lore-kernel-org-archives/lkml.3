Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab3BYC0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:26:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:61042 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759485Ab3BYC0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:26:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,730,1355126400"; 
   d="scan'208";a="260902157"
Message-ID: <512ACBD9.7050800@intel.com>
Date: Mon, 25 Feb 2013 10:26:33 +0800
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
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>   <1361164062-20111-7-git-send-email-alex.shi@intel.com>  <1361352643.10155.4.camel@laptop> <5124DED5.5050207@intel.com> <1361373740.10155.42.camel@laptop>
In-Reply-To: <1361373740.10155.42.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 11:22 PM, Peter Zijlstra wrote:
> On Wed, 2013-02-20 at 22:33 +0800, Alex Shi wrote:
>>> You don't actually compute the rq utilization, you only compute the
>>> utilization as per the fair class, so if there's significant RT
>> activity
>>> it'll think the cpu is under-utilized, whihc I think will result in
>> the
>>> wrong thing.
>>
>> yes. A bit complicit to resolve this. Any suggestions on this, guys?
> 
> Shouldn't be too hard seeing as we already track cpu utilization for !
> fair usage; see rq::rt_avg and scale_rt_power.
> 

added them in periodic balancing, thanks!

-- 
Thanks Alex
