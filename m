Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab3JROvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:51:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:39448 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab3JROvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:51:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,523,1378882800"; 
   d="scan'208";a="419002994"
Message-ID: <52614AB7.3020900@intel.com>
Date: Fri, 18 Oct 2013 17:50:31 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 19/19] perf tools: allow non-matching sample types
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com> <1382099356-4918-20-git-send-email-adrian.hunter@intel.com> <526144C9.4080004@gmail.com>
In-Reply-To: <526144C9.4080004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/10/13 17:25, David Ahern wrote:
> On 10/18/13 6:29 AM, Adrian Hunter wrote:
>> For kernels that do not support PERF_SAMPLE_IDENTIFIER,
>> sample types need not be identical to determine
>> the sample id from the event.  Only the position
>> of the sample id needs to be the same.
>>
>> Compatible sample types are ones in which the bits
>> defined by PERF_COMPAT_MASK are the same.
>> 'perf_evlist__config()' forces sample types to be
>> compatible on that basis.
> 
> Arnaldo and I have discussed adding callchain handling to perf-trace. To do
> that we only need stack data (including IP) for one event -- eg,
> raw_syscalls:sys_enter. That means raw_syscalls:sys_enter and
> raw_syscalls:sys_exit will have different attributes set - including ones in
> the MASK.

So how do you know which sample is which?

