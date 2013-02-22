Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3BVJKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:10:54 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48293 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab3BVJKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:10:45 -0500
Message-ID: <51273609.9080308@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2013 17:10:33 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
References: <51079178.3070002@linux.vnet.ibm.com> <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com> <1361427108.5861.41.camel@marge.simpson.net> <5125C607.8090909@linux.vnet.ibm.com> <1361434231.5861.61.camel@marge.simpson.net> <5125E40D.6050006@linux.vnet.ibm.com> <1361439789.5861.70.camel@marge.simpson.net> <5126D9A2.8090404@linux.vnet.ibm.com> <1361521270.26780.34.camel@laptop>
In-Reply-To: <1361521270.26780.34.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022209-3568-0000-0000-000003321D09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 04:21 PM, Peter Zijlstra wrote:
> On Fri, 2013-02-22 at 10:36 +0800, Michael Wang wrote:
>> According to my understanding, in the old world, wake_affine() will
>> only
>> be used if curr_cpu and prev_cpu share cache, which means they are in
>> one package, whatever search in llc sd of curr_cpu or prev_cpu, we
>> won't
>> have the chance to spread the task out of that package.
> 
> Nah, look at where SD_WAKE_AFFINE is set. Only 'remote/big' NUMA domains
> don't have it set, but 'small' NUMA systems will have it set over the
> entire domain tree.

Oh, I missed that point...

But I don't get the reason to make NUMA level affine, cpus in different
nodes share cache? doesn't make sense...

Regards,
Michael Wang

> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

