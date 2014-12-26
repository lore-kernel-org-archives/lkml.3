Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaLZROT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 12:14:19 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58639 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaLZROP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 12:14:15 -0500
Message-ID: <549D9762.3090701@gmail.com>
Date: Fri, 26 Dec 2014 10:14:10 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 14/37] perf tools: Convert dead thread list into rbtree
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org> <1419405333-27952-15-git-send-email-namhyung@kernel.org> <20141225230552.GB15569@krava.redhat.com> <CAM9d7chs3vHjRLn-Tv=XxRBkPsyr6-B1h5J=ywaSTm-G25X4gw@mail.gmail.com>
In-Reply-To: <CAM9d7chs3vHjRLn-Tv=XxRBkPsyr6-B1h5J=ywaSTm-G25X4gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/14 7:26 PM, Namhyung Kim wrote:
>>> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
>>> index 0b6dcd70bc8b..413f28cf689b 100644
>>> --- a/tools/perf/util/thread.h
>>> +++ b/tools/perf/util/thread.h
>>> @@ -11,10 +11,8 @@
>>>   struct thread_stack;
>>>
>>>   struct thread {
>>> -     union {
>>> -             struct rb_node   rb_node;
>>> -             struct list_head node;
>>> -     };
>>> +     struct rb_node          rb_node;
>>> +     struct list_head        node;
>>>        struct map_groups       *mg;
>>>        pid_t                   pid_; /* Not all tools update this */
>>>        pid_t                   tid;
>>> @@ -22,7 +20,8 @@ struct thread {
>>>        int                     cpu;
>>>        char                    shortname[3];
>>>        bool                    comm_set;
>>> -     bool                    dead; /* if set thread has exited */
>>> +     bool                    exited; /* if set thread has exited */
>>> +     bool                    dead; /* thread is in dead_threads list */
>>
>> looks like this also changes the logic (new exited flag),
>> not just the dead threads storage wheel
>
> AFAICS the 'dead' flag is not used other than thread__exited().  And
> it confused me a dead thread might not be in a dead_threads tree (or
> list).  So I changed the name and no logical change intended.

git show 236a3bbd5cb51

David

