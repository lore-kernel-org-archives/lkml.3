Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaDWMfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:35:20 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:33500 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbaDWMer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:34:47 -0400
Message-ID: <5357B35E.6020908@de.ibm.com>
Date: Wed, 23 Apr 2014 14:34:38 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/tool: Fix usage of trace events with '-' in trace
 system name.
References: <1395694140-43447-1-git-send-email-borntraeger@de.ibm.com> <53315741.9010508@redhat.com> <20140417113221.GA7422@krava.brq.redhat.com> <874n1mg021.wl%yarygin@linux.vnet.ibm.com> <20140423114529.GB11124@krava.brq.redhat.com>
In-Reply-To: <20140423114529.GB11124@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042312-8372-0000-0000-0000096FD638
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/04/14 13:45, Jiri Olsa wrote:
> On Mon, Apr 21, 2014 at 07:43:50PM +0400, Alexander Yarygin wrote:
[...]
>> And a bit of offtopic :)
>> Apparently, s390 doesn't have syscalls:*, so some of the tests
>> don't work properly (or maybe I missed something? I set CONFIG_FTRACE_SYSCALLS
>> to 'y' in my config: still no syscalls:*).

Strange, on my system I have syscall trace points on s390.
Maybe some additional dependency of CONFIG_FTRACE_SYSCALLS that is not catched
via Kconfig?

>>
>> What do you think about this idea:
>>
>> --- a/tools/perf/tests/parse-events.c
>> +++ b/tools/perf/tests/parse-events.c
>> @@ -1177,13 +1177,21 @@ struct evlist_test {
>>  	int (*check)(struct perf_evlist *evlist);
>>  };
>>
>> +#if !defined(__s390x__)
>> +#define TP_SYS_NAME "syscalls"
>> +#define TP_EVENT_NAME "sys_enter_open"
>> +#else
>> +#define TP_SYS_NAME "sched"
>> +#define TP_EVENT_NAME "sched_wakeup"
>> +#endif
>> +
>>  static struct evlist_test test__events[] = {
>>  	[0] = {
>> -		.name  = "syscalls:sys_enter_open",
>> +		.name  = TP_SYS_NAME ":" TP_EVENT_NAME,
>>  		.check = test__checkevent_tracepoint,
>>  	},
>>
>> ... and so on?
> 
> that looks fine.. also we could use just generic tracepoints
> like the 'sched' ones

I think generic tracepoints are preferred over ifdef, but as I said I have syscalls.

Christian

Christian




