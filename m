Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab3CPQiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 12:38:09 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:42935 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3CPQiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 12:38:07 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sat, 16 Mar 2013 17:37:46 +0100
Message-ID: <CAKgNAkjPnRg7OHQ0EL+R2e7dD70m8V2y=UEVQ6BBrd3zLe89TQ@mail.gmail.com>
Subject: man-pages-3.50 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.50 - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.50

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2013/03/man-pages-350-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.50 ====================

New and rewritten pages
-----------------------

canonicalize_file_name.3
    Michael Kerrisk
        Rewrite page, adding much more detail


Changes to individual pages
---------------------------

fork.2
    Michael Kerrisk
        Port access permission bits (ioperm()) are turned off in the child

ioperm.2
    Michael Kerrisk
        Note that iopl() level of 3 is needed to access ports
    Michael Kerrisk
        'num' is *bits* not bytes!
    Michael Kerrisk
        Linux 2.6.8 lifted the port limit to 65,536
            See http://article.gmane.org/gmane.linux.kernel/202624/
            From: Stas Sergeev <stsp <at> aknet.ru>
            Subject: [patch][rfc] Larger IO bitmap
            Date: 2004-05-07 19:55:03 GMT
    Michael Kerrisk
        ioperm() operates on the calling *thread* (not process)
    Michael Kerrisk
        Clarify meaning of 'turn_on' argument
            Plus form formatting fixes.
    Michael Kerrisk
        Clarify that default state of permission bits in child is off
    Michael Kerrisk
        NOTES: add mention of /proc/ioports
    Michael Kerrisk
        SEE ALSO: add outb(2)

iopl.2
    Michael Kerrisk
        CAP_SYS_RAWIO is required to *raise* the I/O privilege level
    Michael Kerrisk
        Clarify that the two least significant bits of 'level' are what matter
    Michael Kerrisk
        SEE ALSO: add outb(2)

syscalls.2
    Michael Kerrisk
        Add version information for all (other) syscalls
    Michael Kerrisk
        Add perfmonctl(2)

random.4
    Elie De Brauwer
        Document write and document the ioctl interface of /dev/random
            The update consists out of two parts:
             - a minor thing which just documents what happens if a write to
               /dev/(u)random is performed, which is used in the example
               script but not explicitly mentioned.
             - the other (biggest) part is the documentation of the ioctl()
               interface which /dev/(u)random exposes. This ioctl() lives in
               drivers/char/random.c and the primitives can be found in
               include/linux/random.h

            One comment remains, there used to be an RNDGETPOOL ioctl() which
            disappeared in v2.6.9. I found two patches on the net:
            - http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.8.1/2.6.8.1-mm4/broken-out/dev-random-remove-rndgetpool-ioctl.patch
            - https://lkml.org/lkml/2004/3/25/168

            But as far as I can tell the first one got applied but the 2nd
            one seems more correct. The result is that even today one can
            still find traces of the RNDGETPOOL ioctl() in the header files.
            Is this there for historical reasons or because it might break
            userspace, even though using it will just give an EINVAL.

bootparam.7
    Jose Luis Domingo Lopez
        Document 'rootfstype' option
            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=182014

capabilities.7
    Michael Kerrisk
        Add various pieces under CAP_SYS_RAWIO
            Info obtained by grepping the kernel source.
    Michael Kerrisk
        Add CAP_SYS_RESOURCE /proc/PID/oom_score_adj case

netlink.7
    Andrey Vagin
        Add a note about broadcast messages to multiple groups
