Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3GOJ2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 05:28:07 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:51537 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab3GOJ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 05:28:05 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 15 Jul 2013 11:27:44 +0200
Message-ID: <CAKgNAkjEvsCp3uxnbHVk2LVoXe+tTsop9mav1mTh=0CvuAmmeA@mail.gmail.com>
Subject: man-pages-3.52 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.52 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.52

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2013/07/man-pages-352-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.52 ====================

Newly documented interfaces in existing pages
---------------------------------------------

perf_event_open.2
    Vince Weaver
        Add PERF_IOC_FLAG_GROUP documentation
            The perf_event_open() ENABLE/DISABLE/RESET ioctls can take an
            argument, PERF_IOC_FLAG_GROUP.  This wasn't documented at all
            until about a year ago (despite the support being there from
            the beginning) so I missed this when initially writing
            the man page.

socket.7
    Pavel Emelyanov, Michael Kerrisk
        Document SO_PEEK_OFF option
            Since Linux 3.4 there appeared an ability to specify the
            offset in bytes from which the data will be MSG_PEEK-ed.
            Describe this socket option in the socket(7) page, where
            all the other socket options are described.


Global changes
--------------

Various pages
    Peng Haitao
        ATTRIBUTES: Note functions that are thread-safe or thread-unsafe

Changes to individual pages
---------------------------

perf_event_open.2
    Vince Weaver
        Clarify the perf_event_open() wakeup_events/wakeup_watermark fields
            Clarify the perf_event_open() wakeup_events/wakeup_watermark
            fields a bit, based on info from kernel commit cfeb1d90a1b1.
    Vince Weaver
        Update to match the Linux 3.10 release
            This patch updates the perf_event_open() documentation to include
            new interfaces added in the 3.10 kernel.

            It also documents a few [To be documented] instances left over
            from the 3.7 kernel.
    Vince Weaver
        Small correction to description of 'flags' argument

alloca.3
    Adrian Bunk
        Correct information on getting non-inlined version with gcc+glibc
            - remove the incorrect information that -fno-builtin would help
            - add -std=c11 to the list of strict options
            - emphasize more that both the gcc option and not including
              alloca.h are needed
            - add the #ifdef from the glibc alloca.h to make the situation
              clearer

pthread_attr_setschedparam.3
pthread_attr_setschedpolicy.3
pthread_attr_setscope.3
    Michael Kerrisk  [Manuel Traut, Siddhesh Poyarekar]
        The inherit-scheduler attribute must be set to PTHREAD_EXPLICIT_SCHED
            In order for the attributes set by these functions to have
            an effect, the caller must use pthread_attr_setinheritsched(3)
            to set the inherit-scheduler attribute of the attributes object
            to PTHREAD_EXPLICIT_SCHED.

proc.5
    Michael Kerrisk
        Document /proc/[pid]/fd/ anon_inode symlinks
    Mike Frysinger
        Document /proc/[pid]/fd/ symlinks a bit more
            Describe the type:[inode] syntax used in this dir

bootparam.7
    Michael Kerrisk  [Dan Jacobson]
        Remove outdated text on LILO and LoadLin
            Strike the discussion of LILO and LoadLin, which
            are long obsolete, and make a brief mention of GRUB.
            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=604019
    Andrea Remondini
        Document the 'resume' boot parameter
