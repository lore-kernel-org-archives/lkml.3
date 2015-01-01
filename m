Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbbAAJAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 04:00:55 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:35512 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbbAAJAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 04:00:52 -0500
Message-ID: <54A50CBE.5040305@gmail.com>
Date: Thu, 01 Jan 2015 10:00:46 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.76 is released
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday, and Happy New Year,

We've just passed 12k commits in the project, and this release, 
my 158th, marks my recent tenth anniversary as maintainer of
the man-pages project. So ... the Linux man-pages maintainer 
proudly announces:

    man-pages-3.76 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.76

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2015/01/man-pages-376-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.76 ====================

Released: 2014-12-31, Munich


Contributors
------------

The following people contributed patches/fixes or (noted in brackets
in the changelog below) reports, notes, and ideas that have been
incorporated in changes in this release:

Adam Jiang <jiang.adam@gmail.com>
Andrea Balboni <andrea.balboni@unimore.it>
Andreas Schwab <schwab@suse.de>
Bernhard Walle <bernhard@bwalle.de>
Carlos O'Donell <carlos@redhat.com>
David Wragg <david@wragg.org>
Florian Westphal <fw@strlen.de>
Heinrich Schuchardt <xypron.glpk@gmx.de>
Huxiaoxiang <huxiaoxiang@huawei.com>
Jan Chaloupka <jchaloup@redhat.com>
Jonathan Wakely <jwakely@redhat.com>
Jonny Grant <jg@jguk.org>
Josh Triplett <josh@joshtriplett.org>
Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Laurent Georget <laurent.georget@supelec.fr>
Manuel López-Ibáñez <lopezibanez@gmail.com>
Marko Myllynen <myllynen@redhat.com>
Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>
Mel Gorman <mgorman@suse.de>
Michael Gehring <mg@ebfe.org>
Michael Haardt <michael@moria.de>
Michael Kerrisk <mtk.manpages@gmail.com>
Mike Frysinger <vapier@gentoo.org>
Rasmus Villemoes <rv@rasmusvillemoes.dk>
Richard Weinberger <richard@nod.at>
Rich Felker <dalias@libc.org>
Scott Harvey <scott.harvey@stonybrook.edu>
Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Simon Newton <nomis52@gmail.com>
Simon Paillard <spaillard@debian.org>
Sven Hoexter <sven@stormbind.net>
Tobias Werth <werth@cs.fau.de>
Weijie Yang <weijie.yang.kh@gmail.com>
Will Newton <will.newton@linaro.org>
Yuri Kozlov <yuray@komyakino.ru>
刘湃 <liupai_work@163.com>
尹杰 <writalnaie@gmail.com>

Apologies if I missed anyone!


New and rewritten pages
-----------------------

adjtimex.2
    Laurent Georget
        Add fields in struct timex description
            This patch updates the man page with the new fields added in
            struct timex since last edition of the man page.
    Laurent Georget [Michael Kerrisk]
        Document ADJ_TAI
    Michael Kerrisk
        Improve description of ADJ_OFFSET_SINGLESHOT
    Michael Kerrisk
        Add brief documentation of ADJ_MICRO and ADJ_NANO
    Michael Kerrisk
        Reformat return value list
            And remove numeric values, since they're not needed
    Michael Kerrisk
        Other 'modes' bits are ignored on ADJ_OFFSET_*
            Other bits in 'modes' are ignored if modes contains
            ADJ_OFFSET_SINGLESHOT or ADJ_OFFSET_SS_READ.
    Michael Kerrisk
        Add nanosecond details
            Fixes https://bugzilla.kernel.org/show_bug.cgi?id=61171.
    Michael Kerrisk
        Document ADJ_OFFSET_SS_READ
    Michael Kerrisk
        Reformat 'times' flags as list
            And remove numeric values, since they're not needed.
    Michael Kerrisk
        Note effect of ADJ_NANO for ADJ_SETOFFSET
    Michael Kerrisk
        Add comment noting that timex structure contains padding bytes
    Michael Kerrisk
        Add more details to description of 'tai' field
    Michael Kerrisk
        Note meaning of "PLL" abbreviation
    Michael Kerrisk
        Clarify which 'timex' field is used by each 'modes' bit
    Michael Kerrisk
        Document timex 'status' bits
    Michael Kerrisk
        Clarify treatment of other 'modes' bits for ADJ_OFFSET_*
    Michael Kerrisk
        Update RFC number: RFC 5905 obsoletes RFC 1305
    Michael Kerrisk
        Briefly document ADJ_SETOFFSET
    Michael Kerrisk
        Note PPS (pulse per second) fields in timex structure

sigreturn.2
    Michael Kerrisk
        Add (a lot) more detail on the signal trampoline
            And rewrite much of the page.


Newly documented interfaces in existing pages
---------------------------------------------

proc.5
    Bernhard Walle
        Document /proc/thread-self
            /proc/thread-self has been introduced in Linux 3.17 with
            commit 0097875bd41528922fb3bb5f348c53f17e00e2fd.
    Sven Hoexter [Michael Kerrisk, Kamezawa Hiroyuki]
        Document "VmSwap" field of /proc/[pid]/status
    Florian Westphal
        Document /proc/net/netfilter/nfnetlink_queue


Changes to individual pages
---------------------------

clock_nanosleep.2
    Michael Kerrisk
        Note that 'clock_id' can also be a CPU clock ID

epoll_ctl.2
    Michael Kerrisk
        Regular files and directories can't be monitored with epoll_ctl()

madvise.2
    Michael Kerrisk
        VERSIONS: Support for madvise() is now configurable
            Support for this system call now depends on the
            CONFIG_ADVISE_SYSCALLS configuration option.

open.2
    Michael Kerrisk
        Enhance rationale discussion for openat() and friends

posix_fadvise.2
    Mel Gorman
        Document the behavior of partial page discard requests
            It is not obvious from the interface that partial page discard'
            requests are ignored. It should be spelled out.
    Michael Kerrisk  [Weijie Yang]
        ERRORS: Since 2.6.16, the kernel correctly deals with the ESPIPE case
    Michael Kerrisk
        Support for fadvise64() is now configurable
            Support for this system call now depends on the
            CONFIG_ADVISE_SYSCALLS configuration option.

prctl.2
    Andreas Schwab
        Correct description of null-termination in PR_GET_NAME and PR_SET_NAME
            The size of the process name has always been at most 16 byte
            _including_ the null terminator.  This also means that the
            name returned by PR_GET_NAME is always null-terminated.
    Michael Kerrisk
        PR_SET_NAME silently truncates strings that exceed 16 bytes

restart_syscall.2
    Michael Kerrisk
        Add some text explaining why restart_syscall() exists

sched_setaffinity.2
    Michael Kerrisk
        NOTES: Add paragraph on how to discover set of CPUs available on system

setsid.2
    Michael Kerrisk
        Rewrite some pieces and add some details
            Among other changes, add an explanation of why setsid() can't
            be called from a process group leader

sigaction.2
    Michael Kerrisk
        Document SA_RESTORER
    Michael Kerrisk
        Add some detail on the sa_restorer field

syscalls.2
    Michael Kerrisk
        3.19 adds execveat()
    Michael Kerrisk
        Add bpf(2) to list

tee.2
    Michael Kerrisk
        Add shell session demonstrating use of the example program

tkill.2
    Michael Kerrisk  [Rich Felker]
        Remove bogus text saying tgid==-1 makes tgkill() equivalent to tkill()

abort.3
    Michael Kerrisk
        Note that SIGABRT is raised as though raise(3) is called
            Also note that abort() is POSIX.1-2008 compliant.

mq_open.3
    Michael Kerrisk
        Document the O_CLOEXEC flag

fanotify.7
    Heinrich Schuchardt
        Allow relative paths in example
            The current example code requires passing an absolute
            path to the mount to be watched.

            By passing AT_FDCWD to fanotify_mark it can use both
            absolute and relative paths.
    Heinrich Schuchardt
        fallocate(2) creates no events
            fallocate(2) should create FAN_MODIFY events but does not.
    Heinrich Schuchardt [Michael Kerrisk]
        fanotify notifies only events generated on the same mount
            Unfortunately, fanotify does not inform listeners for all paths
            under which a touched filesystem object is visible, but only the
            listener using the same path as the process touching the
            filesystem object.
    Heinrich Schuchardt
        Update BUGS to note bugs still not fixed in 3.17
            I bumped the Linux version number in the BUGS section to 3.17.

inotify.7
    Heinrich Schuchardt
        fallocate(2) does not trigger inotify events
            Calling fallocate(2) does not result in inotify events.

signal.7
    Michael Kerrisk
        Mention other "slow devices"
            Reads from eventfd(2), signalfd(2), timerfd(2), inotify(7),
            and fanotify(7) file descriptors are also slow operations
            that are restartable.
    Michael Kerrisk
        Fix SO_RECVTIMEO/ SO_SENDTIMEO confusion in text
    Michael Kerrisk
        Since Linux 3.8, reads on inotify(7) file descriptors are restartable
    Michael Kerrisk
        inotify(7) reads no longer show the odd EINTR error after SIGCONT
            Since kernel 3.7, reads from inotify(7) file descriptors no longer
            show the (Linux oddity) behavior of failing with EINTR when the
            process resumes after a stop signal + SIGCONT.

ld.so.8
    Carlos O'Donell
        Add --inhibit-cache option
    Jonathan Wakely  [Siddhesh Poyarekar]
        Correct documentation of $ORIGIN
            See http://stackoverflow.com/questions/26280738/what-is-the-equivalent-of-loader-path-for-rpath-specification-on-linux/26281226#26281226


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
