Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab3GBFun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:50:43 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:54211 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3GBFum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:50:42 -0400
Message-ID: <51D26A27.6010101@linux.vnet.ibm.com>
Date: Tue, 02 Jul 2013 13:50:31 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: smart wake-affine
References: <51A43B16.9080801@linux.vnet.ibm.com> <51D25A80.8090406@linux.vnet.ibm.com> <1372743517.7363.129.camel@marge.simpson.net>
In-Reply-To: <1372743517.7363.129.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070205-3864-0000-0000-000008E4471D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 01:38 PM, Mike Galbraith wrote:
> On Tue, 2013-07-02 at 12:43 +0800, Michael Wang wrote:
> 
>> +static int nasty_pull(struct task_struct *p)
>> +{
>> +	int factor = cpumask_weight(cpu_online_mask);
>> +
>> +	/*
>> +	 * Yeah, it's the switching-frequency, could means many wakee or
>> +	 * rapidly switch, use factor here will just help to automatically
>> +	 * adjust the loose-degree, so more cpu will lead to more pull.
>> +	 */
>> +	if (p->nr_wakee_switch > factor) {
>> +		/*
>> +		 * wakee is somewhat hot, it needs certain amount of cpu
>> +		 * resource, so if waker is far more hot, prefer to leave
>> +		 * it alone.
>> +		 */
>> +		if (current->nr_wakee_switch > (factor * p->nr_wakee_switch))
>> +			return 1;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> Ew.  I haven't gotten around to test-driving this patchlet, and I see
> you haven't gotten around to finding a better name either.  Any other
> name will likely have a better chance of flying.

Trust me, I've tried to get a good name...and some cells in my brain do
sacrificed for it, bravely ;-)

> 
> tasks_related()
> ...
> well, nearly any..
> tasks_think_wake_affine_sucks_rocks()
> ..that won't fly either :)

Hmm...better than those in my mind (like dragon_wake_affine(), well...at
least dragon could fly).

Anyway, if the idea itself become acceptable, then any name is ok for
me, let's figure out a good one at that time :)

Regards,
Michael Wang


> 
> -Mike
> 

