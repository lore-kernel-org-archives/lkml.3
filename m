Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab3CLGbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:31:48 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57450 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3CLGbr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:31:47 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 12 Mar 2013 07:31:26 +0100
Message-ID: <CAKgNAkgSpD2Cc71bT1w_sR52FyHR+H9ZCSj07KiC0ri=17XyGQ@mail.gmail.com>
Subject: man-pages-3.48 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.48 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.48

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.de/2013/03/man-pages-348-is-released_12.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.48 ====================

New and rewritten pages
-----------------------

getunwind.2
    Marcela Maslanova
        New page documenting getunwind(2)
            Taken from Red Hat downstream man pages set
    Michael Kerrisk
        Much rewriting
            Some text taken from arch/ia64/kernel/unwind.c.

perfmonctl.2
    Ivana Varekova
        New page documenting IA-64-specific perfmonctl(2)
            Taken from Red Hat downstream man pages
    Michael Kerrisk
        Rework discussion of PFM_CREATE_CONTEXT
        Add VERSIONS and CONFORMING TO
        Note that there is no glibc wrapper
        Remove PFM_CREATE_EVTSETS, PFM_DELETE_EVTSETS, PFM_GETINFO_EVTSETS
            These don't exist, and it appears they never have.
        Fix argument types for PFM_WRITE_PMCS, PFM_WRITE_PMDS, PFM_READ_PMDS
            The types that were being used don't exist!
        Briefly document PFM_GET_FEATURES, PFM_DEBUG, PFM_GET_PMC_RESET_VAL

gai.conf.5
    Ulrich Drepper
        New page documenting gai.conf
            Taken from Red Hat downstream pages

nss.conf.5
    Ulrich Drepper
        New page describing nss.conf


Newly documented interfaces in existing pages
---------------------------------------------

clock_getres.2
    Cyril Hrubis
        Document CLOCK_REALTIME_COARSE and CLOCK_MONOTONIC_COARSE
    Cyril Hrubis
        Document CLOCK_BOOTTIME
    Michael Kerrisk
        Some improvements to CLOCK_BOOTTIME description

ptrace.2
    Denys Vlasenko
        Document PTRACE_GETREGSET, PTRACE_SETREGSET, PTRACE_SEIZE, and friends
            Document PTRACE_GETREGSET, PTRACE_SETREGSET,
            PTRACE_SEIZE, PTRACE_INTERRUPT, and PTRACE_LISTEN.


Changes to individual pages
---------------------------

access.2
    Colin Walters
        Note that access() may also fail for FUSE
            Since in some cases (e.g. libguestfs's guestmount) it also has the
            semantics where files can appear owned by root, but are actually
            mutable by the user, despite what one might infer from the Unix
            permissions.

mmap.2
    Cyril Hrubis
        Add note about partial page in BUGS section
            This adds a note about Linux behavior with partial page at the end
            of the object. The problem here is that a page that contains only
            part of a file (because the file size is not multiple of PAGE_SIZE)
            stays in page cache even after the mapping is unmapped and the file
            is closed. So if some process dirties such page, other mappings
            will see the changes rather than zeroes.
    Michael Kerrisk  [Török Edwin]
        Some 'flags' values require a feature test macro to be defined
            Add text to NOTES noting that some MAP_* constants are
            defined only if a suitable feature test macro is defined.
            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=542601
    Cyril Hrubis
        Document EOVERFLOW error

prctl.2
    Cyrill Gorcunov
        Add some details for PR_GET_TID_ADDRESS

read.2
    Michael Kerrisk  [Zack Weinberg]
        Clarify interaction of count==0 and error checking
            POSIX deliberately leaves this case open, so the man
            page should be less specific about what happens.

            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=533232
    Michael Kerrisk  [Marc Lehmann]
        Remove crufty text about O_NONBLOCK on files
            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=700529

capabilities.7
    Andrey Vagin
        Nonexistent bits are no longer shown as set in /proc/PID/status Cap*

inotify.7
    Michael Kerrisk
        A monitoring process can't easily distinguish events triggered by itself

rtnetlink.7
    Pavel Emelyanov
        Add info about ability to create links with given index
            Since kernel v3.7 the RTM_NEWLINK message now accepts nonzero
            values in ifi_index field. Mention this fact in the respective
            rtnetlink.7 section.

socket.7
    Pavel Emelyanov
        SO_BINDTODEVICE is now readable
            SO_BINDTODEVICE is readable since since kernel 3.8.
