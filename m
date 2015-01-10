Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbbAJQSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 11:18:32 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41640 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbbAJQSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 11:18:31 -0500
Message-ID: <54B150D4.6060405@gmail.com>
Date: Sat, 10 Jan 2015 17:18:28 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.77 is released
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

The Linux man-pages maintainer proudly announces:

    man-pages-3.77 - man pages for Linux

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.77

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2015/01/man-pages-377-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.77 ====================


New and rewritten pages
-----------------------

seccomp.2
    Kees Cook, Michael Kerrisk, Will Drewry  [Andy Lutomirski]
        New page documenting seccomp(2)
            Combines documentation from prctl, in-kernel seccomp_filter.txt
            and dropper.c, along with details specific to the new system call.


Newly documented interfaces in existing pages
---------------------------------------------

netlink.7
    Stephan Mueller  [Michael Kerrisk]
        Add NETLINK_CRYPTO


Changes to individual pages
---------------------------

perf_event_open.2
    Vince Weaver
        Clarify the PERF_FLAG_FD_* flags
            This change clarifies the behavior of the PERF_FLAG_FD_OUTPUT and
            PERF_FLAG_FD_NO_GROUP flags to perf_event_open(), and removes
            the related FIXME comments.

            While writing tests to validate the behavior of these flags I
            discovered that PERF_FLAG_FD_OUTPUT has been broken since the
            2.6.35 kernel release.

prctl.2
    Dave Hansen [Michael Kerrisk]
        Add description of Intel MPX calls
            The 3.19 kernel will have support for Intel MPX, including
            a pair of new prctl() calls (PR_MPX_ENABLE_MANAGEMENT and
            PR_MPX_DISABLE_MANAGEMENT) for enabling and disabling the
            kernel's management of the "bounds tables".  Add a
            descriptions of the interface.

setns.2
pid_namespaces.7
    Mike Frysinger
        Elaborate discussion of the PID namespace descendant limitation
            The setns(2) man page already mentions that CLONE_NEWPID may only
            be used with descendant namespaces, but this nuance could be
            listed in a few more places so it is not missed.

sigaction.2
    Michael Kerrisk
        Add siginfo_t fields for SECCOMP_RET_TRAP

random.4
    Heinrich Schuchardt
        Describe handling of O_NONBLOCK
            /dev/random and /dev/urandom treat O_NONBLOCK differently.
            This should be described in the manpage.
    Heinrich Schuchardt
        Mention PRNG used by urandom
            /dev/urandom uses a pseudo-random number generator to replace
            missing entropy.

proc.5
    Michael Kerrisk
        Document "Seccomp" field of /proc/PID/status

tcp.7
    Troy Davis
        Clarify tcp_tw_recycle on Internet-facing hosts
            Clarify that tcp_tw_recycle will break communication with many
            general-purpose remote Internet hosts (namely, remote NAT devices)
            even when the Linux device itself is not behind NAT.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
