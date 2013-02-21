Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab3BUFVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 00:21:52 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:34189 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3BUFVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 00:21:51 -0500
Message-ID: <5125AEE6.5030706@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2013 13:21:42 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
References: <51079178.3070002@linux.vnet.ibm.com> <20130220104958.GA9152@gmail.com> <1361367148.10155.30.camel@laptop> <1361369119.5919.86.camel@marge.simpson.net>
In-Reply-To: <1361369119.5919.86.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022105-5816-0000-0000-000006C472D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 10:05 PM, Mike Galbraith wrote:
> On Wed, 2013-02-20 at 14:32 +0100, Peter Zijlstra wrote: 
>> On Wed, 2013-02-20 at 11:49 +0100, Ingo Molnar wrote:
>>
>>> The changes look clean and reasoable, 
>>
>> I don't necessarily agree, note that O(n^2) storage requirement that
>> Michael failed to highlight ;-)
> 
> (yeah, I mentioned that needs to shrink.. a lot)

Exactly, and I'm going to apply the suggestion now :)

> 
>>> any ideas exactly *why* it speeds up?
>>
>> That is indeed the most interesting part.. There's two parts to
>> select_task_rq_fair(), the 'regular' affine wakeup path, and the
>> fork/exec find_idlest_goo() path. At the very least we need to quantify
>> which of these two parts contributes most to the speedup.
>>
>> In the power balancing discussion we already noted that the
>> find_idlest_goo() is in need of attention.
> 
> Yup, even little stuff like break off the search when load is zero..

Agree, searching in a bunch of idle cpus and their subsets doesn't make
sense...

Regards,
Michael Wang

> unless someone is planning on implementing anti-idle 'course ;-)
> 
> -Mike
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

