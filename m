Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbaAKSgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:36:36 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:50467 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaAKSge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:36:34 -0500
Message-ID: <52D18F2F.8050706@gmail.com>
Date: Sun, 12 Jan 2014 07:36:31 +1300
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: mtk.manpages@gmail.com
Subject: man-pages-3.56 is released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.55 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.55

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2014/01/man-pages-356-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.56 ====================

New and rewritten pages
-----------------------

vdso.7
    Mike Frysinger
        New page documenting the vDSO mapped into each process by the kernel


Newly documented interfaces in existing pages
---------------------------------------------

reboot.2
    Elie De Brauwer
        Document LINUX_REBOOT_SW_SUSPEND


Changes to individual pages
---------------------------

close.2
    Michael Kerrisk  [P?draig Brady]
        Note that errors from close() should be used only for diagnosis
            In particular, retrying after EINTR is a bad idea.

            See http://austingroupbugs.net/view.php?id=529

            See http://thread.gmane.org/gmane.comp.lib.glibc.alpha/37702
            Subject: [RFC][BZ #14627] Make linux close errno to EINPROGRESS
                     when interrupted in signal.

perf_event_open.2
    Vince Weaver  [Sudhanshu Goswami]
        Clarify issues with the disabled bit
            Clarify the perf_event_open behavior with respect to the disabled
            bit and creating event groups.
    Vince Weaver  [Sudhanshu Goswami]
        Clarify issues with the exclusive bit
            Warn that using the perf_event_open "exclusive" bit, while
            it might seem like a good idea, might lead to all 0 results
            in some common usage cases.

setpgid.2
    Michael Kerrisk  [Joseph S. Myers]
        BSD getpgrp() and setpgrp() go away in glibc 2.19

socket.2
    Michael Kerrisk  [Dongsheng Song]
        Remove crufty statement that AF_INET does not support SOCK_SEQPACKET
            Linux AF_INET supports SOCK_SEQPACKET via SCTP.

dlopen.3
    Michael Kerrisk  [Mike Frysinger]
        Update remarks on cast needed when assigning dlsym() return value
            POSIX.1-2013 eases life when casting the dlsym() return value to a
            function pointer

setjmp.3
    Michael Kerrisk  [Joseph S. Myers]
        BSD setjmp() semantics go away in glibc 2.19

sigpause.3
    Michael Kerrisk  [Joseph S. Myers]
        BSD sigpause() goes away in glibc 2.19

credentials.7
    Michael Kerrisk
        List APIs that operate on process groups
    Michael Kerrisk
        Add details on controlling terminal and foreground/background jobs

feature_test_macros.7
    Michael Kerrisk
        Document _DEFAULT_SOURCE
    Michael Kerrisk  [Joseph S. Myers]
        From glibc 2.19, _BSD_SOURCE no longer causes __FAVOR_BSD
            Starting with glibc 2.19, _BSD_SOURCE no longer causes BSD
            definitions to be favored in cases where standards conflict.

man-pages.7
    Michael Kerrisk  [Mike Frysinger]
        Add STYLE GUIDE section
            Incorporate some of the existing material in the page
            into the STYLE GUIDE, and add a lot more material, mainly
            drawn from the "Global changes" sections in the release
            changelogs.
packet.7
    Willem de Bruijn  [Daniel Borkmann]
        Document fanout, ring, and auxiliary options
            This patch adds descriptions of the common packet socket options
              PACKET_AUXDATA, PACKET_FANOUT, PACKET_RX_RING, PACKET_STATISTICS,
              PACKET_TX_RING
            and the ring-specific options
              PACKET_LOSS, PACKET_RESERVE, PACKET_TIMESTAMP, PACKET_VERSION
    Michael Kerrisk
        Add kernel version numbers for PACKET_VERSION and PACKET_TIMESTAMP


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

