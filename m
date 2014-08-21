Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbaHUN3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:29:00 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:53247 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbaHUN26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:28:58 -0400
Message-ID: <53F5F404.3000601@gmail.com>
Date: Thu, 21 Aug 2014 08:28:36 -0500
From: Michael Kerrisk <michael.kerrisk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.71 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer proudly announces:

    man-pages-3.71 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.71

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/08/man-pages-371-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.71 ====================

New and rewritten pages
-----------------------

group_member.3
    Michael Kerrisk
        New page documenting group_member(3)

isfdtype.3
    Michael Kerrisk
        New page documenting isfdtype(3)


Newly documented interfaces in existing pages
---------------------------------------------

perf_event_open.2
    Vince Weaver
        Document new comm_exec flag
            Linux 3.16 (more specifically, commit 82b897782d10fcc4 )
            added support for differentiating between process renames
            caused by exec versus those caused by other methods.
    Vince Weaver
        Document new mmap2 record type
            Linux 3.16 (more specifically, commit a5a5ba72843dd05f9 )
            enabled the enhanced mmap2 record support.
            The interface was added in Linux 3.12 but disabled until
            Linux 3.16.
    Vince Weaver
        Document PERF_SAMPLE_BRANCH_COND
            Linux 3.16 (more specifically, commit bac52139f0b7ab31330 )
            adds support for gathering PERF_SAMPLE_BRANCH_COND
            conditional branch values when doing PERF_SAMPLE_BRANCH_STACK
            sampling.

proc.5
    Michael Kerrisk
        Document /proc/PID/comm
    Michael Kerrisk
        Document /proc/PID/pagemap
    Michael Kerrisk
        Document /proc/PID/personality
    Michael Kerrisk
        Document /proc/PID/syscall
    Michael Kerrisk
        Document /proc/kpagecount
    Michael Kerrisk
        Document /proc/kpageflags
    Michael Kerrisk
        Document /proc/sys/vm/overcommit_kbytes

capabilities.7
    Michael Kerrisk
        Add CAP_AUDIT_READ
            CAP_AUDIT_READ is new in Linux 3.16.


Global changes
--------------

Various pages
    Michael Kerrisk
        Remove ancient Linux libc details

Various pages
    Michael Kerrisk
        NOTES: add "C library/kernel ABI differences" subheading


Changes to individual pages
---------------------------

access.2
    Michael Kerrisk
        Glibc falls back to using access() on kernels that lack faccessat()

chmod.2
    Michael Kerrisk
        Glibc falls back to chmod() on kernels that don't support fchmodat()
    Michael Kerrisk
        Glibc falls back to chown()/lchown() on kernels that lack fchownat()

epoll_wait.2
    Michael Kerrisk
        NOTES: describe raw epoll_pwait() system call differences

getrlimit.2
    Michael Kerrisk
        Describe the "large" resource limit bug on 32-bit platforms
            See https://bugzilla.kernel.org/show_bug.cgi?id=5042.
    Michael Kerrisk
        Glibc's setrlimit() and getrlimit() are implemented using prlimit()

link.2
    Michael Kerrisk
        Glibc falls back to link() on kernels that lack linkat()
            Unless 'flags' contains AT_SYMLINK_FOLLOW.

mkdir.2
    Michael Kerrisk
        Glibc falls back to mkdir() on kernels that don't support mkdirat()

perf_event_open.2
    Vince Weaver
        Clarify PERF_SAMPLE_STACK_USER usage
            This clarifies the PERF_SAMPLE_STACK_USER section.
            I found these issue while implementing some code that uses
            the option.  The important change is fixing the name of the
            sample_stack_user parameter, the rest is just some wording
            fixes and minor clarifications.
    Vince Weaver
        Clarify PERF_SAMPLE_DATA_SRC usage
            When checking the fields in the PERF_SAMPLE_DATA_SRC type samples
            you need to shift the masks before doing the compare.

            Although the value you are checking (perf_mem_data_src) is
            specified as a bitfield so this might all fall apart if trying
            to access the field in a cross-endian way.  The Power people
            were working on this issue, not sure if they resolved it.

poll.2
    Michael Kerrisk
        Describe fifth argument (sigsetsize) of raw ppoll() system call

readlink.2
    Michael Kerrisk
        Glibc falls back to readlink() on kernels that lack readlinkat()

rename.2
    Michael Kerrisk
        Glibc falls back to rename() when the kernel doesn't have renameat()

sigwaitinfo.2
    Michael Kerrisk
        The raw sigtimedwait() system call has a fifth argument

symlink.2
    Michael Kerrisk
        Glibc falls back to symlink() on kernels that lack symlinkat()

unlink.2
    Michael Kerrisk
        Glibc falls back to unlink() or rmdir() on kernels that lack unlinkat()

getauxval.3
    Michael Kerrisk
        Document ENOENT error
            And add an entry to BUGS explaining the ambiguity that was
            present before the addition of this error.

proc.5
    Jan Chaloupka
        Add missing proc stats fields
            Adding missing proc stats fields from
            https://www.kernel.org/doc/Documentation/filesystems/proc.txt
    Michael Kerrisk
        Update /proc/PID/stat 'state' field documentation
    Michael Kerrisk
        Improve description of /proc/PID/stat fields added in Linux 3.3 and 3.5
    Michael Kerrisk
        Rework discussion of CommitLimit and /proc/sys/vm/overcommit_memory
    Michael Kerrisk
        Improve discussion of /proc/sys/vm/overcommit_ratio

inotify.7
    Michael Kerrisk
        Note that IN_ONLY_DIR can be used to avoid races
    Michael Kerrisk
        Note that insertion of IN_MOVED_FROM+IN_MOVED_TO pair is not atomic
    Michael Kerrisk
        Mention use of timeout when reading IN_MOVED_TO after IN_MOVED_FROM

man-pages.7
    Michael Kerrisk
        Add description of "C library/kernel ABI differences" subsection

vdso.7
    Mike Frysinger
        Add new i386 vdso symbols in Linux 3.15

