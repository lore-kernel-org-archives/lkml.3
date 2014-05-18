Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029AbaERKyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 06:54:36 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:61993 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaERKye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 06:54:34 -0400
Message-ID: <53789167.3090007@gmail.com>
Date: Sun, 18 May 2014 12:54:31 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.66 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer proudly announces:

    man-pages-3.66 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.66

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/05/man-pages-366-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.66 ====================

New and rewritten pages
-----------------------

fanotify_init.2
    Heinrich Schuchardt, Michael Kerrisk
        New page documenting fanotify_init(2)

fanotify_mark.2
    Heinrich Schuchardt, Michael Kerrisk
        New page documenting fanotify_mark(2)

sched_setscheduler.2
    Michael Kerrisk
        Page rewritten
            Stripped out the general scheduling material, which
            moved to sched(7), and rewrote much of the remainder.
            Changed copyright and license since pretty much all
            of the content was or is written by mtk.

fanotify.7
    Heinrich Schuchardt, Michael Kerrisk
        New page providing overview of the fanotify API

sched.7
    Michael Kerrisk
        New page providing an overview of the scheduling APIs
            Most of this content derives from sched_setscheduler(2). In
            preparation for adding a sched_setattr(2) page, it makes
            sense to isolate out this general content to a separate
            page that is referred to by the other scheduling pages.

Newly documented interfaces in existing pages
---------------------------------------------

fallocate.2
    Lukas Czerner [Michael Kerrisk]
        Document FALLOC_FL_ZERO_RANGE
            FALLOC_FL_ZERO_RANGE was added in Linux 3.14,
            for zeroing ranges in the allocated space in a file.

rename.2
    Miklos Szeredi [Michael Kerrisk]
        Document renameat2() system call added in Linux 3.15

shmop.2
    Michael Kerrisk
        Document SHM_EXEC


Changes to individual pages
---------------------------

link.2
    Michael Kerrisk  [Steven Stewart-Gallus]
        Document ENOENT error for linkat()
            See https://bugzilla.kernel.org/show_bug.cgi?id=73301

open.2
    Peter Schiffer
        Update note on alignment of user buffer and file offset for O_DIRECT
            The sentence in open(2) man page in notes for O_DIRECT flag:

                "Under Linux 2.6, alignment to 512-byte boundaries suffices."

            is not universally correct. The alignment is a property of the
            storage, for example, 4k-sector drives with no 512 byte sector
            emulation will be unable to perform 512-byte direct I/O.

read.2
    Michael Kerrisk
        BUGS: detail nonatomicity bug with respect to file offset updates
            This bug was fixed in Linux 3.14, with commit
            9c225f2655e36a470c4f58dbbc99244c5fc7f2d4
            See also http://thread.gmane.org/gmane.linux.kernel/1649458

semget.2
    Michael Kerrisk
        Consolidate discussion on noninitialization of semaphores
            The fact that semget() does not initialize the semaphores
            in a new set was covered in two places (in DESCRIPTION
            and BUGS). Consolidate these into one place (in NOTES)
            and also point out that POSIX.1-2008 says that a future
            version of the standard may require an implementation to
            initialize the semaphores to 0.

symlink.2
    Michael Kerrisk  [Steven Stewart-Gallus]
        Document ENOENT error for symlinkat()
            See https://bugzilla.kernel.org/show_bug.cgi?id=73301

write.2
    Michael Kerrisk
        BUGS: detail nonatomicity bug with respect to file offset updates
            This bug was fixed in Linux 3.14, with commit
            9c225f2655e36a470c4f58dbbc99244c5fc7f2d4
            See also http://thread.gmane.org/gmane.linux.kernel/1649458

packet.7
    Carsten Andrich  [Neil Horman]
        Improve sockopt documentation for packet sockets
    Carsten Andrich  [Willem de Bruijn]
        PACKET_LOSS has inverse meaning
    Stefan Puiu  [Daniel Borkmann, Carsten Andrich]
        Status in PACKET_RX_RING is actually a bit mask

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
