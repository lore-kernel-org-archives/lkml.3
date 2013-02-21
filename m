Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab3BUFOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 00:14:49 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53520 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3BUFOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 00:14:48 -0500
Message-ID: <5125AD3D.40400@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2013 13:14:37 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
References: <51079178.3070002@linux.vnet.ibm.com> <20130220104958.GA9152@gmail.com> <1361367148.10155.30.camel@laptop>
In-Reply-To: <1361367148.10155.30.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022105-9264-0000-0000-000003314A83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 09:32 PM, Peter Zijlstra wrote:
> On Wed, 2013-02-20 at 11:49 +0100, Ingo Molnar wrote:
> 
>> The changes look clean and reasoable, 
> 
> I don't necessarily agree, note that O(n^2) storage requirement that
> Michael failed to highlight ;-)

Forgive me for not explain this point in cover, but it's really not a
big deal in my opinion...

And I'm going to apply Mike's suggestion, do allocation when cpu active,
that will save some space :)

Regards,
Michael Wang

> 
>> any ideas exactly *why* it speeds up?
> 
> That is indeed the most interesting part.. There's two parts to
> select_task_rq_fair(), the 'regular' affine wakeup path, and the
> fork/exec find_idlest_goo() path. At the very least we need to quantify
> which of these two parts contributes most to the speedup.
> 
> In the power balancing discussion we already noted that the
> find_idlest_goo() is in need of attention.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

