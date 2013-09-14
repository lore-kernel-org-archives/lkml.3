Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab3INScI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 14:32:08 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:53583 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab3INScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 14:32:06 -0400
Message-ID: <5234ABA2.5010400@gmail.com>
Date: Sat, 14 Sep 2013 12:32:02 -0600
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
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com> <20130909111749.GP31370@twins.programming.kicks-ass.net> <20130909113640.GA16401@krava.redhat.com> <20130909115518.GA26785@twins.programming.kicks-ass.net> <20130909140339.GB16401@krava.redhat.com> <522DD6FF.50107@gmail.com> <20130909143134.GA27974@krava.redhat.com> <522DE339.4030004@gmail.com>
In-Reply-To: <522DE339.4030004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/13 9:03 AM, David Ahern wrote:
>>> I have a flight recorder style command that address this problem
>>> (long-running/daemons) by processing task events and then stashing
>>> the sample events on a time-ordered list with chopping to maintain
>>> the time window.
>>
>> so far I noticed there could be race among EXIT and remaining
>> SAMPLE events on another CPU mmap than EXIT event.. ending up
>> with EXIT being stored in the old file, while SAMPLEs will get
>> to the new one
>>
>> I was thinking about some 'perf daemon' so I dont need to run that
>> manually.. seems similar to what you did
>
> Right now I focus on scheduling events. This latest version of it can be
> easily recycled for other use cases. Some work would be needed to dump
> events to a file versus dumping processed information.
>
> I am in San Jose this week. Not sure if I will have time to finish it to
> a point of pushing out patches, but maybe I can push to github in the
> next couple of days.

https://github.com/dsahern/linux/tree/perf-sched-timehist-3.11

Take a look at tools/perf/schedmon.c. Task events are processed and 
sample events are stashed on a list (daemon__process_sample). Could 
easily do something similar for mmap, comm, fork events and then on exit 
event flush events for terminated tasks. Then you will have both the 
task and sample events which can be dumped to a file for later processing.

David
