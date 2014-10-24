Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbaJXKtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:49:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:43914 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889AbaJXKtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:49:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,779,1406617200"; 
   d="scan'208";a="595165934"
Message-ID: <544A2E5F.80508@intel.com>
Date: Fri, 24 Oct 2014 13:47:59 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/16] perf tools: Add facility to export data in database-friendly
 way
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>	<1414061124-26830-6-git-send-email-adrian.hunter@intel.com> <87lho6c8ec.fsf@sejong.aot.lge.com> <544A099C.50104@intel.com>
In-Reply-To: <544A099C.50104@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/10/14 11:11, Adrian Hunter wrote:
> On 24/10/14 09:02, Namhyung Kim wrote:
>> On Thu, 23 Oct 2014 13:45:13 +0300, Adrian Hunter wrote:
>>> This patch introduces an abstraction for exporting sample
>>> data in a database-friendly way.  The abstraction does not
>>> implement the actual output.  A subsequent patch takes this
>>> facility into use for extending the script interface.
>>>
>>> The abstraction is needed because static data like symbols,
>>> dsos, comms etc need to be exported only once.  That means
>>> allocating them a unique identifier and recording it on each
>>> structure.  The member 'db_id' is used for that.  'db_id'
>>> is just a 64-bit sequence number.
>>
>> Can we do it somewhere in a script not in the core code?  I don't feel
>> comfortable to add those bits into the core code.  What if we export
> 
> Please explain what you mean by "comfortable".

Or rather: What about it is wrong for core code?

> 
>> meta events like task, mmap or some user events to the script optionally
>> and let it process the data?
> 
> Intel PT decoding can generate a lot of data.  Many millions of samples at
> least.
> 
> Each sample contains a lot of duplicated information like symbol names, dso
> names, comms, etc.  So it is not optimal to export that for every sample.
> Even then, each piece of supporting information must be looked up - was it
> the same as the last sample, no then look it up, was it found, no then add a
> record.  That is very very inefficient.
> 
> Exporting each piece of information once, instead of over and over again, is
> a reasonable thing to do.
> 
>>
>> Thanks,
>> Namhyung
>>
>>
>>>
>>> Exporting centres around the db_export__sample() function
>>> which exports the associated data structures if they have
>>> not yet been allocated a db_id.
>>
>>
> 
> 
> 

