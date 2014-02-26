Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaBZUzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:55:25 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36314 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbaBZUzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:55:21 -0500
Message-ID: <530E54B2.1040907@gmail.com>
Date: Wed, 26 Feb 2014 21:55:14 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.61 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.61 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.61

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/02/man-pages-361-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.61 ====================

New and rewritten pages
-----------------------

A note from Christoph Hellwig prompted me to perform a task that has
been queued for a while: merging the text of the man pages for the
*at([23]) ("directory file descriptor") APIs into their corresponding
traditional pages.  When the *at([23]) pages were originally written
(mostly in 2006), the APIs were not part of POSIX and (in most cases)
were not available on other systems. So, it made some sense to wall
them off into their own separate pages. Eight years later, with the
APIs now all in POSIX (except scandirat()), it is much more sensible
to document the newer APIs alongside their traditional counterparts,
so that the newer APIs are not "hidden", and the reader can more
easily see the differences between the APIs.

Thus, the text of 14 pairs of pages has been merged, and the "merged
from" pages have been converted to links to the "merged to" pages.
Along the way, a few other fixes were made to the pages, as noted
below.

One page that did not undergo such a change was utimensat(2), which
is different enough from utime(2) that it warrants a separate page.
Unlike the other *at() pages, the utimensat(2) page was also already
self-contained, rather than defining itself in terms of differences
from utime(2) as the other *at() pages did.

access.2
    Michael Kerrisk
        Merge text from faccessat(2)
    Michael Kerrisk
        Remove faccessat() race warning
            That point is already covered in existing text in this page.
    Michael Kerrisk
        access() also conforms to POSIX.1-2008

chmod.2
    Michael Kerrisk
        Merge text from fchmodat(2)
    Michael Kerrisk
        Use argument name 'pathname' throughout page
            (Some APIs were using 'path' while others used 'pathname')
    Michael Kerrisk
        CONFORMING TO: chmod() and fchmod() are also in POSIX.1-2008

chown.2
    Michael Kerrisk
        Merge text of fchownat(2)
    Michael Kerrisk
        AT_EMPTY_PATH is Linux-specific and requires _GNU_SOURCE
    Michael Kerrisk
        Use argument name 'pathname' throughout page
            (Some APIs were using 'path' while others used 'pathname')
    Michael Kerrisk
        Remove sentence that fchownat() is present on Solaris
            That point was only really relevant before fchownat() was
            standardized in POSIX.1.2008.
    Michael Kerrisk
        CONFORMING TO: chown(), fchown(), lchown() are in POSIX.1-2008

link.2
    Michael Kerrisk
        Merge text of linkat(2)
    Michael Kerrisk
        CONFORMING TO: link() is in POSIX.1-2008
    Michael Kerrisk
        AT_EMPTY_PATH is Linux-specific and requires _GNU_SOURCE

mkdir.2
    Michael Kerrisk
        Merge text of mkdirat(2)
    Michael Kerrisk
        CONFORMING TO: mkdir() is in POSIX.1-2008

mknod.2
    Michael Kerrisk
        Merge text of mknodat(2)
    Michael Kerrisk
        CONFORMING TO: mknod(2) is in POSIX.1-2008

open.2
    Michael Kerrisk
        Merge text from openat(2)
    Michael Kerrisk
        Remove sentence that openat() is present on Solaris
            That point was only really relevant before openat() was
            standardized in POSIX.1.2008.

readlink.2
    Michael Kerrisk
        Merge text of readlinkat(2)
    Michael Kerrisk
        CONFORMING TO: readlink() is in POSIX.1-2008.
    Michael Kerrisk
        Use argument name 'pathname' throughout page
            (Some APIs were using 'path' while others used 'pathname')

rename.2
    Michael Kerrisk
        Merge text of renameat(2)
    Michael Kerrisk
        CONFORMING TO: rename(2) is in POSIX.1-2008

stat.2
    Michael Kerrisk
        Merge text from fstatat(2)
    Michael Kerrisk
        AT_EMPTY_PATH and AT_NO_AUTOMOUNT are Linux-specific
            These flags require _GNU_SOURCE.
    Michael Kerrisk
        Use argument name 'pathname' throughout page
            (Some APIs were using 'path' while others used 'pathname')
    Michael Kerrisk
        Remove sentence that fstatat() is present on Solaris
            That point was only really relevant before fstatat() was
            standardized in POSIX.1.2008.
    Michael Kerrisk
        CONFORMING TO: stat(), fstat(), lstat() are specified in POSIX.1-2008

symlink.2
    Michael Kerrisk
        Merge text of symlinkat(2)
    Michael Kerrisk
        CONFORMING TO: symlink() is in POSIX.1-2008

unlink.2
    Michael Kerrisk
        Merge text of unlinkat(2)
    Michael Kerrisk
        Remove sentence that unlinkat() is present on Solaris
            That point was only really relevant before unlinkat() was
            standardized in POSIX.1.2008.
    Michael Kerrisk
        CONFORMING TO: unlink() is in POSIX.1-2008

mkfifo.3
    Michael Kerrisk
        Merge text of mkfifoat(3)
    Michael Kerrisk
        CONFORMING TO: mkfifo() is in POSIX.1-2008

scandir.3
    Michael Kerrisk
        Merge text of scandirat(3)
    Michael Kerrisk
        Update feature test macro requirements
            The FTM requirements changed in glibc 2.10.
    Michael Kerrisk
        Remove libc4/libc5 note under CONFORMING TO
            No-one much cares about Linux libc these days.
    Michael Kerrisk
        Put detail about alphasort under a NOTES heading
            This text was under CONFORMING TO, which made no sense.
    Michael Kerrisk
        Rework CONFORMING TO text


Newly documented interfaces in existing pages
---------------------------------------------

prctl.2
    Kir Kolyshkin
        Document PR_SET_MM options in Linux 3.5
            Some of the PR_SET_MM options were merged to vanilla kernel
            later, and appeared in Linux 3.5. Those are:

               - PR_SET_MM_ARG_START
               - PR_SET_MM_ARG_END
               - PR_SET_MM_ENV_START
               - PR_SET_MM_ENV_END
               - PR_SET_MM_AUXV
               - PR_SET_MM_EXE_FILE

socket.7
    Neil Horman
        Document the SO_RXQ_OVFL socket option
    Michael Kerrisk
    	Add kernel version number for SO_RXQ_OVFL


Changes to individual pages
---------------------------

alarm.2
    Michael Kerrisk
        Note semantics of alarm with respect to fork() and execve()

intro.2
    Michael Kerrisk
        Describe policy on documenting differences between syscall and glibc API

utime.2
    Michael Kerrisk
        Add note that modern applications probably want utimensat(2) etc.

getifaddrs.3
    Michael Kerrisk
        Enhance example program
            Print statistics for AF_PACKET interfaces.
            Add missing feature test macro definition.
            Reformat output.

resolv.conf.5
    Carlos O'Donell
        DESCRIPTION: mention that the data is trusted
            In a recent discussion about DNSSEC it was brought to my
            attention that not all system administrators may understand
            that the information in /etc/resolv.conf is fully trusted.
            The resolver implementation in glibc treats /etc/resolv.conf
            as a fully trusted source of DNS information and passes on
            the AD-bit for DNSSEC as trusted.

            This patch adds a clarifying sentence to make it absolutely
            clear that indeed this source of information is trusted.

packet.7
    Neil Horman
        Document PACKET_FANOUT_QM fanout mode
    Daniel Borkmann
        Improve PACKET_QDISC_BYPASS description

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
