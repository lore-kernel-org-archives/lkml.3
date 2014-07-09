Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbaGIPPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:15:32 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35392 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbaGIPP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:15:29 -0400
Message-ID: <53BD3E0B.6040901@gmail.com>
Date: Wed, 09 Jul 2014 15:05:15 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.70 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer proudly announces:

    man-pages-3.70 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.70

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/07/man-pages-370-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.70 ====================

Released: 2014-07-08, Munich


New and rewritten pages
-----------------------

sprof.1
    Michael Kerrisk [Marko Myllynen]
        New page for the glibc sprof(1) command


Newly documented interfaces in existing pages
---------------------------------------------

epoll_ctl.2
    NeilBrown
        Document EPOLLWAKEUP

epoll.7
    NeilBrown
        Document EPOLLWAKEUP


Changes to individual pages
---------------------------

dup.2
    Michael Kerrisk  [Rich Felker]
        Fix erroneous discussion regarding closing 'newfd' before calling dup2()
            And propose a workaround if the caller cares about catching
            close() time errors.

            See http://stackoverflow.com/questions/23440216/race-condition-when-using-dup2#comment36888604_23444465
            and http://austingroupbugs.net/view.php?id=411
    Michael Kerrisk
        Rework and enhance discussion of dup2()
            In particular, note that dup2() performs the steps of closing
            and reusing 'newfd' atomically.

epoll_ctl.2
    Michael Kerrisk
        BUGS: EPOLLWAKEUP is silently ignored without CAP_BLOCK_SUSPEND
            If the caller does not have CAP_BLOCK_SUSPEND, then EPOLLWAKEUP
            is silently ignored.

fcntl.2
    Michael Kerrisk  [Tomi Salminen]
        The return value for F_SETPIPE_SZ is the pipe capacity
    Michael Kerrisk
        ERRORS: Document ENOTDIR error for F_NOTIFY
    Michael Kerrisk
        Suggest the use of real-time signals with F_NOTIFY

inotify_add_watch.2
    Michael Kerrisk
        Clarify that the target of a watch is an i-node
            The target of a watch is an i-node, not a pathname. Clarify
            the text to prevent the reader possibly misunderstanding
            that establishing watches by two different links to the same
            file might create different watch descriptors.

open.2
    Michael Kerrisk  [Кирилл]
        O_CLOEXEC is also one the flags not ignored when O_PATH is specified

shmop.2
    Michael Kerrisk
        Explain SHMLBA in much more detail

syslog.2
    Michael Kerrisk
        Rework introductory paragraph
    Michael Kerrisk  [Robert P. J. Day]
        Rework text describing loglevels
            The kernel header file mentioned in the discussion of the KERN_*
            constants has morphed and is no longer exported inside glibc.
            And the definitions of the constants themselves changed subtly
            with kernel commit 04d2c8c83d0e3ac5f78aeede51babb3236200112.
            So, rewrite the description of the constants to be a bit more
            abstract.
    Michael Kerrisk
        Rewrite parts of the page, and import /proc/sys/kernel/printk
            * Move /proc/sys/kernel/printk from proc(5) to this page,
              and correct various details in the discussion of that file.
            * Rewrite and correct various other details on the page.
            * Clean out some crufty text.
            * Miscellaneous minor fixes.
    Michael Kerrisk
        Update SYSLOG_ACTION_CONSOLE_OFF + SYSLOG_ACTION_CONSOLE_ON description
            Details changed in Linux 2.6.32

inotify.7
    Michael Kerrisk
        Clarify which events are generated for watched directories
            Really, with respect to watched directories, events fall into
            three classes (not two, as was shown):

            * Events that can be generated only for the watched directory.
            * Events that can be generated only for objects that are inside
              the watched directory.
            * Events that can be generated both for the watched directory
              and for objects inside the directory.

            So, mark these three classes more clearly in the list of inotify
            events.
    Heinrich Schuchardt  [Michael Kerrisk]
        BUGS: Note possible bug triggered by watch descriptor reuse
            Watch descriptor IDs are returned by inotify_add_watch().
            When calling inotify_rm_watch() an IN_IGNORE is placed on the
            inotify queue pointing to the ID of the removed watch.

            inotify_add_watch() should not return a watch descriptor ID for
            which events are still on the queue but should return an
            unused ID.

            Unfortunately, the existing Kernel code does not provide such a
            guarantee.

            Actually, in rare cases watch descriptor IDs are returned by
            inotify_add_watch() for which events are still on the inotify
            queue.

            See https://bugzilla.kernel.org/show_bug.cgi?id=77111

pipe.7
    Elie De Brauwer
        Add reference that the pipe capacity can be changed
            In fcntl(2) F_SETPIPE_SZ, F_GETPIPE_SZ and
            /proc/sys/fs/pipe-max-size are defined, however
            pipe(7) still defines the pipe capacity as being
            a static entity. Adding a reference to fcntl(2).

ld.so.8
    Michael Kerrisk
        Clarify that LD_PROFILE can specify just a single shared object
    Michael Kerrisk
        Clarify that LD_PROFILE output is appended to target file
            The LD_PROFILE output is appended to any existing
            contents of the target file.
-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
