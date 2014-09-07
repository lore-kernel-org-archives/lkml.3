Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaIGOAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 10:00:24 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37630 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaIGOAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 10:00:23 -0400
Message-ID: <540C64E0.2030201@gmail.com>
Date: Sun, 07 Sep 2014 07:00:00 -0700
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.72 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer proudly announces:

    man-pages-3.72 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.72

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/09/man-pages-372-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.72 ====================

New and rewritten pages
-----------------------

memusage.1
    Peter Schiffer, Michael Kerrisk  [Jan Chaloupka]
        New page for glibc memusage(1) command

memusagestat.1
    Peter Schiffer  [Jan Chaloupka, Michael Kerrisk]
        New page for glibc memusagestat(1) command

mtrace.1
    Peter Schiffer  [Jan Chaloupka]
        New page describing the glibc mtrace(1) command


Changes to individual pages
---------------------------

connect.2
    Michael Haardt
        Note that a new socket should be used if connect() fails

poll.2, select.2
    Rusty Russell
        Fix erroneous description of "available for write".
            POSIX says: "POLLOUT Normal data may be written without
            blocking.".  This "may" is misleading, see the POSIX
            write page:

                Write requests to a pipe or FIFO shall be handled in the
                same way as a regular file with the following exceptions:
                ...
                If the O_NONBLOCK flag is clear, a write request may cause
                the thread to block, but on normal completion it shall
                return nbyte.
                ...
                When attempting to write to a file descriptor (other than a
                pipe or FIFO) that supports non-blocking writes and cannot
                accept the data immediately:

                If the O_NONBLOCK flag is clear, write() shall block the
                calling thread until the data can be accepted.

                If the O_NONBLOCK flag is set, write() shall not block the
                thread. If some data can be written without blocking the
                thread, write() shall write what it can and return the
                number of bytes written. Otherwise, it shall return -1 and
                set errno to [EAGAIN].

            The net result is that write() of more than 1 byte on a
            socket, pipe or FIFO which is "ready" may block: write()
            (unlike read!) will attempt to write the entire buffer and
            only return a short write under exceptional circumstances.

            Indeed, this is the behaviour we see in Linux:

            https://github.com/rustyrussell/ccan/commit/897626152d12d7fd13a8feb36989eb5c8c1f3485
            https://plus.google.com/103188246877163594460/posts/BkTGTMHDFgZ

inotify.7
    Michael Kerrisk
        IN_OPEN and IN_CLOSE_NOWRITE can also occur for directories
    Michael Kerrisk
        IN_CLOSE_WRITE occurs only for files (not monitored directory)
    Michael Kerrisk
        IN_MODIFY is generated for files only (not monitored directories)
    Michael Kerrisk
        IN_ACCESS occurs only for files inside directories
            IN_ACCESS does not occur for monitored directory.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
