Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965432Ab3HHOeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:34:25 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:46971 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965243Ab3HHOeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:34:23 -0400
Message-ID: <5203AC6B.7090007@gmail.com>
Date: Thu, 08 Aug 2013 16:34:19 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.53 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.53 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.53

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2013/08/man-pages-353-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.53 ====================

New and rewritten pages
-----------------------

restart_syscall.2
    Michael Kerrisk
        New page for restart_syscall(2) system call


Newly documented interfaces in existing pages
---------------------------------------------

fchownat.2
    Michael Kerrisk
        Document AT_EMPTY_PATH

fstatat.2
    Michael Kerrisk
        Document AT_EMPTY_PATH

linkat.2
    Michael Kerrisk
        Document AT_EMPTY_PATH

open.2
    Michael Kerrisk [Al Viro]
        Document O_PATH
            See also https://bugzilla.redhat.com/show_bug.cgi?id=885740


Changes to individual pages
---------------------------

open.2
    Michael Kerrisk [Geoffrey Thomas]
        Remove warning that O_DIRECTORY is only for use with opendir(3)
            O_DIRECTORY can also be used with, for example, O_PATH.

perf_event_open.2
    Vince Weaver
        Improve PERF_SAMPLE_BRANCH_STACK documentation
    Vince Weaver
        Fix indentation of the MMAP layout section
            The indentation of the MMAP layout section wasn't quite right.
            I think this improves things but I admit I'm not an expert at the
            low-level indentation directives.
    Vince Weaver
        Update PERF_IOC_FLAG_GROUP info
            It turns out PERF_IOC_FLAG_GROUP was broken from 75f937f24bd9
            (in Linux 2.6.31, the initial perf_event release) until
            724b6daa1 (Linux 3.4).

            I've done some extensive kernel source code digging plus
            running tests of various kernels and I hope the info
            presented is accurate now.

            (Patch edited somewhat by mtk.)
    Vince Weaver
        Improve sysfs files documentation
            This improves the documentation of the various
            perf_event_open()-related sysfs files.

ptrace.2
    Denys Vlasenko  [Oleg Nesterov, Dmitry V. Levin]
        If SEIZE was used, initial auto-attach stop is EVENT_STOP
            For every PTRACE_O_TRACEfoo option, mention that old-style SIGSTOP
            is replaced by PTRACE_EVENT_STOP if PTRACE_SEIZE attach was used.

            Mention the same thing again in the description of
            PTRACE_EVENT_STOP.
    Denys Vlasenko  [Oleg Nesterov, Dmitry V. Levin]
        Mention that PTRACE_PEEK* libc API and kernel API are different
    Denys Vlasenko  [Oleg Nesterov, Dmitry V. Levin]
        Clarify PTRACE_INTERRUPT, PTRACE_LISTEN, and group-stop behavior

readlink.2
    Michael Kerrisk
        Document use of empty 'pathname' argument

capabilities.7
    Michael Kerrisk
        Add open_by_handle_at(2) under CAP_DAC_READ_SEARCH

ld.so.8
    Michael Kerrisk
        Rework rpath token expansion text
    Michael Kerrisk
        Describe $PLATFORM rpath token
    Michael Kerrisk
        Describe $LIB rpath token
    Michael Kerrisk
        Document LD_BIND_NOT

