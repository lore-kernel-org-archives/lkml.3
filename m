Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965295AbaCSO2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:28:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:22557 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964832AbaCSO2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:28:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,686,1389772800"; 
   d="scan'208";a="495122307"
Message-ID: <5329A94D.9060701@intel.com>
Date: Wed, 19 Mar 2014 16:27:25 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Don Zickus <dzickus@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 06/13] perf tools: Use tid in mmap/mmap2 events to find
 maps
References: <1395177965-8879-1-git-send-email-acme@infradead.org> <1395177965-8879-7-git-send-email-acme@infradead.org> <532943A2.7040407@intel.com> <20140319131945.GW25953@redhat.com> <20140319133025.GF1449@krava.brq.redhat.com>
In-Reply-To: <20140319133025.GF1449@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.03.2014 15:30, Jiri Olsa wrote:
> On Wed, Mar 19, 2014 at 09:19:45AM -0400, Don Zickus wrote:
>> On Wed, Mar 19, 2014 at 09:13:38AM +0200, Adrian Hunter wrote:
>>> On 18.03.2014 23:25, Arnaldo Carvalho de Melo wrote:
>>>> From: Don Zickus <dzickus@redhat.com>
>>>>
>>>> Now that we can properly synthesize threads system-wide, make sure the
>>>> mmap and mmap2 events use tids instead of pids to locate their maps.
>>>
>>> This is a good change but it cannot go yet because it is dependent on Jiri's
>>> "perf tools: Share map groups within process" series.
>>
>> No it isn't. :-) Commit bfd66cc71a3f831ba7c2116d79416cfb8883f6cf is the
>> reason why.  It synthesizes thread events to make this work correctly.
> 
> ok, I haven't realized this one was pulled in as well ;-)
> it's ok then..

No, you mustn't split up the maps between threads.  We currently assume
CLONE_VM is always used to create threads.

> 
> Arnaldo, I'll rebase the perf/core_mmaps (shared map groups) to your
> latest perf/core
> 
> jirka
> 
> 

