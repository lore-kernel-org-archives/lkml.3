Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471Ab3BYS4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 13:56:43 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:57392 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab3BYS4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 13:56:42 -0500
Message-ID: <512BB3E6.6000904@gmail.com>
Date: Mon, 25 Feb 2013 11:56:38 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 1/5] perf tools: Fix -C option for record command
References: <1361785972-7431-1-git-send-email-jolsa@redhat.com> <1361785972-7431-2-git-send-email-jolsa@redhat.com> <20130225183932.GA7352@redhat.com>
In-Reply-To: <20130225183932.GA7352@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/13 11:39 AM, Oleg Nesterov wrote:
> To clarify, I am not trying to review this patch, I'd like to ask
> the question...
>
> On 02/25, Jiri Olsa wrote:
>>
>> Currently the -C option does not work for record command,
>> because of the targets mismatch when synthesizing threads.
>>
>> Fixing this by using proper target interface for the
>> synthesize decision.
>
> OK, but my fix had the different goal. I thought that
>
> 	$ perf ... record -C0 sleep 1
>
> should attach the counter to the child process (workload) and set
> event->cpu = 0 (instead of -1). With this patch we create the cpu

If a target is given (-a, -C, -p or -t) that is what the data is 
collected for -- all cpus, a cpu, or one or more task ids. The workload 
in that case becomes a means for bounding the data collection (start and 
end points).

If you want to collect events for a workload you just run perf-record -- 
workload.

Last time I dug into it (which was 8-12 months ago) -C required -a to 
work properly. -a (system_wide) meaning collect events for all cpus and 
then -C meaning but only for this cpu. Perhaps Namyhung's target changes 
may have simplified fixing that as Jiri's patch suggests.

David
