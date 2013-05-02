Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab3EBHUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:20:13 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:40677 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3EBHUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:20:09 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 2 May 2013 09:19:48 +0200
Message-ID: <CAKgNAkg+31vfz4y7H=c4TPJ+g-rbOD+zHXe5OJV7p-+TTtR2Sg@mail.gmail.com>
Subject: man-pages-3.51 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.51 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.51

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.de/2013/04/man-pages-351-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.51 ====================

Newly documented interfaces in existing pages
---------------------------------------------

sched_rr_get_interval.2
    Michael Kerrisk
        Document /proc/sys/kernel/sched_rr_timeslice_ms

proc.5
    Pavel Emelyanov
        Document /proc/[pid]/map_files directory
            This directory was added in Linux v3.3 and provides info about
            files being mmap-ed in a way very similar to how /proc/[pid]/fd
            works.

            v2: Added examples of how links look like and noted dependency
            on kernel config option CONFIG_CHECKPOINT_RESTORE.
    Michael Kerrisk
        Document /proc/sys/kernel/shm_rmid_forced

capabilities.7
    Michael Kerrisk
        Document /proc/sys/kernel/cap_last_cap


Changes to individual pages
---------------------------

clone.2
    Michael Kerrisk  [Peter Schiffer]
        Add prototype for syscall to SYNOPSIS
            And further clarify the distinction between the system call
            and the wrapper function in the introductory text.
    Michael Kerrisk  [Mike Frysinger]
        Clarify differences between clone2() syscall and wrapper function
    Michael Kerrisk  [Mike Frysinger]
        Note those architectures where the sys_clone argument order differs
        Add short subsection noting that blackfin, m68k, and sparc are different

getcpu.2
    Michael Kerrisk
        Recommend that 'tcache' should be specified as NULL nowadays

syscall.2
    Changhee Han
        Add notes that caution users when passing arguments to syscall()
            For example, passing 'long long' on ARM-32 requires special
            treatment.
    Mike Frysinger [Michael Kerrisk]
        Document the exact calling convention for architecture system calls
    Mike Frysinger  [Kyle McMartin]
        Add PA-RISC details under calling conventions
    Michael Kerrisk  [Mike Frysinger]
        Refine discussion of ARM and other ABIs

readir.3
seekdir.3
telldir.3
    Michael Kerrisk
        Eliminate the implication that these functions deal with "offsets"
            The directory position dealt with by the readdir() and
            friends is not a simple file offset in modern file systems.
            Typically, it is some kind of cookie value. Add text and
            make other changes to these pages to eliminate the
            implication that this is an offset, and warn the reader
            that directory positions should be treated strictly as
            opaque values.

            In the process, rename the 'offset' argument of seekdir(3)
            to 'loc', and add some text to readdir(3) to note that
            the 'd_off' field is the same value returned by telldir(3)
            at the current directory position.

            See also https://lwn.net/Articles/544298/

ip.7
    Radek Pazdera
        Document IP_MULTICAST_ALL
