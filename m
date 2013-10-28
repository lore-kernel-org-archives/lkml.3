Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3J1IGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:06:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60802 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3J1IGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:06:46 -0400
X-AuditID: 9c930179-b7c9bae000000e4c-dc-526e1b15ce8e
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 2/4] perf tools: Split -G and --call-graph for top command
References: <20131026120336.GA24439@gmail.com>
	<1382797536-32303-1-git-send-email-jolsa@redhat.com>
	<1382797536-32303-3-git-send-email-jolsa@redhat.com>
	<526D3294.4000402@gmail.com>
Date: Mon, 28 Oct 2013 17:06:44 +0900
In-Reply-To: <526D3294.4000402@gmail.com> (David Ahern's message of "Sun, 27
	Oct 2013 09:34:44 -0600")
Message-ID: <87fvrl95uz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Oct 2013 09:34:44 -0600, David Ahern wrote:
> On 10/26/13 8:25 AM, Jiri Olsa wrote:
>> diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
>> index c16a09e..d311974 100644
>> --- a/tools/perf/Documentation/perf-top.txt
>> +++ b/tools/perf/Documentation/perf-top.txt
>> @@ -143,20 +143,12 @@ Default is to monitor all CPUS.
>>   --asm-raw::
>>   	Show raw instruction encoding of assembly instructions.
>>
>> --G [type,min,order]::
>> +-G::
>> +	Enables call-graph (stack chain/backtrace) recording.
>> +
>>   --call-graph::
>> -        Display call chains using type, min percent threshold and order.
>> -	type can be either:
>> -	- flat: single column, linear exposure of call chains.
>> -	- graph: use a graph tree, displaying absolute overhead rates.
>> -	- fractal: like graph, but displays relative rates. Each branch of
>> -		 the tree is considered as a new profiled object.
>> -
>> -	order can be either:
>> -	- callee: callee based call graph.
>> -	- caller: inverted caller based call graph.
>> -
>> -	Default: fractal,0.5,callee.
>> +	Setup and enable call-graph (stack chain/backtrace) recording,
>> +	implies -g.
>
> implies '-G' for perf-top. Given that perf-top is recording and
> analyzing events shouldn't the analysis options (caller/callee and
> callgraph type) be kept here?

Yes it should, but it seems it only lived in the documentation - the -G
option was already for fp or dwarf and no analyzing options.  Maybe we
might add --call-graph-style or something.

>
> Really should have callchains be consistent across perf-commands as -g.

Agreed.  As -g/--group option in perf top is rarely used, we maybe
disable -g option for a while and then add it as a shortcut to
--call-graph later.

Thanks,
Namhyung
