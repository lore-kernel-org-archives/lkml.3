Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab3CAJKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:10:34 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47632 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3CAJK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:10:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: mtk.manpages@gmail.com
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
	<87txowa2cm.fsf@xmission.com>
	<CAKgNAkjxrbcpONCU4UdD0-cjXwbHr+YwkOR0H_aXp3CGB283Uw@mail.gmail.com>
Date: Fri, 01 Mar 2013 01:10:23 -0800
In-Reply-To: <CAKgNAkjxrbcpONCU4UdD0-cjXwbHr+YwkOR0H_aXp3CGB283Uw@mail.gmail.com>
	(Michael Kerrisk's message of "Fri, 1 Mar 2013 09:50:16 +0100")
Message-ID: <877glr5vuo.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX19yPN+O/06i8NrViV+708rYlguvqWZ8xqk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0005]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;mtk.manpages@gmail.com
X-Spam-Relay-Country: 
Subject: Re: For review: pid_namespaces(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Hi Eric,
>
> On Thu, Feb 28, 2013 at 4:24 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>
> [...]
>
>>> ==========
>>> PID_NAMESPACES(7)      Linux Programmer's Manual     PID_NAMESPACES(7)
>>>
>>> NAME
>>>        pid_namespaces - overview of Linux PID namespaces
>>>
>>> DESCRIPTION
> [...]
>
>>>    The namespace init process
>>>        The first process created in a new namespace (i.e., the process
>>>        created using clone(2) with the CLONE_NEWPID flag, or the first
>>>        child created by a process after a call to unshare(2) using the
>>>        CLONE_NEWPID flag) has the PID 1, and is the "init" process for
>>>        the namespace (see init(1)).  Children that are orphaned within
>>>        the namespace will be reparented to this  process  rather  than
>>>        init(1).
>>>
>>>        If the "init" process of a PID namespace terminates, the kernel
>>>        terminates all of the processes in the namespace via a  SIGKILL
>>>        signal.   This  behavior  reflects  the  fact  that  the "init"
>>>        process is essential for the correct operation of a PID  names‐
>>>        pace.   In this case, a subsequent fork(2) into this PID names‐
>>>        pace (e.g., from a process that has done a  setns(2)  into  the
>>>        namespace    using    an    open    file   descriptor   for   a
>>>        /proc/[pid]/ns/pid file corresponding to a process that was  in
>>>        the  namespace) will fail with the error ENOMEM; it is not pos‐
>>>        sible to create a new processes in a PID namespace whose "init"
>>>        process has terminated.
>>
>> It may be useful to mention unshare in the case of fork(2) failing just
>> because that is such an easy mistake to make.
>>
>> unshare(CLONE_NEWPID);
>> pid = fork();
>> waitpid(pid,...);
>> fork() -> ENOMEM
>
> I'm lost. Why does that sequence fail? The child of fork() becomes PID
> 1 in the new PID namespace.

Correct.
Then we wait for the child of the fork to exit();
Then we fork again into the new pid namespace.
The second fork fails because init has exited.

Eric
