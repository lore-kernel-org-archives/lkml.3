Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3F0H47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:56:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:11514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab3F0H46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:56:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="336254117"
Message-ID: <51CBF193.60004@intel.com>
Date: Thu, 27 Jun 2013 11:02:27 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 12/15] perf tools: allow non-matching sample types
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-13-git-send-email-adrian.hunter@intel.com> <51C9BDB2.7060905@gmail.com>
In-Reply-To: <51C9BDB2.7060905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/13 18:56, David Ahern wrote:
> On 6/24/13 7:16 AM, Adrian Hunter wrote:
>> Sample types need not be identical to determine
>> the sample id from the event.  Only the position
>> of the sample id needs to be the same.
>>
>> Compatible sample types are ones in which the bits
>> defined by PERF_COMPAT_MASK are the same.
>> 'perf_evlist__config()' forces sample types to be
>> compatible on that basis.
> 
> Something is still missing to support different sample_types for events.
> Consider the case (S/W event + tracepoint):
>   perf record -e cs -c1 -e sched:sched_switch -a -- sleep 1
>   perf script
> 
> This patch addresses the sample_type mismatch error message, but I get no
> event samples in the output. Besides the usual header I get:
> 
>   No trace sample to read. Did you call 'perf record -R'?

Fixed in V2

> 
> It's a 16-cpu box with 5 VMs running. I know there should be at least a few
> samples in 1 second.
> 
> Stephane: are you looking at allowing sample_types per event?
> 
> David
> 
> 

