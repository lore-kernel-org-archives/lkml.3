Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3JUOvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:51:40 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:2226 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3JUOvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:51:39 -0400
Message-ID: <52653F6E.2030306@hp.com>
Date: Mon, 21 Oct 2013 10:51:26 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2 3/4] perf-report: add --max-stack option to limit callchain
 stack scan
References: <1382107129-2010-1-git-send-email-Waiman.Long@hp.com> <1382107129-2010-4-git-send-email-Waiman.Long@hp.com> <20131018171726.GD12054@ghostprotocols.net>
In-Reply-To: <20131018171726.GD12054@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 01:17 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Oct 18, 2013 at 10:38:48AM -0400, Waiman Long escreveu:
>> When callgraph data was included in the perf data file, it may take a
>> long time to scan all those data and merge them together especially
>> if the stored callchains are long and the perf data file itself is
>> large, like a Gbyte or so.
>>
>> The callchain stack is currently limited to PERF_MAX_STACK_DEPTH (127).
>> This is a large value. Usually the callgraph data that developers are
>> most interested in are the first few levels, the rests are usually
>> not looked at.
>>
>> This patch adds a new --max-stack option to perf-report to limit the
>> depth of callchain stack data to look at to reduce the time it takes
>> for perf-report to finish its processing. It trades the presence of
>> trailing stack information with faster speed.
>>
>> The following table shows the elapsed time of doing perf-report on a
>> perf.data file of size 985,531,828 bytes.
>>
>> --max_stack	Elapsed Time	Output data size
>> -----------	------------	----------------
> Please prefix lines like this (------) with a space, otherwise 'git am'
> will chop off everything from that line onwards. Fixing it up now.
>
> - Arnaldo
>
>

Thank for spotting the problem, will fix that in the next version.

-Longman
