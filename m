Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaE1JJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:09:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:55112 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbaE1JJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:09:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,926,1392192000"; 
   d="scan'208";a="518924345"
Message-ID: <5385A7A9.80702@intel.com>
Date: Wed, 28 May 2014 12:08:57 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: Differentiate exec() and non-exec() comm events
References: <1401266704-22572-1-git-send-email-adrian.hunter@intel.com> <20140528085538.GR11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140528085538.GR11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 11:55 AM, Peter Zijlstra wrote:
> On Wed, May 28, 2014 at 11:45:04AM +0300, Adrian Hunter wrote:
>> perf tools like 'perf report' can aggregate samples by comm
>> strings, which generally works.  However, there are other
>> potential use-cases.  For example, to pair up 'calls'
>> with 'returns' accurately (from branch events like Intel BTS)
>> it is necessary to identify whether the process has exec'd.
>> Although a comm event is generated when an 'exec' happens
>> it is also generated whenever the comm string is changed
>> on a whim (e.g. by prctl PR_SET_NAME).  This patch adds a
>> flag to the comm event to differentiate one case from the
>> other.
>>
>> In order to determine whether the kernel supports the new
>> flag, a selection bit named 'exec' is added to struct
>> perf_event_attr.  The bit does nothing but will cause
>> perf_event_open() to fail if the bit is set on kernels
>> that do not have it defined.
>>
> 
>> --- a/include/uapi/linux/perf_event.h
>> +++ b/include/uapi/linux/perf_event.h
>> @@ -302,8 +302,8 @@ struct perf_event_attr {
>>  				exclude_callchain_kernel : 1, /* exclude kernel callchains */
>>  				exclude_callchain_user   : 1, /* exclude user callchains */
>>  				mmap2          :  1, /* include mmap with inode data     */
>> -
>> -				__reserved_1   : 40;
>> +				exec           :  1, /* flag comm events that are due to an exec */
>> +				__reserved_1   : 39;
>>  
> 
> Yah.. that's just sad :-(
> 
> the only capabilities mask we have is in the mmap() page, so without
> mmap()ing we have no way to test that.
> 
> Would it make sense to call it comm_exec?

Yes, that is better.  Do you want me to resend the patch?

