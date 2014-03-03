Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaCCEL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 23:11:28 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:18506 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaCCEL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 23:11:27 -0500
Message-ID: <531400C7.7060204@huawei.com>
Date: Mon, 3 Mar 2014 12:10:47 +0800
From: xiakaixu <xiakaixu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>, <linux-kernel@vger.kernel.org>,
        Huxinwei <huxinwei@huawei.com>, Genghui <hui.geng@huawei.com>,
        <peifeiyue@huawei.com>
Subject: Re: A Bug Inquiry in linux/tools/perf/builtin-record.c
References: <53040D7F.3000905@huawei.com> <530C4330.20706@huawei.com> <87lhwyuwpy.fsf@sejong.aot.lge.com> <530EA8B3.5080205@huawei.com>
In-Reply-To: <530EA8B3.5080205@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.100.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014/2/27 10:53, xiakaixu 写道:
> Hi Namhyung,
> 
> 于 2014/2/26 16:03, Namhyung Kim 写道:
>> Hi xiakaixu,
>>
>>> 于 2014/2/19 9:48, xiakaixu 写道:
>>>> Hi all,
>>>>
>>>> There is a bug found in my work when running "perf record". The basic information
>>>> is here. As we know, perf record is a parent process and the programme traced is
>>>> a child process when running "perf record". Sometimes the child process become
>>>> zombie state and disappear until the parent process is killed. The bug stays in linux/
>>>> tools/perf/builtin-record.c.
>>>> *********************************************************************
>>>> static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>>>>     ......
>>>> 	if (hits == rec->samples) {
>>>>                          if (done)
>>>>                                  break;
>>>>                          err = poll(evsel_list->pollfd, evsel_list->nr_fds, -1);
>>>>                          waking++;
>>>>                  }
>>>>     ......
>>>> *********************************************************************
>>>> The parent process still call the function
>>>> poll(evsel_list->pollfd, evsel_list->nr_fds, -1) when the child process has exited
>>>> already, which caused a zombie process.
>>>>
>>>> May I have your opinion ?
>>>> Waiting for your reply!
>>
>> Do you have a real bug report based on this?

> yeah, of course we have it, I'll be glad to provide it if necessary.

>>
>> AFAIK perf record installed a signal handler for SIGCHLD so it'll set
>> the 'done' variable when child exits and then break the loop.

> yes, you are right. Though the 'done' varible will be set when child exits,
> there is time gap between "if(done)" statement and "poll(...)" function.
> The 'done' variable won't be judge when child exits in this time gap.
> You know this time gap is instruction level, so this bug is small probability.
> My solution is adding a while(...) statement outside poll(...) function.
>>

>> Thanks,
>> Namhyung
>> .
>>
> 


