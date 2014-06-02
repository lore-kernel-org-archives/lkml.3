Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaFBUyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:54:19 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:37660 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbaFBUyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJzCPVmD9pR_AAdJF0Z1jRuh9x_vtM9K-q8JQQYNya9Kg@mail.gmail.com>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
 <1400799936-26499-7-git-send-email-keescook@chromium.org> <CALCETrWR6s7wqSwEeygOYqizrxy8eAyHb3SqvLoTooMZ+MfdqA@mail.gmail.com>
 <CAGXu5j+=itFtHe25pZxXsk+1C1Cca4DGm83SC93=xRctUdeXsw@mail.gmail.com>
 <CALCETrX3fjeHeigLXy7Juq6XrNFEeZLQPLmQhiOwBDgc0MRtBw@mail.gmail.com>
 <CAGXu5jL4erM41JBG703adSht-f4K7fAfbG9XyjPNUwiyAde-Nw@mail.gmail.com>
 <CALCETrVZADpErLwsyaWEQqVa45_VEMyQg+L+g2gR4NhwNCXd4g@mail.gmail.com>
 <CAGXu5jKdJDS5k+tpUhQdyMZt40S8H3C-4zFQQS-dmaP3dE6Avw@mail.gmail.com>
 <CALCETrVTfViNBua0DURxPwbbSnoL07x=EMTxxq3zO5bzQrM00A@mail.gmail.com>
 <CAGXu5j+KdJbZwtQpOab5J_-0uudpWHtoPwyvuDr0E-MRhNm90Q@mail.gmail.com>
 <CALCETrUO_R0FVdd4CAiGxkD=gu-Hnnz3WBkjzU2CYubdQ2cXug@mail.gmail.com> <CAGXu5jJzCPVmD9pR_AAdJF0Z1jRuh9x_vtM9K-q8JQQYNya9Kg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 2 Jun 2014 13:53:56 -0700
Message-ID: <CALCETrXAO_5bCHF80H5P-1T74-CM-_5wrrr7WDYgC4uywWmL=A@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] seccomp: add SECCOMP_EXT_ACT_TSYNC and SECCOMP_FILTER_TSYNC
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dario Faggioli <raistlin@linux.it>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        liguang <lig.fnst@cn.fujitsu.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 12:55 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, May 27, 2014 at 12:27 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Tue, May 27, 2014 at 12:23 PM, Kees Cook <keescook@chromium.org> wrote:
>>> On Tue, May 27, 2014 at 12:10 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> On Tue, May 27, 2014 at 11:45 AM, Kees Cook <keescook@chromium.org> wrote:
>>>>> On Tue, May 27, 2014 at 11:40 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>>> On Tue, May 27, 2014 at 11:24 AM, Kees Cook <keescook@chromium.org> wrote:
>>>>>>> On Mon, May 26, 2014 at 12:27 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>>>>> On Fri, May 23, 2014 at 10:05 AM, Kees Cook <keescook@chromium.org> wrote:
>>>>>>>>> On Thu, May 22, 2014 at 4:11 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>>>>>>> On Thu, May 22, 2014 at 4:05 PM, Kees Cook <keescook@chromium.org> wrote:
>>>>>>>>>>> Applying restrictive seccomp filter programs to large or diverse
>>>>>>>>>>> codebases often requires handling threads which may be started early in
>>>>>>>>>>> the process lifetime (e.g., by code that is linked in). While it is
>>>>>>>>>>> possible to apply permissive programs prior to process start up, it is
>>>>>>>>>>> difficult to further restrict the kernel ABI to those threads after that
>>>>>>>>>>> point.
>>>>>>>>>>>
>>>>>>>>>>> This change adds a new seccomp extension action for synchronizing thread
>>>>>>>>>>> group seccomp filters and a prctl() for accessing that functionality,
>>>>>>>>>>> as well as a flag for SECCOMP_EXT_ACT_FILTER to perform sync at filter
>>>>>>>>>>> installation time.
>>>>>>>>>>>
>>>>>>>>>>> When calling prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT, SECCOMP_EXT_ACT_FILTER,
>>>>>>>>>>> flags, filter) with flags containing SECCOMP_FILTER_TSYNC, or when calling
>>>>>>>>>>> prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT, SECCOMP_EXT_ACT_TSYNC, 0, 0), it
>>>>>>>>>>> will attempt to synchronize all threads in current's threadgroup to its
>>>>>>>>>>> seccomp filter program. This is possible iff all threads are using a filter
>>>>>>>>>>> that is an ancestor to the filter current is attempting to synchronize to.
>>>>>>>>>>> NULL filters (where the task is running as SECCOMP_MODE_NONE) are also
>>>>>>>>>>> treated as ancestors allowing threads to be transitioned into
>>>>>>>>>>> SECCOMP_MODE_FILTER. If prctrl(PR_SET_NO_NEW_PRIVS, ...) has been set on the
>>>>>>>>>>> calling thread, no_new_privs will be set for all synchronized threads too.
>>>>>>>>>>> On success, 0 is returned. On failure, the pid of one of the failing threads
>>>>>>>>>>> will be returned, with as many filters installed as possible.
>>>>>>>>>>
>>>>>>>>>> Is there a use case for adding a filter and synchronizing filters
>>>>>>>>>> being separate operations?  If not, I think this would be easier to
>>>>>>>>>> understand and to use if there was just a single operation.
>>>>>>>>>
>>>>>>>>> Yes: if the other thread's lifetime is not well controlled, it's good
>>>>>>>>> to be able to have a distinct interface to retry the thread sync that
>>>>>>>>> doesn't require adding "no-op" filters.
>>>>>>>>
>>>>>>>> Wouldn't this still be solved by:
>>>>>>>>
>>>>>>>> seccomp_add_filter(final_filter, SECCOMP_FILTER_ALL_THREADS);
>>>>>>>>
>>>>>>>> the idea would be that, if seccomp_add_filter fails, then you give up
>>>>>>>> and, if it succeeds, then you're done.  It shouldn't fail unless out
>>>>>>>> of memory or you've nested too deeply.
>>>>>>>
>>>>>>> I wanted to keep the case of being able to to wait for non-ancestor
>>>>>>> threads to finish. For example, 2 threads start and set separate
>>>>>>> filters. 1 does work and exits, 2 starts another thread (3) which adds
>>>>>>> filters, does work, and then waits for 1 to finish by calling TSYNC.
>>>>>>> Once 1 dies, TSYNC succeeds. In the case of not having direct control
>>>>>>> over thread lifetime (say, when using third-party libraries), I'd like
>>>>>>> to retain the flexibility of being able to do TSYNC without needing a
>>>>>>> filter being attached to it.
>>>>>>
>>>>>> I must admit this strikes me as odd.  What's the point of having a
>>>>>> thread set a filter if it intends to be a short-lived thread?
>>>>>
>>>>> I was illustrating the potential insanity of third-party libraries.
>>>>> There isn't much sense in that behavior, but if it exists, working
>>>>> around it is harder without the separate TSYNC-only call.
>>>>>
>>>>>> In any case, I must have missed the ability for TSYNC to block.  Hmm.
>>>>>> That seems complicated, albeit potentially useful.
>>>>>
>>>>> Oh, no, I didn't mean to imply TSYNC should block. I meant that thread
>>>>> 3 could do:
>>>>>
>>>>> while (TSYNC-fails)
>>>>>    wait-on-or-kill-unexpected-thread
>>>>>
>>>>
>>>> Ok.
>>>>
>>>> I'm still not seeing the need for a separate TSYNC option, though --
>>>> just add-a-filter-across-all-threads would work if it failed
>>>> harmlessly on error.  FWIW, TSYNC is probably equivalent to adding an
>>>> always-accept filter across all threads, although no one should really
>>>> do the latter for efficiency reasons.
>>>
>>> Given the complexity of the locking, "fail" means "I applied the
>>> change to all threads except for at least this one: *error code*",
>>> which means looping with the "add-a-filter" method means all the other
>>> threads keep getting filters added until there is full success. I
>>> don't want that overhead, so this keeps TSYNC distinctly separate.
>>
>> Ugh, right.
>>
>>>
>>> Because of the filter addition, when using add_filter-TSYNC, it's not
>>> sensible to continue after a failure. However, using just-TSYNC allows
>>> sensible re-trying. Since the environments where TSYNC intend to be
>>> used in can be very weird, I really want to retain the retry ability.
>>
>> OK.  So what's wrong with the other approach in which the
>> add-to-all-threads option always succeeds?  IOW, rather than requiring
>> that all threads have the caller's filter as an ancestor, just add the
>> requested filter to all threads.  As an optimization, if the targetted
>> thread has the current thread's filter as its filter, too, then the
>> targetted thread can stay synchronized.
>>
>> That way the add filter call really is atomic.
>>
>> I'm not fundamentally opposed to TSYNC, but I think I'd be happier if
>> the userspace interface could be kept as simple as possible.  The fact
>> that there's a filter hierarchy is sort of an implementation detail, I
>> think.
>
> I'm totally on board with making this as simple as possible. :) The
> corner cases are kind of horrible, though, but I think this is already
> as simple as it can get.
>
> Externally, without the ancestry check, we can run the risk of have
> unstable behavior out of a filter change. Imagine the case of a race
> where a thread is adding a filter (via prctl), and the other thread
> attempts to TSYNC a filter that blocks prctl.
>
> In the "always take the new filter" case, sometimes we get two filters
> (original and TSYNCed) on the first thread, and sometimes it blows up
> when it calls prctl (TSYNCed filter blocks the prctl). There's no way
> for the TSYNC caller to detect who won the race.
>
> With the patch series as-is, losing the race results in a TSYNC
> failure (ancestry doesn't match). This is immediately detectable and
> the caller can the decide how to handle the situation directly.
>
> Regardless, I don't think the filter hierarchy is an implementation
> detail -- complex filters take advantage of the hierarchies. And
> keeping this hierarchy stable means the filters are simpler to
> validate for correctness, etc.

Hmm.

Another issue: unless I'm not looking at the right version of this, I
don't think that while_each_thread does what you think it does.

I'm generally in favor of making the kernel interfaces easy to use,
even at the cost of a bit of implementation complexity.  Would this be
simpler if you hijacked siglock to protect seccomp state?  Then I
think you could just make everything atomic.

--Andy
