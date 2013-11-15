Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab3KOLUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:20:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:22701 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab3KOLUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:20:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="435748402"
Message-ID: <52860529.50200@intel.com>
Date: Fri, 15 Nov 2013 13:27:37 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 10/10] perf record: Add an option to force per-cpu mmaps
References: <1384460715-23198-1-git-send-email-acme@infradead.org> <1384460715-23198-11-git-send-email-acme@infradead.org> <20131115060643.GA9237@gmail.com> <5285FECE.7020802@intel.com> <20131115111032.GA18647@gmail.com>
In-Reply-To: <20131115111032.GA18647@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/11/13 13:10, Ingo Molnar wrote:
> 
> * Adrian Hunter <adrian.hunter@intel.com> wrote:
> 
>>> And I also raised why this shouldn't be the default event tracing 
>>> method instead of a weird config option. Per-cpu tracing is cache 
>>> compact, it is easier to size properly and in general it is pretty 
>>> easy to think about. (It also has less of the TSC timestamp 
>>> ordering problems as per thread tracing, at least in theory.)
>>>
>>> Is there something that makes per cpu tracing undesirable as the 
>>> default?
>>
>> One reason is to avoid changing the meaning of existing options.
> 
> Well, the way the tracing buffers are set up is a mostly tool internal 
> matter so in that sense it should be just fine to change the default 
> behavior - as long as output remains unchanged (which it should).
> 
> Or is there any material change in behavior somewhere?

Inheritance is enabled automatically with per-cpu mmaps,
although that is one of the reasons people want
per-cpu mmaps.

> 
>> To flip it around, ignore the patches above and apply:
> 
>> Subject: [PATCH] perf record: Make per-cpu mmaps the default.
> 
> Yay!
> 
>> +--per-thread::
>> +Use per-thread mmaps.  By default per-cpu mmaps are created.  This option
>> +overrides that and uses per-thread mmaps.  A side-effect of that is that
>> +inheritance is automatically disabled.  --per-thread is ignored with a warning
>> +if combined with -a or -C options.
> 
> I think this is the natural thing to do, --per-thread is the 'somewhat 
> weird' option that cannot be used in all modes.
> 
> Acked-by: Ingo Molnar <mingo@kernel.org>
> 
> :-)
> 
> Thanks,
> 
> 	Ingo
> 
> 

