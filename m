Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3JVTMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:12:40 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:47106 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3JVTMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:12:39 -0400
Message-ID: <5266CE16.8080507@hp.com>
Date: Tue, 22 Oct 2013 15:12:22 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH v3 0/3] perf: add option to limit callchain stack scan
 to increase speed
References: <1382367819-19643-1-git-send-email-Waiman.Long@hp.com> <871u3dkwmu.fsf@danjae.aot.lge.com>
In-Reply-To: <871u3dkwmu.fsf@danjae.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 02:07 PM, Namhyung Kim wrote:
> Hi Waiman,
>
> On Mon, 21 Oct 2013 11:03:36 -0400, Waiman Long wrote:
>> v2->v3:
>>   - Fix the commit log in the second patch which causes "git am" to fail.
>>   - Remove the 1st patch in v2 as the problem will be fixed by another
>>     patch from Arnaldo.
>>
>> v1->v2:
>>   - Include a compilation fix patch and a code streamlining patch
>>     into the patch set.
>>   - Use the __stringify() macro in stringify.h instead of adding a
>>     duplicate macro.
>>   - Add the --max-stack option to perf-top as well.
>>
>> This perf patch set contains the following changes:
>>
>> Patch 1 - Streamline the append_chain() function to make it run a bit
>>            faster.
>> Patch 2 - Add a --max-stack option to perf-report to speed up its
>>            processing at the expense of less backtrace information
>>            available.
>> Patch 3 - Add a similar --max-stack option to perf-top.
> At first, thank you for tackling this.  It was really a problem using
> callchain on non trivial perf session.  But there's another effort to
> address this problem in other direction.  You might want to see below
> link [1].  Patch 1/8 does the thing and it seems Arnaldo already merged
> it into his tree.

Thank for letting me aware of your patch to address the perf-report 
problem. As I am working on resolving scalability problem in large NUMA 
machines, I often encounters large perf.data files that took more than 
1/2 hour for perf-report to produce anything. It is kind of frustrating 
to wait so long. I like the performance improvement in your patch 1/8, 
coupled with the max-stack option, it can really speed thing up.

-Longman
