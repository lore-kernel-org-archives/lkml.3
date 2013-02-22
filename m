Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab3BVFFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 00:05:33 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:55664 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3BVFFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 00:05:32 -0500
Message-ID: <5126FC92.9010606@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2013 13:05:22 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 1/3] sched: schedule balance map foundation
References: <51079178.3070002@linux.vnet.ibm.com> <510791B2.6090506@linux.vnet.ibm.com> <1361366720.10155.25.camel@laptop> <5125A966.6040601@linux.vnet.ibm.com> <1361446661.26780.15.camel@laptop> <5126DD98.7030202@linux.vnet.ibm.com> <5126E705.3040308@intel.com> <5126F1D4.5030308@linux.vnet.ibm.com> <5126F83E.9060206@intel.com>
In-Reply-To: <5126F83E.9060206@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022205-4790-0000-0000-000007075888
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 12:46 PM, Alex Shi wrote:
> On 02/22/2013 12:19 PM, Michael Wang wrote:
>>
>>>> Why not seek other way to change O(n^2) to O(n)?
>>>>
>>>> Access 2G memory is unbelievable performance cost.
>> Not access 2G memory, but (2G / 16K) memory, the sbm size is O(N).
>>
>> And please notice that on 16k cpus system, topology will be deep if NUMA
>> enabled (O(log N) as Peter said), and that's really a good stage for
>> this idea to perform on, we could save lot's of recursed 'for' cycles.
>>
> 
> CPU execute part is very very fast compare to the memory access, the
> 'for' cycles cost is most on the memory access for many domain/groups
> data, not instruction execution.
> 
> In a hot patch, several KB memory access will cause clear cpu cache
> pollution then make kernel slowly.

Hmm...that's a good catch.

Comparison between memory access and cpu execution, no doubt the latter
will win, you are right.

But that was same in the old world when access the struct sched_domain,
isn't it?

                for_each_domain(cpu, tmp) {
                        if (weight <= tmp->span_weight)
                                break;
                        if (tmp->flags & sd_flag)
                                sd = tmp;
                }

Both old and new may access data across nodes, but the old one will
access several times more, isn't it?

Regards,
Michael Wang

> 

