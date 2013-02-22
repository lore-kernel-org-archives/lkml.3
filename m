Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab3BVIfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:35:47 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49230 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3BVIfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:35:46 -0500
Message-ID: <51272DD8.2080209@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2013 16:35:36 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
References: <51079178.3070002@linux.vnet.ibm.com> <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com> <1361427108.5861.41.camel@marge.simpson.net> <5125C607.8090909@linux.vnet.ibm.com> <1361434231.5861.61.camel@marge.simpson.net> <5125E40D.6050006@linux.vnet.ibm.com> <1361439789.5861.70.camel@marge.simpson.net> <5126D9A2.8090404@linux.vnet.ibm.com> <1361509372.5817.60.camel@marge.simpson.net> <5127135E.7030502@linux.vnet.ibm.com> <1361521033.5817.95.camel@marge.simpson.net>
In-Reply-To: <1361521033.5817.95.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022208-4790-0000-0000-000007080D0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 04:17 PM, Mike Galbraith wrote:
> On Fri, 2013-02-22 at 14:42 +0800, Michael Wang wrote:
> 
>> So this is trying to take care the condition when curr_cpu(local) and
>> prev_cpu(remote) are on different nodes, which in the old world,
>> wake_affine() won't be invoked, correct?
> 
> It'll be called any time this_cpu and prev_cpu aren't one and the same.
> It'd be pretty silly to asking whether to pull_here or leave_there when
> here and there are identical.

Agree :)

> 
>> Hmm...I think this maybe a good additional checking before enter balance
>> path, but I could not estimate the cost to record the relationship at
>> this moment of time...
> 
> It'd be pretty cheap, but I'd hate adding any cycles to the fast path
> unless those cycles have one hell of a good payoff, so the caching would
> have to show most excellent cold hard numbers (talk crazy ideas walk;).

It sounds like a good idea, I'm not sure whether it's cheap and how many
benefit we could gain, but it worth some research.

I will thinking more about it after finished the sbm work.

Regards,
Michael Wang

> 
> -Mike
> 

