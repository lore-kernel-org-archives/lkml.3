Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaJXB5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 21:57:36 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:45258 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbaJXB5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 21:57:33 -0400
Message-ID: <5449B1D5.8010700@huawei.com>
Date: Fri, 24 Oct 2014 09:56:37 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Namhyung Kim <namhyung@kernel.org>, <a.p.zijlstra@chello.nl>,
        <paulus@samba.org>, <mingo@redhat.com>, <jolsa@redhat.com>,
        <adrian.hunter@intel.com>, <Waiman.Long@hp.com>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>
Subject: Re: [PATCH v2 RESEND] perf tools: makes CPUINFO_PROC to array for
 different kernel version
References: <1413963614-7251-1-git-send-email-wangnan0@huawei.com> <87k33qe5be.fsf@sejong.aot.lge.com> <20141023235302.GU14687@kernel.org>
In-Reply-To: <20141023235302.GU14687@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.5449B207.017A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 83aecc5f7a974db2aaa795196eb876ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

A have posted a v3 patch based on your git repository. Please refer to:

https://lkml.org/lkml/2014/10/23/711 .

Thanks.


On 2014/10/24 7:53, Arnaldo Carvalho de Melo wrote:
> Em Fri, Oct 24, 2014 at 08:26:13AM +0900, Namhyung Kim escreveu:
>> On Wed, 22 Oct 2014 15:40:14 +0800, Wang Nan wrote:
>>> After kernel 3.7 (commit b4b8f770eb10a1bccaf8aa0ec1956e2dd7ed1e0a),
>>> /proc/cpuinfo replaces 'Processor' to 'model name'. This patch makes
>>> CPUINFO_PROC to an array and provides two choices for ARM, makes it
>>> compatible for different kernel version.
> 
>>> v1 -> v2: minor changes as suggested by Namhyung Kim:
> 
>>>  - Doesn't pass @h and @evlist to __write_cpudesc;
>>>  - Coding style fix.
> 
>>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>  
>> Acked-by: Namhyung Kim <namhyung@kernel.org>
> 
> So now this will work with older kernels and new ones? Cool, thanks for
> working on it, but:
> 
> [acme@ssdandy linux]$ patch -p1 < /wb/1.patch 
> patching file tools/perf/perf.h
> Hunk #1 FAILED at 6.
> Hunk #2 FAILED at 15.
> Hunk #3 FAILED at 25.
> Hunk #4 FAILED at 40.
> Hunk #5 FAILED at 74.
> Hunk #6 FAILED at 91.
> 6 out of 6 hunks FAILED -- saving rejects to file tools/perf/perf.h.rej
> patching file tools/perf/util/header.c
> Hunk #1 succeeded at 579 (offset 29 lines).
> Hunk #2 succeeded at 636 (offset 29 lines).
> [acme@ssdandy linux]$
> 
> [acme@ssdandy linux]$ git log --oneline tools/perf/perf.h | head -10
> 87c43ee perf tools: Export usage string and option table of perf record
> 72a128a perf tools: Move callchain config from record_opts to callchain_param
> 73a31b7 perf tools: Move ACCESS_ONCE from perf.h header
> 82baa0e perf tools: Move sys_perf_event_open function from perf.h
> 43599d1 perf tools: Move syscall and arch specific defines from perf.h
> 2c83bc0 perf tools: Move perf_call_graph_mode enum from perf.h
> 0776eb5 perf tools: Move sample data structures from perf.h
> 36446f4 perf tools: Remove PR_TASK_PERF_EVENTS_* from perf.h
> 273a0a7 perf tools: Remove asmlinkage define from perf.h
> 1b7ae1c perf tools: Remove min define from perf.h
> [acme@ssdandy linux]$
> 
> This is:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git perf/core
> 
> If you don't have time to fix this up, I'll try to find time tomorrow
> and do it.
> 
> - Arnaldo
> 




