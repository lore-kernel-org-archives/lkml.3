Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaA3PJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:09:01 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:36166 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaA3PJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:09:00 -0500
Message-ID: <52EA6B09.6070704@gmail.com>
Date: Thu, 30 Jan 2014 16:08:57 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.57 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.57 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.57

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/01/man-pages-357-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

PS In passing, it's worth noting that the number of projects whose man pages
are rendered at http://man7.org/linux/man-pages/ has now grown to more than 70
(http://man7.org/linux/man-pages/dir_by_project.html).
The goal of these renderings is twofold:

* To provide a set of online renderings that are up to date (in many cases, 
  the pages are pulled directly from the corresponding source code repository
  when the online renderings are updated) and whose origin and timestamp are
  clearly documented on the rendered pages.

* To short circuit the task of reporting bugs in the man pages, all of the
  rendered pages add a COLOPHON that identifies the project home page and
  (in most cases) includes a specific email address for reporting bugs 
  or the URL of a project web page with instructions on how to report bugs.
  With luck, this means that users are more likely to actually report bugs
  in man pages.

I am open to adding further (relevant) projects to the set of rendered pages;
see http://blog.man7.org/2013/05/adding-further-man-pages-to-html.html

==================== Changes in man-pages-3.57 ====================

Released: 2014-01-24, Munich


Newly documented interfaces in existing pages
---------------------------------------------

msgop.2
    Michael Kerrisk
        Document MSG_COPY

open.2
    Michael Kerrisk, Andy Lutomirski
        Document O_TMPFILE
            O_TMPFILE is new in Linux 3.11

perf_event_open.2
    Vince Weaver  [Andi Kleen]
        PERF_SAMPLE_TRANSACTION support in Linux 3.13
            The following patch adds descriptions of the new perf_event_open.2
            PERF_SAMPLE_TRANSACTION sample type as added in Linux 3.13.

            The descriptions are based on information provided by Andi Kleen,
            both in the e-mail

                [PATCH 1/6] perf, core: Add generic transaction flags v5

            sent to the linux-kernel list as well as an e-mail

                [PATCH] Document transaction flags in perf_event_open manpage

            sent to the linux-man list.

            The implementation is based heavily on the Intel Haswell
            processor.  Documentation can be found at this page:
            http://software.intel.com/en-us/blogs/2013/05/03/intelr-transactional-synchronization-extensions-intelr-tsx-profiling-with-linux-0
            as well as in section 18.11.5.1 of volume 3 of the
            Intel 64 and IA-32 Architecture Software Developer's Manual.

ptrace.2
    Andrey Vagin
        Add description for PTRACE_PEEKSIGINFO
            Retrieve signals without removing them from a queue.
    Andrey Vagin
        Add description for PTRACE_GETSIGMASK and PTRACE_SETSIGMASK
            These two commands allow to examine and change mask of blocked
            signals.

socket.7
    Eliezer Tamir
        Add description for SO_BUSY_POLL
            Add description for the SO_BUSY_POLL socket option.

tcp.7
    Michael Kerrisk  [Jerry Chu]
        Document TCP_USER_TIMEOUT
            Text slightly adapted from Jerry Chu's (excellent) commit
            message (commit dca43c75e7e545694a9dd6288553f55c53e2a3a3).
    Michael Kerrisk
        Document TCP_CONGESTION


Changes to individual pages
---------------------------

faccessat.2
    Michael Kerrisk
        Note that the system call takes only three arguments

fallocate.2
    Michael Kerrisk
        Note filesystems that support  FALLOC_FL_PUNCH_HOLE operation

fcntl.2
    Michael Kerrisk
        BUGS: The O_SYNC and O_DSYNC flags are not modifiable using F_SETFL

lseek.2
    Michael Kerrisk
        Note which filesystems support SEEK_HOLE/SEEK_DATA

proc.5
    Michael Kerrisk
        Document /proc/[pid]/timers
    Michael Kerrisk
        Update discussion of wchan
            Remove crufty reference to /etc/psdatabase in /proc/PID/stat.
            Add /proc/PID/wchan.

            See https://bugs.launchpad.net/ubuntu/+source/manpages/+bug/737452

netdevice.7
    Tilman Schmidt
        Document SIOCGIFCONF case ifc_req==NULL
            Add the missing description of the possibility to call SIOCGIFCONF
            with ifc_req==NULL to determine the needed buffer size, as
            described in
            http://lkml.indiana.edu/hypermail/linux/kernel/0110.1/0506.html
            and verified against source files net/core/dev_ioctl.c and
            net/ipv4/devinet.c in the current kernel git tree.
            This functionality has been present since the beginning of the 2.6
            series. It's about time it gets documented.

tcp.7
    Michael Kerrisk
        Describe format of tcp_*_congestion_control /proc files
            Describe format of tcp_allowed_congestion_control and
            tcp_available_congestion_control.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
