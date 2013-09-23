Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3IWO63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:58:29 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:46813 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3IWO62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:58:28 -0400
Message-ID: <52405702.9050603@gmail.com>
Date: Mon, 23 Sep 2013 16:58:10 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.54 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.54 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.54

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2013/09/man-pages-354-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.54 ====================

Newly documented interfaces in existing pages
---------------------------------------------

ioctl_list.2
    Zsbán Ambrus
        Document FAT_IOCTL_GET_ATTRIBUTES
            The attached patch adds four ioctls from linux/msdos_fs.h to the
            ioctl_list(2) manpage.

            The ioctl FAT_IOCTL_GET_ATTRIBUTES reads FAT attributes of a
            file a mounted vfat file system.  I tested this on Linux
            2.6.33, an example script can be found at
            http://www.perlmonks.com/?node_id=832623


Changes to individual pages
---------------------------

open.2
    Robert Harris
        Add mmap(2) to list of calls that fail when given an O_PATH descriptor
    Doug Goldstein
        Add EINVAL to errors list
            EINVAL can be returned by open(2) when the underlying filesystem
            doesn't support O_DIRECT. It is documented in the NOTES section
            but this patch adds it to the list of possible errors.

perf_event_open.2
    Vince Weaver
        PERF_SAMPLE_BRANCH_STACK updates
            This started out as just adding the new perf_event_open features
            from Linux 3.11 (which was the addition of transactional memory
            defines for PERF_SAMPLE_BRANCH_STACK samples) but turned into a
            general cleanup of the PERF_SAMPLE_BRANCH_STACK documentation.

            The main clarification is that at least one of the non-privilege
            values must be set or else perf_event_open() will return an EINVAL
            error.

setfsgid.2
    Michael Kerrisk  [Oleg Nesterov]
        Clarify description of return value
            More clearly describe the weirdness in the return value of this
            system call, and note the problems it creates in BUGS
    Michael Kerrisk
        Refer to setfsuid(2) for an explanation of why setfsgid() is obsolete

setfsuid.2
    Michael Kerrisk  [Oleg Nesterov]
        Clarify description of return value
            More clearly describe the weirdness in the return value of this
            system call, and note the problems it creates in BUGS
    Michael Kerrisk  [Chen Gang]
        Clarify historical details and note that setfsuid() is obsolete

wait.2
    Michael Kerrisk  [Hannes Landeholm]
        Add details on the fifth argument provided by raw waitid() system call
            See https://bugzilla.kernel.org/show_bug.cgi?id=60744

proc.5
    Peter Schiffer
        Document /proc/[pid]/io file
            Attempt to document fields in the /proc/[pid]/io file, based on
            the Documentation/filesystems/proc.txt. The text will probably
            need some grammar corrections.
    Michael Kerrisk  [Marko Myllynen]
        /proc/sys/fs/inode-max went away in Linux 2.4
            Also, the 'preshrink' field in /proc/sys/fs/inode-state became
            a dummy value in Linux 2.4.

            See https://bugzilla.kernel.org/show_bug.cgi?id=60836
    Michael Kerrisk  [A. Costa]
        Note block size used by /proc/partitions
            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=666972
    Michael Kerrisk
        Add rationale on drop_caches and note that it can hurt performance
            See also http://lwn.net/Articles/562211/

ip.7
    Simon Paillard
        IP_MULTICAST_IF setsockopt recognizes struct mreq (compatibility)
            Kernel added compatibility only recently in
            3a084ddb4bf299a6e898a9a07c89f3917f0713f7
            See: http://bugs.debian.org/607979

standards.7
    Michael Kerrisk
        Add mention of SUSv4-TC1 (POSIX.1-2013)

--
Michael Kerrisk
mtk.manpages@gmail.com
My next Linux/UNIX system programming course:
http://blog.man7.org/2013/09/linuxunix-system-programming-course.html
