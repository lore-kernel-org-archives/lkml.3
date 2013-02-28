Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3B1Phi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:37:38 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43170 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3B1Phe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:37:34 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: mtk.manpages@gmail.com
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
Date: Thu, 28 Feb 2013 07:24:09 -0800
In-Reply-To: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
	(Michael Kerrisk's message of "Thu, 28 Feb 2013 12:24:07 +0100")
Message-ID: <87txowa2cm.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX18s1dJUjE8EJygTv7JI3EHgKu95Gh3LvGQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
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

> Eric et al,
>
> Eventually, there will be more namespace man pages, but let us start
> now with one for PID namespaces. The attached page aims to provide a
> fairly complete overview of PID namespaces.
>
> Eric, various pieces of the page are shifted out of other pages
> (clone(2), setns(2), etc.) and are derived from comments you've
> emailed me off list, so you are (jointly) in the copyright of the
> page. I've chosen the common license for man-pages; let me know if you
> have any objections to that license.

Interesting license.  It seems reasonable.

> I'm looking for review comments (corrections, improvements, additions,
> etc.) on this page. I've provided it in two forms inline below, and
> reviewers can comment comment on whichever form they are most
> comfortable with:
>
> 1) The rendered page as plain text
> 2) The *roff source (also attached); rendering that source will enable
> readers to see proper formatting for the page.
>
> Note that the namespaces(7) page referred to in this page is not yet
> finished; I'll send it out for review at a future time.
>
> Thanks,
>
> Michael
>
> ==========
> PID_NAMESPACES(7)      Linux Programmer's Manual     PID_NAMESPACES(7)
>
> NAME
>        pid_namespaces - overview of Linux PID namespaces
>
> DESCRIPTION
>        For an overview of namespaces, see namespaces(7).
>
>        PID  namespaces  isolate  the  process ID number space, meaning
>        that processes in different PID namespaces can  have  the  same
>        PID.   PID namespaces allow containers to migrate to a new host
>        while the processes inside  the  container  maintain  the  same
>        PIDs.
>
>        PIDs  in a new PID namespace start at 1, somewhat like a stand‐
>        alone system, and calls to fork(2), vfork(2), or clone(2)  will
>        produce  processes  with PIDs that are unique within the names‐
>        pace.
>
>        Use of PID namespaces requires a kernel that is configured with
>        the CONFIG_PID_NS option.
>
>    The namespace init process
>        The first process created in a new namespace (i.e., the process
>        created using clone(2) with the CLONE_NEWPID flag, or the first
>        child created by a process after a call to unshare(2) using the
>        CLONE_NEWPID flag) has the PID 1, and is the "init" process for
>        the namespace (see init(1)).  Children that are orphaned within
>        the namespace will be reparented to this  process  rather  than
>        init(1).
>
>        If the "init" process of a PID namespace terminates, the kernel
>        terminates all of the processes in the namespace via a  SIGKILL
>        signal.   This  behavior  reflects  the  fact  that  the "init"
>        process is essential for the correct operation of a PID  names‐
>        pace.   In this case, a subsequent fork(2) into this PID names‐
>        pace (e.g., from a process that has done a  setns(2)  into  the
>        namespace    using    an    open    file   descriptor   for   a
>        /proc/[pid]/ns/pid file corresponding to a process that was  in
>        the  namespace) will fail with the error ENOMEM; it is not pos‐
>        sible to create a new processes in a PID namespace whose "init"
>        process has terminated.

It may be useful to mention unshare in the case of fork(2) failing just
because that is such an easy mistake to make.

unshare(CLONE_NEWPID);
pid = fork();
waitpid(pid,...);
fork() -> ENOMEM 

>        Only  signals  for  which  the "init" process has established a
>        signal handler can be sent to the "init" process by other  mem‐
>        bers  of  the  PID namespace.  This restriction applies even to
>        privileged processes, and prevents other  members  of  the  PID
>        namespace from accidentally killing the "init" process.
>
>        Likewise, a process in an ancestor namespace can—subject to the
>        usual permission checks described in  kill(2)—send  signals  to
>        the  "init" process of a child PID namespace only if the "init"
>        process has established a handler for that signal.  (Within the
>        handler,  the  siginfo_t si_pid field described in sigaction(2)
>        will be zero.)  SIGKILL or SIGSTOP are  treated  exceptionally:
>        these signals are forcibly delivered when sent from an ancestor
>        PID namespace.  Neither of these signals can be caught  by  the
>        "init" process, and so will result in the usual actions associ‐
>        ated with those signals (respectively, terminating and stopping
>        the process).
>
>    Nesting PID namespaces
>        PID  namespaces can be nested: each PID namespace has a parent,
>        except for the initial ("root") PID namespace.  The parent of a
>        PID  namespace is the PID namespace of the process that created
>        the namespace using clone(2)  or  unshare(2).   PID  namespaces
>        thus  form a tree, with all namespaces ultimately tracing their
>        ancestry to the root namespace.
>
>        A process is visible to other processes in its  PID  namespace,
>        and  to  the  processes  in  each direct ancestor PID namespace
>        going back to the root PID namespace.  In this context,  "visi‐
>        ble"  means that one process can be the target of operations by
>        another process using system calls that specify a  process  ID.
>        Conversely,  the  processes  in a child PID namespace can't see
>        processes in the parent and further removed ancestor namespace.
>        More  succinctly:  a  process  can see (e.g., send signals with
>        kill(2), set nice values with setpriority(2), etc.)  only  pro‐
>        cesses contained in its own PID namespace and in descendants of
>        that namespace.
>
>        A process has one process ID in each of the layers of  the  PID
>        namespace  hierarchy  in  which  is  visible,  and walking back
>        though each direct ancestor namespace through to the  root  PID
>        namespace.   System  calls  that  operate on process IDs always
>        operate using the process ID that is visible in the PID  names‐
>        pace of the caller.  A call to getpid(2) always returns the PID
>        associated with the namespace in which the process was created.
>
>        Some processes in a PID namespace may  have  parents  that  are
>        outside  of the namespace.  For example, the parent of the ini‐
>        tial process in the namespace (i.e., the init(1)  process  with
>        PID  1)  is  necessarily  in  another namespace.  Likewise, the
>        direct children of a process that uses setns(2)  to  cause  its
>        children  to join a PID namespace are in a different PID names‐
>        pace from the caller of setns(2).  Calls to getppid(2) for such
>        processes return 0.
>
>    setns(2) and unshare(2) semantics
>        Calls  to setns(2) that specify a PID namespace file descriptor
>        and calls to unshare(2) with the CLONE_NEWPID flag cause  chil‐
>        dren  subsequently created by the caller to be placed in a dif‐
>        ferent PID namespace from the caller.  These calls do not, how‐
>        ever,  change the PID namespace of the calling process, because
>        doing so would change the caller's idea  of  its  own  PID  (as
>        reported  by getpid()), which would break many applications and
>        libraries.
>
>        To put things another way: a process's PID namespace membership
>        is determined when the process is created and cannot be changed
>        thereafter.  Among other things, this means that  the  parental
>        relationship between processes mirrors the parental between PID
>        namespaces: the parent of a  process  is  either  in  the  same
>        namespace or resides in the immediate parent PID namespace.

This is mostly true.  With setns it is possible to have a parent
in a pid namespace several steps up the pid namespace hierarchy.

>        Every  thread  in  a process must be in the same PID namespace.
>        For this reason, the two following call sequences will fail:
>
>            unshare(CLONE_NEWPID);
>            clone(..., CLONE_VM, ...);    /* Fails */
>
>            setns(fd, CLONE_NEWPID);
>            clone(..., CLONE_VM, ...);    /* Fails */
>
>        Because the above unshare(2) and setns(2) calls only change the
>        PID  namespace  for created children, the clone(2) calls neces‐
>        sarily put the new thread in a different PID namespace from the
>        calling thread.

I don't know if it is interesting but these sequences also fail.  But I
suppose that is obvious?  Or documented at least Documented in the clone
manpage and unshare manpages.

            clone(..., CLONE_VM, ...);
            unshare(CLONE_NEWPID);       /* Fails */

            clone(..., CLONE_VM, ...);
            setns(fd, CLONE_NEWPID);     /* Fails */
              
>    Miscellaneous
>        After  creating a new PID namespace, it is useful for the child
>        to change its root directory and mount a new procfs instance at
>        /proc  so  that  tools such as ps(1) work correctly.  (If a new
>        mount  namespace  is  simultaneously   created   by   including
>        CLONE_NEWNS  in  the flags argument of clone(2) or unshare(2)),
>        then it isn't necessary to change the  root  directory:  a  new
>        procfs instance can be mounted directly over /proc.)

Should it be documented somewhere that /proc when mounted from a pid
namespace will use the pids of that pid namespace and /proc will only
show process for visible in the mounting pid namespace, even if that
mount of proc is accessed by processes in other pid namespaces?

You sort of say it here by saying it is useful to mount a new copy of
/proc, which it is.  I just don't see you coming out straight and saying
why it is.  It just seems to be implied.

>        Calling  readlink(2)  on the path /proc/self yields the process
>        ID of the caller in the  PID  namespace  of  the  procfs  mount
>        (i.e.,  the  PID  namespace  of  the  process  that mounted the
>        procfs).
>
>        When a process ID is passed over a  UNIX  domain  socket  to  a
>        process  in  a  different PID namespace (see the description of
>        SCM_CREDENTIALS in unix(7)), it is translated into  the  corre‐
>        sponding PID value in the receiving process's PID namespace.
>
> CONFORMING TO
>        Namespaces are a Linux-specific feature.
>
> SEE ALSO
>        unshare(1),  clone(2),  setns(2),  unshare(2), proc(5), creden‐
>        tials(7), capabilities(7), user_namespaces(7), switch_root(8)
>
>
>
> Linux                         2013-01-14             PID_NAMESPACES(7)
>
>
