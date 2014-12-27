Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaL0Fmb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 00:42:31 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35090 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaL0Fm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 00:42:28 -0500
MIME-Version: 1.0
In-Reply-To: <549D9762.3090701@gmail.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-15-git-send-email-namhyung@kernel.org> <20141225230552.GB15569@krava.redhat.com>
 <CAM9d7chs3vHjRLn-Tv=XxRBkPsyr6-B1h5J=ywaSTm-G25X4gw@mail.gmail.com> <549D9762.3090701@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Sat, 27 Dec 2014 14:42:08 +0900
X-Google-Sender-Auth: x_fNbp2FRZ4uJMkOy80fQ3DYyUc
Message-ID: <CAM9d7cj5CqBAYDqOUy85cih+PX_T7zRgEvyjidTTkA=gCAmmDg@mail.gmail.com>
Subject: Re: [PATCH 14/37] perf tools: Convert dead thread list into rbtree
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 2:14 AM, David Ahern <dsahern@gmail.com> wrote:
> On 12/25/14 7:26 PM, Namhyung Kim wrote:
>>>>
>>>> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
>>>> index 0b6dcd70bc8b..413f28cf689b 100644
>>>> --- a/tools/perf/util/thread.h
>>>> +++ b/tools/perf/util/thread.h
>>>> @@ -11,10 +11,8 @@
>>>>   struct thread_stack;
>>>>
>>>>   struct thread {
>>>> -     union {
>>>> -             struct rb_node   rb_node;
>>>> -             struct list_head node;
>>>> -     };
>>>> +     struct rb_node          rb_node;
>>>> +     struct list_head        node;
>>>>        struct map_groups       *mg;
>>>>        pid_t                   pid_; /* Not all tools update this */
>>>>        pid_t                   tid;
>>>> @@ -22,7 +20,8 @@ struct thread {
>>>>        int                     cpu;
>>>>        char                    shortname[3];
>>>>        bool                    comm_set;
>>>> -     bool                    dead; /* if set thread has exited */
>>>> +     bool                    exited; /* if set thread has exited */
>>>> +     bool                    dead; /* thread is in dead_threads list */
>>>
>>>
>>> looks like this also changes the logic (new exited flag),
>>> not just the dead threads storage wheel
>>
>>
>> AFAICS the 'dead' flag is not used other than thread__exited().  And
>> it confused me a dead thread might not be in a dead_threads tree (or
>> list).  So I changed the name and no logical change intended.
>
>
> git show 236a3bbd5cb51

Thanks for the pointer.  I understand the need of delaying the move to
dead_threads list, but anyway it still makes me confused.  So I
renamed the flag to keep the current behavior and match the name
'dead' to the list/tree management to reduce further confusion.

Thanks,
Namhyung
