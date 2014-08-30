Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaH3VxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:53:21 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58454 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaH3VxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:53:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-man\@vger.kernel.org" <linux-man@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Andy Lutomirski <luto@amacapital.net>, richard.weinberger@gmail.com,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <53F5310A.5080503@gmail.com>
Date: Sat, 30 Aug 2014 16:53:11 -0500
In-Reply-To: <53F5310A.5080503@gmail.com> (Michael Kerrisk's message of "Wed,
	20 Aug 2014 18:36:42 -0500")
Message-ID: <87d2bhfxvc.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1/IZNvBKwPpAdKSOXONSZSHqrsnh1f0P4s=
X-SA-Exim-Connect-IP: 67.172.111.204
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  1.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;"Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: For review: user_namespace(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Hello Eric et al.,
>
> For various reasons, my work on the namespaces man pages 
> fell off the table a while back. Nevertheless, the pages have
> been close to completion for a while now, and I recently restarted,
> in an effort to finish them. As you also noted to me f2f, there have
> been recently been some small namespace changes that you may affect
> the content of the pages. Therefore, I'll take the opportunity to
> send the namespace-related pages out for further (final?) review.
>
> So, here, I start with the user_namespaces(7) page, which is shown 
> in rendered form below, with source attached to this mail. I'll
> send various other pages in follow-on mails.
>
> Review comments/suggestions for improvements / bug fixes welcome.
>
> Cheers,
>
> Michael
>
> ==
>
> NAME
>        user_namespaces - overview of Linux user_namespaces
>
> DESCRIPTION
>        For an overview of namespaces, see namespaces(7).
>
>        User   namespaces   isolate   security-related   identifiers  and
>        attributes, in particular, user IDs and group  IDs  (see  creden‐
>        tials(7), the root directory, keys (see keyctl(2)), and capabili‐
>        ties (see capabilities(7)).  A process's user and group  IDs  can
>        be different inside and outside a user namespace.  In particular,
>        a process can have a normal unprivileged user ID outside  a  user
>        namespace while at the same time having a user ID of 0 inside the
>        namespace; in other words, the process has  full  privileges  for
>        operations  inside  the  user  namespace, but is unprivileged for
>        operations outside the namespace.
>
>    Nested namespaces, namespace membership
>        User namespaces can be nested;  that  is,  each  user  namespace—
>        except  the  initial  ("root") namespace—has a parent user names‐
>        pace, and can have zero or more child user namespaces.  The  par‐
>        ent user namespace is the user namespace of the process that cre‐
>        ates the user namespace via a call to unshare(2) or clone(2) with
>        the CLONE_NEWUSER flag.
>
>        The kernel imposes (since version 3.11) a limit of 32 nested lev‐
>        els of user namespaces.  Calls to  unshare(2)  or  clone(2)  that
>        would cause this limit to be exceeded fail with the error EUSERS.
>
>        Each  process  is  a  member  of  exactly  one user namespace.  A
>        process created via fork(2) or clone(2) without the CLONE_NEWUSER
>        flag  is  a  member  of the same user namespace as its parent.
>        A
           ^ single-threaded

Because of chroot and other things multi-threaded processes are not
allowed to join a user namespace.  For the documentation just saying
single-threaded sounds like enough here.

>        process can join another user namespace with setns(2) if  it  has
>        the  CAP_SYS_ADMIN  in  that namespace; upon doing so, it gains a
>        full set of capabilities in that namespace.
>
>        A call to clone(2) or  unshare(2)  with  the  CLONE_NEWUSER  flag
>        makes  the  new  child  process (for clone(2)) or the caller (for
>        unshare(2)) a member of the new user  namespace  created  by  the
>        call.
>
>    Capabilities
>        The child process created by clone(2) with the CLONE_NEWUSER flag
>        starts out with a complete set of capabilities in  the  new  user
>        namespace.  Likewise, a process that creates a new user namespace
>        using unshare(2)  or  joins  an  existing  user  namespace  using
>        setns(2)  gains a full set of capabilities in that namespace.  On
>        the other hand, that process has no capabilities  in  the  parent
>        (in  the case of clone(2)) or previous (in the case of unshare(2)
>        and setns(2)) user namespace, even if the new namespace  is  cre‐
>        ated  or  joined by the root user (i.e., a process with user ID 0
>        in the root namespace).
>
>        Note that a call to execve(2) will cause a process  to  lose  any
>        capabilities that it has, unless it has a user ID of 0 within the
>        namespace.  See the discussion of user  and  group  ID  mappings,
>        below.
>
>        A   call   to   clone(2),   unshare(2),  or  setns(2)  using  the
>        CLONE_NEWUSER flag sets the  "securebits"  flags  (see  capabili‐
>        ties(7))  to  their  default  values  (all flags disabled) in the
>        child (for clone(2)) or caller  (for  unshare(2),  or  setns(2)).
>        Note  that  because  the caller no longer has capabilities in its
>        original user namespace after a call to setns(2), it is not  pos‐
>        sible for a process to reset its "securebits" flags while retain‐
>        ing its user namespace membership by using  a  pair  of  setns(2)
>        calls  to  move  to another user namespace and then return to its
>        original user namespace.
>
>        Having a capability inside a user namespace permits a process  to
>        perform  operations  (that  require  privilege) only on resources
>        governed by that namespace.  The rules for determining whether or
>        not a process has a capability in a particular user namespace are
>        as follows:
>
>        1. A process has a capability inside a user namespace if it is  a
>           member  of  that  namespace  and  it has the capability in its
>           effective capability set.  A process can gain capabilities  in
>           its effective capability set in various ways.  For example, it
>           may execute a set-user-ID program or an executable with  asso‐
>           ciated  file  capabilities.   In  addition, a process may gain
>           capabilities  via  the  effect  of  clone(2),  unshare(2),  or
>           setns(2), as already described.
>
>        2. If a process has a capability in a user namespace, then it has
>           that capability in all child (and further removed  descendant)
>           namespaces as well.
>
>        3. When  a  user  namespace  is  created,  the kernel records the
>           effective user ID of the creating process as being the "owner"
>           of the namespace.  A process that resides in the parent of the
>           user namespace and whose effective user ID matches  the  owner
>           of  the  namespace  has all capabilities in the namespace.  By
>           virtue of the previous rule, this means that the  process  has
>           all capabilities in all further removed descendant user names‐
>           paces as well.
>
>    Interaction of user namespaces and other types of namespaces
>        Starting in Linux 3.8, unprivileged  processes  can  create  user
>        namespaces,  and mount, PID, IPC, network, and UTS namespaces can
>        be created with just the CAP_SYS_ADMIN capability in the caller's
>        user namespace.
>
>        If  CLONE_NEWUSER  is specified along with other CLONE_NEW* flags
>        in a single clone(2) or unshare(2) call, the  user  namespace  is
>        guaranteed  to  be  created first, giving the child (clone(2)) or
>        caller (unshare(2)) privileges over the remaining namespaces cre‐
>        ated by the call.  Thus, it is possible for an unprivileged call‐
>        er to specify this combination of flags.
>
>        When a new IPC, mount, network, PID, or UTS namespace is  created
>        via clone(2) or unshare(2), the kernel records the user namespace
>        of the creating process against the new namespace.  (This associ‐
>        ation  can't  be  changed.)   When a process in the new namespace
>        subsequently  performs  privileged  operations  that  operate  on
>        global resources isolated by the namespace, the permission checks
>        are performed according to the process's capabilities in the user
>        namespace that the kernel associated with the new namespace.

Restrictions on mount namespaces.

- A mount namespace has a owner user namespace.  A mount namespace whose
  owner user namespace is different than the owerner user namespace of
  it's parent mount namespace is considered a less privileged mount
  namespace.

- When creating a less privileged mount namespace shared mounts are
  reduced to slave mounts.  This ensures that mappings performed in less
  privileged mount namespaces will not propogate to more privielged
  mount namespaces.

- Mounts that come as a single unit from more privileged mount are
  locked together and may not be separated in a less privielged mount
  namespace.

- The mount flags readonly, nodev, nosuid, noexec, and the mount atime
  settings when propogated from a more privielged to a less privileged
  mount namespace become locked, and may not be changed in the less
  privielged mount namespace.

- (As of 3.18-rc1 (in todays Al Viros vfs.git#for-next tree)) A file or
  directory that is a mountpoint in one namespace that is not a mount
  point in another namespace, may be renamed, unlinked, or rmdired in
  the mount namespace in which it is not a mount namespace if the
  ordinary permission checks pass.

  Previously attemping to rmdir, unlink or rename a file or directory
  that was a mount point in another mount namespace would result in
  -EBUSY.  This behavior had technical problems of enforcement (nfs)
  and resulted in a nice denial of servial attack against more
  privileged users.  (Aka preventing individual files from being updated
  by bind mounting on top of them).

>    User and group ID mappings: uid_map and gid_map
>        When a user namespace is created, it starts out without a mapping
>        of user IDs (group  IDs)  to  the  parent  user  namespace.   The
>        /proc/[pid]/uid_map   and  /proc/[pid]/gid_map  files  (available
>        since Linux 3.5) expose the  mappings  for  user  and  group  IDs
>        inside  the  user namespace for the process pid.  These files can
>        be read to view the mappings in a user namespace and  written  to
>        (once) to define the mappings.
>
>        The  description in the following paragraphs explains the details
>        for uid_map; gid_map is exactly the same, but  each  instance  of
>        "user ID" is replaced by "group ID".
>
>        The  uid_map  file  exposes the mapping of user IDs from the user
>        namespace of the process pid to the user namespace of the process
>        that  opened  uid_map  (but  see  a  qualification  to this point
>        below).  In other words, processes that  are  in  different  user
>        namespaces  will  potentially  see  different values when reading
>        from a particular uid_map file, depending on the user ID mappings
>        for the user namespaces of the reading processes.
>
>        Each  line  in  the  uid_map file specifies a 1-to-1 mapping of a
>        range of contiguous user IDs between two user namespaces.   (When
>        a  user  namespace  is  first  created, this file is empty.)  The
>        specification in each line takes the form of three numbers delim‐
>        ited  by white space.  The first two numbers specify the starting
>        user ID in each of the two user  namespaces.   The  third  number
>        specifies  the length of the mapped range.  In detail, the fields
>        are interpreted as follows:
>
>        (1) The start of the range of user IDs in the user  namespace  of
>            the process pid.
>
>        (2) The  start  of  the  range  of user IDs to which the user IDs
>            specified by field one map.  How  field  two  is  interpreted
>            depends  on  whether  the process that opened uid_map and the
>            process pid are in the same user namespace, as follows:
>
>            a) If the two processes are  in  different  user  namespaces:
>               field  two is the start of a range of user IDs in the user
>               namespace of the process that opened uid_map.
>
>            b) If the two processes are in the same user namespace: field
>               two  is  the  start of the range of user IDs in the parent
>               user namespace of the process pid.  This case enables  the
>               opener  of  uid_map  (the  common  case  here  is  opening
>               /proc/self/uid_map) to see the mapping of  user  IDs  into
>               the  user  namespace of the process that created this user
>               namespace.
>
>        (3) The length of the range of user IDs that  is  mapped  between
>            the two user namespaces.
>
>        System  calls  that  return  user  IDs  (group  IDs)—for example,
>        getuid(2), getgid(2), and the credential fields in the  structure
>        returned by stat(2)—return the user ID (group ID) mapped into the
>        caller's user namespace.
>
>        When a process accesses a file, its user and group IDs are mapped
>        into  the  initial  user  namespace for the purpose of permission
>        checking and assigning IDs when creating a file.  When a  process
>        retrieves file user and group IDs via stat(2), the IDs are mapped
>        in the opposite direction, to  produce  values  relative  to  the
>        process user and group ID mappings.
>
>        The initial user namespace has no parent namespace, but, for con‐
>        sistency, the kernel provides dummy user  and  group  ID  mapping
>        files  for  this namespace.  Looking at the uid_map file (gid_map
>        is the same) from a shell in the initial namespace shows:
>
>            $ cat /proc/$$/uid_map
>                     0          0 4294967295
>
>        This mapping tells us that the range starting at  user  ID  0  in
>        this namespace maps to a range starting at 0 in the (nonexistent)
>        parent namespace, and the length of  the  range  is  the  largest
>        32-bit unsigned integer.

Which deliberately leaves 4294967295 32bit (-1) unmapped.  (uid_t)-1 is
used in several interfaces (like setreuid) as a way to specify no uid
leaving it unmapped and unusuable guarantees that there will be no
confusion when using those kernel methods.

>    Defining user and group ID mappings: writing to uid_map and gid_map
>        After  the  creation of a new user namespace, the uid_map file of
>        one of the processes in the namespace may be written to  once  to
>        define  the  mapping  of  user IDs in the new user namespace.  An
>        attempt to write more than once to  a  uid_map  file  in  a  user
>        namespace  fails  with  the error EPERM.  Similar rules apply for
>        gid_map files.
>
>        The lines written to uid_map (gid_map) must conform to  the  fol‐
>        lowing rules:
>
>        *  The  three  fields  must  be valid numbers, and the last field
>           must be greater than 0.
>
>        *  Lines are terminated by newline characters.
>
>        *  There is an (arbitrary) limit on the number of  lines  in  the
>           file.  As at Linux 3.8, the limit is five lines.  In addition,
>           the number of bytes written to the file must be less than  the
>           system page size, and the write must be performed at the start
>           of the file (i.e., lseek(2) and pwrite(2)  can't  be  used  to
>           write to nonzero offsets in the file).
>
>        *  The  range of user IDs (group IDs) specified in each line can‐
>           not overlap with the ranges in any other lines.  In  the  ini‐
>           tial  implementation  (Linux 3.8), this requirement was satis‐
>           fied by a simplistic implementation that imposed  the  further
>           requirement  that  the  values  in both field 1 and field 2 of
>           successive lines must be in ascending numerical  order,  which
>           prevented some otherwise valid maps from being created.  Linux
>           3.9 and later fix this limitation, allowing any valid  set  of
>           nonoverlapping maps.
>
>        *  At least one line must be written to the file.
>
>        Writes that violate the above rules fail with the error EINVAL.
>
>        In  order  for  a  process  to  write  to the /proc/[pid]/uid_map
>        (/proc/[pid]/gid_map) file, all  of  the  following  requirements
>        must be met:
>
>        1. The  writing  process  must  have  the CAP_SETUID (CAP_SETGID)
>           capability in the user namespace of the process pid.
>
>        2. The writing process must be in either the  user  namespace  of
>           the  process  pid  or  inside the parent user namespace of the
>           process pid.
>
>        3. The mapped user IDs (group IDs) must in turn have a mapping in
>           the parent user namespace.
>
>        4. One of the following is true:
>
>           *  The  data written to uid_map (gid_map) consists of a single
>              line that maps the writing  process's  filesystem  user  ID
>              (group ID) in the parent user namespace to a user ID (group
>              ID) in the user namespace.  The usual  case  here  is  that
>              this  single  line  provides  a  mapping for user ID of the
>              process that created the namespace.
>
>           *  The process has the CAP_SETUID (CAP_SETGID)  capability  in
>              the  parent user namespace.  Thus, a privileged process can
>              make mappings to arbitrary user IDs (group IDs) in the par‐
>              ent user namespace.
>
>        Writes that violate the above rules fail with the error EPERM.
>
>    Unmapped user and group IDs
>        There are various places where an unmapped user ID (group ID) may
>        be exposed to user space.  For example, the first  process  in  a
>        new user namespace may call getuid() before a user ID mapping has
>        been defined for the namespace.  In most such cases, an  unmapped
>        user  ID  is  converted  to  the overflow user ID (group ID); the
>        default value for the overflow user ID (group ID) is 65534.   See
>        the     descriptions    of    /proc/sys/kernel/overflowuid    and
>        /proc/sys/kernel/overflowgid in proc(5).
>
>        The cases where unmapped IDs are mapped in this  fashion  include
>        system calls that return user IDs (getuid(2) getgid(2), and simi‐
>        lar), credentials passed over a UNIX domain  socket,  credentials
>        returned  by  stat(2),  waitid(2),  and  the  System  V IPC "ctl"
>        IPC_STAT operations, credentials exposed by /proc/PID/status  and
>        the files in /proc/sysvipc/*, credentials returned via the si_uid
>        field in the siginfo_t received with a signal (see sigaction(2)),
>        credentials written to the process accounting file (see acct(5)),
>        and credentials returned with POSIX message  queue  notifications
>        (see mq_notify(3)).
>
>        There  is  one notable case where unmapped user and group IDs are
>        not converted to the corresponding overflow ID value.  When view‐
>        ing  a  uid_map  or gid_map file in which there is no mapping for
>        the second field, that field is displayed as 4294967295 (-1 as an
>        unsigned integer);
>
>    Set-user-ID and set-group-ID programs
>        When  a  process  inside  a user namespace executes a set-user-ID
>        (set-group-ID) program, the process's effective user  (group)  ID
>        inside  the  namespace is changed to whatever value is mapped for
>        the user (group) ID of the file.  However, if either the user  or
>        the group ID of the file has no mapping inside the namespace, the
>        set-user-ID (set-group-ID) bit is silently ignored: the new  pro‐
>        gram  is executed, but the process's effective user (group) ID is
>        left unchanged.  (This mirrors the semantics of executing a  set-
>        user-ID or set-group-ID program that resides on a filesystem that
>        was mounted with the MS_NOSUID flag, as described in mount(2).)
>
>    Miscellaneous
>        When a process's user and group IDs are passed over a UNIX domain
>        socket  to  a  process  in  a  different  user namespace (see the
>        description of SCM_CREDENTIALS in unix(7)), they  are  translated
>        into the corresponding values as per the receiving process's user
>        and group ID mappings.
>
> CONFORMING TO
>        Namespaces are a Linux-specific feature.
>
> NOTES
>        Over the years, there have been a lot of features that have  been
>        added  to  the Linux kernel that have been made available only to
>        privileged users because of their potential to confuse  set-user-
>        ID-root  applications.   In general, it becomes safe to allow the
>        root user in a user namespace to use those features because it is
>        impossible,  while  in  a  user namespace, to gain more privilege
>        than the root user of a user namespace has.
>
>    Availability
>        Use of user namespaces requires a kernel that is configured  with
>        the  CONFIG_USER_NS option.  User namespaces require support in a
>        range of subsystems across the kernel.  When an unsupported  sub‐
>        system  is configured into the kernel, it is not possible to con‐
>        figure user namespaces support.
>
>        As at Linux 3.8, most relevant subsystems supported  user  names‐
>        paces,  but  a number of filesystems did not have the infrastruc‐
>        ture needed to map user and group IDs  between  user  namespaces.
>        Linux  3.9  added the required infrastructure support for many of
>        the remaining unsupported filesystems (Plan 9 (9P),  Andrew  File
>        System  (AFS),  Ceph,  CIFS,  CODA,  NFS, and OCFS2).  Linux 3.11
>        added support the last of the unsupported major filesystems, XFS.
>
> EXAMPLE
>        The program below is designed to allow  experimenting  with  user
>        namespaces,  as  well  as  other types of namespaces.  It creates
>        namespaces as specified by command-line options and then executes
>        a  command  inside  those  namespaces.   The comments and usage()
>        function inside the program provide a  full  explanation  of  the
>        program.  The following shell session demonstrates its use.
>
>        First, we look at the run-time environment:
>
>            $ uname -rs     # Need Linux 3.8 or later
>            Linux 3.8.0
>            $ id -u         # Running as unprivileged user
>            1000
>            $ id -g
>            1000
>
>        Now  start a new shell in new user (-U), mount (-m), and PID (-p)
>        namespaces, with user ID (-M) and group ID (-G) 1000 mapped to  0
>        inside the user namespace:
>
>            $ ./userns_child_exec -p -m -U -M '0 1000 1' -G '0 1000 1' bash
>
>        The  shell  has PID 1, because it is the first process in the new
>        PID namespace:
>
>            bash$ echo $$
>            1
>
>        Inside the user namespace, the shell has user and group ID 0, and
>        a full set of permitted and effective capabilities:
>
>            bash$ cat /proc/$$/status | egrep '^[UG]id'
>            Uid: 0    0    0    0
>            Gid: 0    0    0    0
>            bash$ cat /proc/$$/status | egrep '^Cap(Prm|Inh|Eff)'
>            CapInh:   0000000000000000
>            CapPrm:   0000001fffffffff
>            CapEff:   0000001fffffffff
>
>        Mounting  a new /proc filesystem and listing all of the processes
>        visible in the new PID namespace shows that the shell  can't  see
>        any processes outside the PID namespace:
>
>            bash$ mount -t proc proc /proc
>            bash$ ps ax
>              PID TTY      STAT   TIME COMMAND
>                1 pts/3    S      0:00 bash
>               22 pts/3    R+     0:00 ps ax
>
>    Program source
>
>        /* userns_child_exec.c
>
>           Licensed under GNU General Public License v2 or later
>
>           Create a child process that executes a shell command in new
>           namespace(s); allow UID and GID mappings to be specified when
>           creating a user namespace.
>        */
>        #define _GNU_SOURCE
>        #include <sched.h>
>        #include <unistd.h>
>        #include <stdlib.h>
>        #include <sys/wait.h>
>        #include <signal.h>
>        #include <fcntl.h>
>        #include <stdio.h>
>        #include <string.h>
>        #include <limits.h>
>        #include <errno.h>
>
>        /* A simple error-handling function: print an error message based
>           on the value in 'errno' and terminate the calling process */
>
>        #define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
>                                } while (0)
>
>        struct child_args {
>            char **argv;        /* Command to be executed by child, with args */
>            int    pipe_fd[2];  /* Pipe used to synchronize parent and child */
>        };
>
>        static int verbose;
>
>        static void
>        usage(char *pname)
>        {
>            fprintf(stderr, "Usage: %s [options] cmd [arg...]\n\n", pname);
>            fprintf(stderr, "Create a child process that executes a shell "
>                    "command in a new user namespace,\n"
>                    "and possibly also other new namespace(s).\n\n");
>            fprintf(stderr, "Options can be:\n\n");
>        #define fpe(str) fprintf(stderr, "    %s", str);
>            fpe("-i          New IPC namespace\n");
>            fpe("-m          New mount namespace\n");
>            fpe("-n          New network namespace\n");
>            fpe("-p          New PID namespace\n");
>            fpe("-u          New UTS namespace\n");
>            fpe("-U          New user namespace\n");
>            fpe("-M uid_map  Specify UID map for user namespace\n");
>            fpe("-G gid_map  Specify GID map for user namespace\n");
>            fpe("-z          Map user's UID and GID to 0 in user namespace\n");
>            fpe("            (equivalent to: -M '0 <uid> 1' -G '0 <gid> 1')\n");
>            fpe("-v          Display verbose messages\n");
>            fpe("\n");
>            fpe("If -z, -M, or -G is specified, -U is required.\n");
>            fpe("It is not permitted to specify both -z and either -M or -G.\n");
>            fpe("\n");
>            fpe("Map strings for -M and -G consist of records of the form:\n");
>            fpe("\n");
>            fpe("    ID-inside-ns   ID-outside-ns   len\n");
>            fpe("\n");
>            fpe("A map string can contain multiple records, separated"
>                " by commas;\n");
>            fpe("the commas are replaced by newlines before writing"
>                " to map files.\n");
>
>            exit(EXIT_FAILURE);
>        }
>
>        /* Update the mapping file 'map_file', with the value provided in
>           'mapping', a string that defines a UID or GID mapping. A UID or
>           GID mapping consists of one or more newline-delimited records
>           of the form:
>
>               ID_inside-ns    ID-outside-ns   length
>
>           Requiring the user to supply a string that contains newlines is
>           of course inconvenient for command-line use. Thus, we permit the
>           use of commas to delimit records in this string, and replace them
>           with newlines before writing the string to the file. */
>
>        static void
>        update_map(char *mapping, char *map_file)
>        {
>            int fd, j;
>            size_t map_len;     /* Length of 'mapping' */
>
>            /* Replace commas in mapping string with newlines */
>
>            map_len = strlen(mapping);
>            for (j = 0; j < map_len; j++)
>                if (mapping[j] == ',')
>                    mapping[j] = '\n';
>
>            fd = open(map_file, O_RDWR);
>            if (fd == -1) {
>                fprintf(stderr, "ERROR: open %s: %s\n", map_file,
>                        strerror(errno));
>                exit(EXIT_FAILURE);
>            }
>
>            if (write(fd, mapping, map_len) != map_len) {
>                fprintf(stderr, "ERROR: write %s: %s\n", map_file,
>                        strerror(errno));
>                exit(EXIT_FAILURE);
>            }
>
>            close(fd);
>        }
>
>        static int              /* Start function for cloned child */
>        childFunc(void *arg)
>        {
>            struct child_args *args = (struct child_args *) arg;
>            char ch;
>
>            /* Wait until the parent has updated the UID and GID mappings.
>               See the comment in main(). We wait for end of file on a
>               pipe that will be closed by the parent process once it has
>               updated the mappings. */
>
>            close(args->pipe_fd[1]);    /* Close our descriptor for the write
>                                           end of the pipe so that we see EOF
>                                           when parent closes its descriptor */
>            if (read(args->pipe_fd[0], &ch, 1) != 0) {
>                fprintf(stderr,
>                        "Failure in child: read from pipe returned != 0\n");
>                exit(EXIT_FAILURE);
>            }
>
>            /* Execute a shell command */
>
>            printf("About to exec %s\n", args->argv[0]);
>            execvp(args->argv[0], args->argv);
>            errExit("execvp");
>        }
>
>        #define STACK_SIZE (1024 * 1024)
>
>        static char child_stack[STACK_SIZE];    /* Space for child's stack */
>
>        int
>        main(int argc, char *argv[])
>        {
>            int flags, opt, map_zero;
>            pid_t child_pid;
>            struct child_args args;
>            char *uid_map, *gid_map;
>            const int MAP_BUF_SIZE = 100;
>            char map_buf[MAP_BUF_SIZE];
>            char map_path[PATH_MAX];
>
>            /* Parse command-line options. The initial '+' character in
>               the final getopt() argument prevents GNU-style permutation
>               of command-line options. That's useful, since sometimes
>               the 'command' to be executed by this program itself
>               has command-line options. We don't want getopt() to treat
>               those as options to this program. */
>
>            flags = 0;
>            verbose = 0;
>            gid_map = NULL;
>            uid_map = NULL;
>            map_zero = 0;
>            while ((opt = getopt(argc, argv, "+imnpuUM:G:zv")) != -1) {
>                switch (opt) {
>                case 'i': flags |= CLONE_NEWIPC;        break;
>                case 'm': flags |= CLONE_NEWNS;         break;
>                case 'n': flags |= CLONE_NEWNET;        break;
>                case 'p': flags |= CLONE_NEWPID;        break;
>                case 'u': flags |= CLONE_NEWUTS;        break;
>                case 'v': verbose = 1;                  break;
>                case 'z': map_zero = 1;                 break;
>                case 'M': uid_map = optarg;             break;
>                case 'G': gid_map = optarg;             break;
>                case 'U': flags |= CLONE_NEWUSER;       break;
>                default:  usage(argv[0]);
>                }
>            }
>
>            /* -M or -G without -U is nonsensical */
>
>            if (((uid_map != NULL || gid_map != NULL || map_zero) &&
>                        !(flags & CLONE_NEWUSER)) ||
>                    (map_zero && (uid_map != NULL || gid_map != NULL)))
>                usage(argv[0]);
>
>            args.argv = &argv[optind];
>
>            /* We use a pipe to synchronize the parent and child, in order to
>               ensure that the parent sets the UID and GID maps before the child
>               calls execve(). This ensures that the child maintains its
>               capabilities during the execve() in the common case where we
>               want to map the child's effective user ID to 0 in the new user
>               namespace. Without this synchronization, the child would lose
>               its capabilities if it performed an execve() with nonzero
>               user IDs (see the capabilities(7) man page for details of the
>               transformation of a process's capabilities during execve()). */
>
>            if (pipe(args.pipe_fd) == -1)
>                errExit("pipe");
>
>            /* Create the child in new namespace(s) */
>
>            child_pid = clone(childFunc, child_stack + STACK_SIZE,
>                              flags | SIGCHLD, &args);
>            if (child_pid == -1)
>                errExit("clone");
>
>            /* Parent falls through to here */
>
>            if (verbose)
>                printf("%s: PID of child created by clone() is %ld\n",
>                        argv[0], (long) child_pid);
>
>            /* Update the UID and GID maps in the child */
>
>            if (uid_map != NULL || map_zero) {
>                snprintf(map_path, PATH_MAX, "/proc/%ld/uid_map",
>                        (long) child_pid);
>                if (map_zero) {
>                    snprintf(map_buf, MAP_BUF_SIZE, "0 %ld 1", (long) getuid());
>                    uid_map = map_buf;
>                }
>                update_map(uid_map, map_path);
>            }
>            if (gid_map != NULL || map_zero) {
>                snprintf(map_path, PATH_MAX, "/proc/%ld/gid_map",
>                        (long) child_pid);
>                if (map_zero) {
>                    snprintf(map_buf, MAP_BUF_SIZE, "0 %ld 1", (long) getgid());
>                    gid_map = map_buf;
>                }
>                update_map(gid_map, map_path);
>            }
>
>            /* Close the write end of the pipe, to signal to the child that we
>               have updated the UID and GID maps */
>
>            close(args.pipe_fd[1]);
>
>            if (waitpid(child_pid, NULL, 0) == -1)      /* Wait for child */
>                errExit("waitpid");
>
>            if (verbose)
>                printf("%s: terminating\n", argv[0]);
>
>            exit(EXIT_SUCCESS);
>        }
>
> SEE ALSO
>        newgidmap(1),   newuidmap(1),   clone(2),  setns(2),  unshare(2),
>        proc(5), subgid(5), subuid(5),  credentials(7),  capabilities(7),
>        namespaces(7), pid_namespaces(7)
>
>        The  kernel  source  file  Documentation/namespaces/resource-con‐
>        trol.txt.


Eric
