Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab3CDRwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:52:30 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49545 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173Ab3CDRw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:52:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: mtk.manpages@gmail.com
Cc: Rob Landley <rob@landley.net>, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
	<1362110504.15531.4@driftwood>
	<CAKgNAkgVKnhRT1Lpq4a_UdBKB+tn6XmWSDF2QJXG0aSLtNH6dg@mail.gmail.com>
	<87wqtr3zg5.fsf@xmission.com>
	<CAKgNAkjGD0FdQqpA+rYR=+Yc5uVPB8mE5JjCqy-5WS85cPsvng@mail.gmail.com>
Date: Mon, 04 Mar 2013 09:52:19 -0800
In-Reply-To: <CAKgNAkjGD0FdQqpA+rYR=+Yc5uVPB8mE5JjCqy-5WS85cPsvng@mail.gmail.com>
	(Michael Kerrisk's message of "Mon, 4 Mar 2013 13:46:57 +0100")
Message-ID: <87k3pnhx2k.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX196r7lK9U3zu5FVcdpSeeQBmdf8ep4hmbc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3847]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;mtk.manpages@gmail.com
X-Spam-Relay-Country: 
Subject: Re: For review: pid_namespaces(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> On Fri, Mar 1, 2013 at 4:35 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>
>>> Hi Rob,
>>>
>>> On Fri, Mar 1, 2013 at 5:01 AM, Rob Landley <rob@landley.net> wrote:
>>>> On 02/28/2013 05:24:07 AM, Michael Kerrisk (man-pages) wrote:
>>> [...]
>>>
>>>>> DESCRIPTION
>>>>>        For an overview of namespaces, see namespaces(7).
>>>>>
>>>>>        PID  namespaces  isolate  the  process ID number space, meaning
>>>>>        that processes in different PID namespaces can  have  the  same
>>>>>        PID.
>>>>
>>>>
>>>> Um, perhaps "different processes"? Slightly repetitive, but trying to avoid
>>>> the potential misreading that "a processes can have the same PID in
>>>> different namespaces". (A single process can't be a member of more than one
>>>> namespace. This is not about selective visibility.)
>>>
>>> I'm not sure this clarifies things...
>>>
>>>>> PID namespaces allow containers to migrate to a new host
>>>>>        while the processes inside  the  container  maintain  the  same
>>>>>        PIDs.
>>>>
>>>>
>>>> I thought suspend/resume a container was the simple case. Migration to a new
>>>> host is built on top of that. (On resume in a new container on the same
>>>> system, if other stuff is going on in the system so the available PIDs have
>>>> shifted.)
>>>
>>> I'll add some words here on suspend/resume.
>>>
>>>>>        Likewise, a process in an ancestor namespace can—subject to the
>>>>>        usual permission checks described in  kill(2)—send  signals  to
>>>>>        the  "init" process of a child PID namespace only if the "init"
>>>>>        process has established a handler for that signal.  (Within the
>>>>>        handler,  the  siginfo_t si_pid field described in sigaction(2)
>>>>>        will be zero.)  SIGKILL or SIGSTOP are  treated  exceptionally:
>>>>>        these signals are forcibly delivered when sent from an ancestor
>>>>>        PID namespace.  Neither of these signals can be caught  by  the
>>>>>        "init" process, and so will result in the usual actions associ‐
>>>>>        ated with those signals (respectively, terminating and stopping
>>>>>        the process).
>>>>
>>>>
>>>> If SIGKILL to init is propogated to all the children of init, is SIGSTOP
>>>> also propogated to all the children? (I.E. will SIGSTOP to container's init
>>>> suspend the whole container, and will SIGCONT resume the whole container? If
>>>> the latter, will it only resume processes that weren't previously stopped?
>>>> :)
>>>
>>> Covered by Eric.
>>>
>>>>>        To put things another way: a process's PID namespace membership
>>>>>        is determined when the process is created and cannot be changed
>>>>>        thereafter.  Among other things, this means that  the  parental
>>>>>        relationship between processes mirrors the parental between PID
>>>>
>>>>
>>>> mirrors the relationship
>>>
>>> Thanks.
>>>
>>>>>        namespaces: the parent of a  process  is  either  in  the  same
>>>>>        namespace or resides in the immediate parent PID namespace.
>>>>>
>>>>>        Every  thread  in  a process must be in the same PID namespace.
>>>>>        For this reason, the two following call sequences will fail:
>>>>>
>>>>>            unshare(CLONE_NEWPID);
>>>>>            clone(..., CLONE_VM, ...);    /* Fails */
>>>>>
>>>>>            setns(fd, CLONE_NEWPID);
>>>>>            clone(..., CLONE_VM, ...);    /* Fails */
>>>>
>>>>
>>>> They fail with -EUNDOCUMENTED
>>>
>>> Added EINVAL, as per Eric's reply. (Eric does that error also apply
>>> for the two new cases you added?).
>>>
>>>>>        Because the above unshare(2) and setns(2) calls only change the
>>>>>        PID  namespace  for created children, the clone(2) calls neces‐
>>>>>        sarily put the new thread in a different PID namespace from the
>>>>>        calling thread.
>>>>
>>>>
>>>> Um, no they don't. They fail. That's the point.
>>>
>>> (Good catch.)
>>>
>>>> They _would_ put the new
>>>> thread in a different PID namespace, which breaks the definition of threads.
>>>>
>>>> How about:
>>>>
>>>> The above unshare(2) and setns(2) calls change the PID namespace of
>>>> children created by subsequent clone(2) calls, which is incompatible
>>>> with CLONE_VM.
>>>
>>> I decided on:
>>>
>>>        The  point  here is that unshare(2) and setns(2) change the PID
>>>        namespace for created children but not for the calling process,
>>>        while  clone(2) CLONE_VM specifies the creation of a new thread
>>>        in the same process.
>>
>> Can we make that "for all new tasks created" instead of "created
>> children"
>>
>> Othewise someone might expect CLONE_THREAD would work as you
>> CLONE_THREAD creates a thread and not a child...
>
> The term "task" is kernel-space talk that rarely appears in man pages,
> so I am reluctant to use it.

With respect to clone and in this case I am not certain we can properly
describe what happens without talking about tasks.  But it is worth
a try.


> How about this:
>
>        The  point  here is that unshare(2) and setns(2) change the PID
>        namespace for processes subsequently created by the caller, but
>        not  for the calling process, while clone(2) CLONE_VM specifies
>        the creation of a new thread in the same process.

Hmm.  How about this.

         The point here is that unshare(2) and setns(2) change the PID
         namespace that will be used by in all subsequent calls to clone
         and fork by the caller, but not for the calling process, and
         that all threads in a process must share the same PID
         namespace.  Which makes a subsequent clone(2) CLONE_VM
         specify the creation of a new thread in the a different PID
         namespace but in the same process which is impossible.

Eric
