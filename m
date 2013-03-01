Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3CAKVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 05:21:04 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:40989 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3CAKVB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 05:21:01 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <877glr5vuo.fsf@xmission.com>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
 <87txowa2cm.fsf@xmission.com> <CAKgNAkjxrbcpONCU4UdD0-cjXwbHr+YwkOR0H_aXp3CGB283Uw@mail.gmail.com>
 <877glr5vuo.fsf@xmission.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 1 Mar 2013 11:20:40 +0100
Message-ID: <CAKgNAkiBrVP71Q67ORMZm93-5=aBL+KTyCo0KVeTpDju-z05ZA@mail.gmail.com>
Subject: Re: For review: pid_namespaces(7) man page
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 10:10 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>
>> Hi Eric,
>>
>> On Thu, Feb 28, 2013 at 4:24 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>
>> [...]
>>
>>>> ==========
>>>> PID_NAMESPACES(7)      Linux Programmer's Manual     PID_NAMESPACES(7)
>>>>
>>>> NAME
>>>>        pid_namespaces - overview of Linux PID namespaces
>>>>
>>>> DESCRIPTION
>> [...]
>>
>>>>    The namespace init process
>>>>        The first process created in a new namespace (i.e., the process
>>>>        created using clone(2) with the CLONE_NEWPID flag, or the first
>>>>        child created by a process after a call to unshare(2) using the
>>>>        CLONE_NEWPID flag) has the PID 1, and is the "init" process for
>>>>        the namespace (see init(1)).  Children that are orphaned within
>>>>        the namespace will be reparented to this  process  rather  than
>>>>        init(1).
>>>>
>>>>        If the "init" process of a PID namespace terminates, the kernel
>>>>        terminates all of the processes in the namespace via a  SIGKILL
>>>>        signal.   This  behavior  reflects  the  fact  that  the "init"
>>>>        process is essential for the correct operation of a PID  names‐
>>>>        pace.   In this case, a subsequent fork(2) into this PID names‐
>>>>        pace (e.g., from a process that has done a  setns(2)  into  the
>>>>        namespace    using    an    open    file   descriptor   for   a
>>>>        /proc/[pid]/ns/pid file corresponding to a process that was  in
>>>>        the  namespace) will fail with the error ENOMEM; it is not pos‐
>>>>        sible to create a new processes in a PID namespace whose "init"
>>>>        process has terminated.
>>>
>>> It may be useful to mention unshare in the case of fork(2) failing just
>>> because that is such an easy mistake to make.
>>>
>>> unshare(CLONE_NEWPID);
>>> pid = fork();
>>> waitpid(pid,...);
>>> fork() -> ENOMEM
>>
>> I'm lost. Why does that sequence fail? The child of fork() becomes PID
>> 1 in the new PID namespace.
>
> Correct.
> Then we wait for the child of the fork to exit();
> Then we fork again into the new pid namespace.
> The second fork fails because init has exited.

Ahhh -- I misapprehended the scenario you were describing. Got it now.
I'll add that case.

Thanks,

Michael
