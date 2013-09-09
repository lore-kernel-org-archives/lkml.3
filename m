Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3IIPDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:03:31 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51522 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3IIPD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:03:29 -0400
Message-ID: <522DE339.4030004@gmail.com>
Date: Mon, 09 Sep 2013 08:03:21 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCHv2 00/25] perf tool: Add support for multiple data file
 storage
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com> <20130909111749.GP31370@twins.programming.kicks-ass.net> <20130909113640.GA16401@krava.redhat.com> <20130909115518.GA26785@twins.programming.kicks-ass.net> <20130909140339.GB16401@krava.redhat.com> <522DD6FF.50107@gmail.com> <20130909143134.GA27974@krava.redhat.com>
In-Reply-To: <20130909143134.GA27974@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/13 7:31 AM, Jiri Olsa wrote:
> On Mon, Sep 09, 2013 at 07:11:11AM -0700, David Ahern wrote:
>> On 9/9/13 7:03 AM, Jiri Olsa wrote:
>>> my usage currently is to having this running during the day:
>>> (well whenever I remember to run it.. ;-) )
>>>
>>>    [jolsa@krava perf]$ sudo ./perf record -g -M 1m -a
>>>
>>> and checking report when the system or app get stuck
>>>
>>> with multiple files I can just easily (or automaticaly)
>>> remove old ones without restarting session
>>
>> Aren't you losing potentially important events by doing that --
>> FORK, COMM, MMAP?
>
> those are synthesized for each file via synthesize_record
> function, see:
>
> [PATCH 19/25] perf tools: Move synthesizing into single function

Ok. haven't had time to look through your 2 large patch sets.

Seems like a lot of repetitive work on a loaded system. The overhead of 
the task events will dominate compared to the samples.

>
>>
>> I have a flight recorder style command that address this problem
>> (long-running/daemons) by processing task events and then stashing
>> the sample events on a time-ordered list with chopping to maintain
>> the time window.
>
> so far I noticed there could be race among EXIT and remaining
> SAMPLE events on another CPU mmap than EXIT event.. ending up
> with EXIT being stored in the old file, while SAMPLEs will get
> to the new one
>
> I was thinking about some 'perf daemon' so I dont need to run that
> manually.. seems similar to what you did

Right now I focus on scheduling events. This latest version of it can be 
easily recycled for other use cases. Some work would be needed to dump 
events to a file versus dumping processed information.

I am in San Jose this week. Not sure if I will have time to finish it to 
a point of pushing out patches, but maybe I can push to github in the 
next couple of days.

David
