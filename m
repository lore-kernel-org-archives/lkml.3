Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab3JHMCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:02:11 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:36497 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3JHMCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <20131008115929.GA2303@gmail.com>
References: <20131008105016.GA2446@quad>
	<20131008115929.GA2303@gmail.com>
Date: Tue, 8 Oct 2013 14:02:06 +0200
Message-ID: <CABPqkBSiWcAZ4CxjJ8fvQ6Jm7Y242-ehHd-X4y0T70wY_dy+Zw@mail.gmail.com>
Subject: Re: [PATCH] perf tools: fix missing default initialization for tool->mmap2
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <bitbucket@online.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 1:59 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>>
>> This patch fixes a SEGFAULT bug with perf sched
>> related to the new MMAP2 record type. There was
>> a missing default initialization for the tool->mmap2
>> pointer in perf_tool__fill_defaults().
>>
>> Reproducer:
>>  # perf sched record -- sleep 1
>>  # perf sched lat
>>
>> Reported-by: Mike Galbraith <bitbucket@online.de>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> --
>>
>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> index 211b325..8415c54 100644
>> --- a/tools/perf/util/session.c
>> +++ b/tools/perf/util/session.c
>> @@ -256,6 +256,8 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
>>               tool->sample = process_event_sample_stub;
>>       if (tool->mmap == NULL)
>>               tool->mmap = process_event_stub;
>> +     if (tool->mmap2 == NULL)
>> +             tool->mmap2 = process_event_stub;
>>       if (tool->comm == NULL)
>>               tool->comm = process_event_stub;
>>       if (tool->fork == NULL)
>
> I think it's already fixed in tip:perf/urgent:
>
>   6adb0b0ae26f perf tools: Add default handler for mmap2 events
>
Ok, it's good then.
Thanks for checking.
