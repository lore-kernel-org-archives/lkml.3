Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3HCNry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 09:47:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:24238 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab3HCNrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 09:47:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,807,1367996400"; 
   d="scan'208";a="277215603"
Message-ID: <51FD0A04.4050209@intel.com>
Date: Sat, 03 Aug 2013 16:47:48 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/9] perf tools: add test for reading object code
References: <1374760890-30558-1-git-send-email-adrian.hunter@intel.com> <1374760890-30558-2-git-send-email-adrian.hunter@intel.com> <874nbd3mob.fsf@sejong.aot.lge.com> <51F82BF1.7060401@intel.com> <20130731174355.GI3614@ghostprotocols.net>
In-Reply-To: <20130731174355.GI3614@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/2013 8:43 p.m., Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 31, 2013 at 12:11:13AM +0300, Adrian Hunter escreveu:
>> On 29/07/2013 9:28 a.m., Namhyung Kim wrote:
>>>> +
>>>> +static int do_test_code_reading(void)
>>>> +{
>>>> +	struct machines machines;
>>>> +	struct machine *machine;
>>>> +	struct thread *thread;
>>>> +	struct perf_record_opts opts = {
>>>> +		.mmap_pages	     = UINT_MAX,
>>>> +		.user_freq	     = UINT_MAX,
>>>> +		.user_interval	     = ULLONG_MAX,
>>>> +		.freq		     = 40000,
>>>
>>> Is it intended to use the freq of 40000 instead of 4000 (default)?
>>
>> Yes.  The "workload" is small so a higher sampling rate is preferable.
>
> But preferably one that is less than:
>
> [root@zoo ~]# cat /proc/sys/kernel/perf_event_max_sample_rate
> 25000
> [root@zoo ~]#
>
> That is the reason why this test is failing on this Ivy Bridge notebook:
>
> [root@zoo ~]# dmesg | grep perf_event_max_sample_rate
> [ 4068.969761] perf samples too long (2552>  2500), lowering kernel.perf_event_max_sample_rate to 50000
> [ 4069.842176] perf samples too long (5039>  5000), lowering kernel.perf_event_max_sample_rate to 25000
> [root@zoo ~]#
>
> Look at kernel/events/core.c.
>
> So keeping it at 4k may not be a bad idea, or at least have code that reads
> /proc/sys/kernel/perf_event_max_sample_rate if using the highest freq is
> desired.

I dropped it to 4k in V3.

