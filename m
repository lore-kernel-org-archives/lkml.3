Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272Ab3CHChg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:37:36 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:53343 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760229Ab3CHChf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:37:35 -0500
Message-ID: <51394EE3.1020706@linux.vnet.ibm.com>
Date: Fri, 08 Mar 2013 10:37:23 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362645372.2606.11.camel@laptop> <1362649419.4652.12.camel@marge.simpson.net>
In-Reply-To: <1362649419.4652.12.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030802-2000-0000-0000-00000B390CF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 05:43 PM, Mike Galbraith wrote:
> On Thu, 2013-03-07 at 09:36 +0100, Peter Zijlstra wrote: 
>> On Wed, 2013-03-06 at 15:06 +0800, Michael Wang wrote:
>>
>>> wake_affine() stuff is trying to bind related tasks closely, but it doesn't
>>> work well according to the test on 'perf bench sched pipe' (thanks to Peter).
>>
>> so sched-pipe is a poor benchmark for this.. 
>>
>> Ideally we'd write a new benchmark that has some actual data footprint
>> and we'd measure the cost of tasks being apart on the various cache
>> metrics and see what affine wakeup does for it.
>>
>> Before doing something like what you're proposing, I'd have a hard look
>> at WF_SYNC, it is possible we should disable/fix select_idle_sibling
>> for sync wakeups.
> 
> If nobody beats me to it, I'm going to try tracking shortest round trip
> to idle, and use a multiple of that to shut select_idle_sibling() down.
> If avg_idle approaches round trip time, there's no win to be had, we're
> just wasting cycles.

That's great if we have it, I'm a little doubt whether it is possible to
find a better way to replace the select_idle_sibling() (look at the way
it locates idle cpu...) in some cases, but I'm looking forward it ;-)

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

